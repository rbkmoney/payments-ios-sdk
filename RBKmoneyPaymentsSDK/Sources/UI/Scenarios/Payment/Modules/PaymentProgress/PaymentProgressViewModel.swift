// Copyright 2019 RBKmoney
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import RxCocoa
import RxSwift

final class PaymentProgressViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: PaymentProgressInputData = deferred()
    lazy var remoteAPI: PaymentProgressRemoteAPI = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let didFinishUserInteraction: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.didFinishUserInteraction
            .emit(to: didFinishUserInteractionRelay)
            .disposed(with: disposable)

        let paidRoute = actions.compactMap { action -> PaymentRoute? in
            if case let .finish(invoice, payment) = action {
                return .paidInvoice(.init(invoice: invoice, payment: payment))
            }
            return nil
        }
        let unpaidRoute = actions.compactMap { action -> PaymentRoute? in
            if case let .cancel(invoice) = action {
                return .unpaidInvoice(.init(invoice: invoice))
            }
            if case let .fail(invoice) = action {
                return .unpaidInvoice(.init(invoice: invoice))
            }
            return nil
        }
        let cancelRoute = input.didTapCancel
            .asObservable()
            .map(to: PaymentRoute.cancel)

        Observable
            .merge(paidRoute, unpaidRoute, cancelRoute)
            .bind(to: Binder(self) {
                $0.router.trigger(route: $1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Internal
    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    private(set) lazy var startUserInteraction = actions
        .compactMap { action -> UserInteractionDTO? in
            guard case let .requestUserInteraction(userInteraction) = action else {
                return nil
            }
            return userInteraction
        }
        .asSignal(onError: .never)

    // MARK: - Private
    fileprivate enum Action {
        case finish(InvoiceDTO, PaymentDTO)
        case cancel(InvoiceDTO)
        case fail(InvoiceDTO)
        case requestUserInteraction(UserInteractionDTO)
    }

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private lazy var actions: Observable<Action> = inputDataObservable
        .flatMap { [remoteAPI, activityTracker, didFinishUserInteractionRelay] data -> Observable<Action> in
            let resource = PayerDTO.PaymentResource(
                paymentToolToken: data.parameters.paymentResource.paymentToolToken,
                paymentSessionIdentifier: data.parameters.paymentResource.paymentSessionIdentifier,
                contactInfo: ContactInfoDTO(email: data.parameters.payerEmail, phoneNumber: nil)
            )
            let payment = remoteAPI.createPayment(
                paymentParameters: PaymentParametersDTO(flow: .instant, payer: .paymentResource(resource)),
                invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                invoiceAccessToken: data.paymentInputData.invoiceAccessToken
            )

            return payment
                .trackActivity(activityTracker)
                .flatMap { payment -> Observable<Action> in
                    let events = Observable<Int>
                        .timer(.seconds(1), period: .seconds(3), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                        .flatMapLatest { _ in
                            remoteAPI.obtainInvoiceEvents(
                                invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                                invoiceAccessToken: data.paymentInputData.invoiceAccessToken
                            )
                        }

                    let firstPhaseAction = events
                        .compactMap { events -> Action? in
                            if let userInteraction = ActionMapper.userInteractionAction(events: events, payment: payment) {
                                return userInteraction
                            } else {
                                return ActionMapper.commonAction(events: events, payment: payment, inputData: data)
                            }
                        }
                        .take(1)
                        .trackActivity(activityTracker)

                    let secondPhaseAction = Observable<Action>
                        .never()
                        .takeUntil(didFinishUserInteractionRelay.take(1))

                    let thirdPhaseAction = events
                        .compactMap { ActionMapper.commonAction(events: $0, payment: payment, inputData: data) }
                        .take(1)
                        .trackActivity(activityTracker)

                    return Observable.concat(firstPhaseAction, secondPhaseAction, thirdPhaseAction)
                }
        }
        .share()

    private let didFinishUserInteractionRelay = PublishRelay<Void>()
    private let activityTracker = ActivityTracker()
}

private enum ActionMapper {

    static func commonAction(events: [InvoiceEventDTO],
                             payment: PaymentDTO,
                             inputData: PaymentProgressInputData) -> PaymentProgressViewModel.Action? {

        return events
            .sorted { $0.createdAt > $1.createdAt }
            .flatMap {
                $0.changes.compactMap { change -> PaymentProgressViewModel.Action? in
                    switch change {
                    case let .invoiceStatusChanged(status) where status == .paid:
                        return .finish(inputData.parameters.invoice, payment)
                    case let .invoiceStatusChanged(status) where status == .cancelled:
                        return .cancel(inputData.parameters.invoice)
                    case let .paymentStatusChanged(data) where data.paymentIdentifier == payment.identifier && data.status == .cancelled:
                        return .cancel(inputData.parameters.invoice)
                    case let .paymentStatusChanged(data) where data.paymentIdentifier == payment.identifier && data.status == .failed:
                        return .fail(inputData.parameters.invoice)
                    default:
                        return nil
                    }
                }
            }
            .first
    }

    static func userInteractionAction(events: [InvoiceEventDTO], payment: PaymentDTO) -> PaymentProgressViewModel.Action? {
        return events
            .sorted { $0.createdAt > $1.createdAt }
            .flatMap {
                $0.changes.compactMap { change -> PaymentProgressViewModel.Action? in
                    guard case let .paymentInteractionRequested(data) = change, data.paymentIdentifier == payment.identifier else {
                        return nil
                    }
                    return .requestUserInteraction(data.userInteraction)
                }
            }
            .first
    }
}
