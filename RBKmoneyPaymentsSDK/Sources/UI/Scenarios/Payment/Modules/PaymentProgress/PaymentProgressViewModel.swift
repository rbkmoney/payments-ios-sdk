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
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let userInteractionFinished: Signal<Void>
        let userInteractionFailed: Signal<Error>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.userInteractionFinished
            .emit(to: userInteractionFinishedRelay)
            .disposed(with: disposable)

        input.userInteractionFailed
            .emit(to: userInteractionFailedRelay)
            .disposed(with: disposable)

        let paidRoute = moduleActionObservable.compactMap { event -> PaymentRoute? in
            guard let action = event.element, case let .finishPayment(invoice, payment) = action else {
                return nil
            }
            return .paidInvoice(.init(invoice: invoice, payment: payment))
        }

        let unpaidRoute = moduleActionObservable.compactMap { event -> PaymentRoute? in
            guard let error = event.error as? PaymentError else {
                return nil
            }
            return .unpaidInvoice(error)
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

    private(set) lazy var startUserInteraction = moduleActionObservable
        .compactMap { event -> UserInteractionDTO? in
            guard let action = event.element, case let .requestUserInteraction(userInteraction) = action else {
                return nil
            }
            return userInteraction
        }
        .asSignal(onError: .never)

    // MARK: - Private
    fileprivate enum ModuleAction {
        case finishPayment(InvoiceDTO, PaymentDTO)
        case requestUserInteraction(UserInteractionDTO)
    }

    private lazy var moduleActionObservable = inputDataObservable
        .flatMap { [remoteAPI, activityTracker, errorHandlerProvider, waitUserInteractionResult] data -> Observable<Event<ModuleAction>> in
            let createPayment: Single<PaymentDTO>

            switch data.parameters.source {
            case let .resource(resource, email):
                createPayment = remoteAPI.createPayment(
                    paymentParameters: .init(
                        flow: .instant,
                        payer: .paymentResource(
                            .init(
                                paymentToolToken: resource.paymentToolToken,
                                paymentSessionIdentifier: resource.paymentSessionIdentifier,
                                contactInfo: ContactInfoDTO(email: email, phoneNumber: nil)
                            )
                        )
                    ),
                    invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                    invoiceAccessToken: data.paymentInputData.invoiceAccessToken
                )
            case let .payment(payment):
                createPayment = .just(payment)
            }

            return createPayment
                .asObservable()
                .retry(using: errorHandlerProvider)
                .catchError {
                    switch data.parameters.source {
                    case let .resource(resource, email):
                        let invoice = data.parameters.invoice
                        throw PaymentError(.cannotCreatePayment, underlyingError: $0, invoice: invoice, paymentResource: resource, payerEmail: email)
                    case let .payment(payment):
                        throw PaymentError(.cannotCreatePayment, underlyingError: $0, invoice: data.parameters.invoice, payment: payment)
                    }
                }
                .trackActivity(activityTracker)
                .flatMap { payment -> Observable<ModuleAction> in
                    let events = Observable<Int>
                        .timer(.seconds(1), period: .seconds(2), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                        .flatMapLatest { _ in
                            remoteAPI.obtainInvoiceEvents(
                                invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                                invoiceAccessToken: data.paymentInputData.invoiceAccessToken
                            )
                        }
                        .retry(using: errorHandlerProvider)
                        .catchError {
                            throw PaymentError(.cannotObtainInvoiceEvents, underlyingError: $0, invoice: data.parameters.invoice, payment: payment)
                        }

                    let firstPhaseAction = events
                        .compactMap { events -> ModuleAction? in
                            if let userInteraction = ActionMapper.userInteractionAction(payment: payment, events: events) {
                                return userInteraction
                            } else {
                                return try ActionMapper.paymentAction(inputData: data, payment: payment, events: events)
                            }
                        }
                        .take(1)
                        .trackActivity(activityTracker)

                    let secondPhaseAction = waitUserInteractionResult(data.parameters.invoice, payment)

                    let thirdPhaseAction = events
                        .compactMap { try ActionMapper.paymentAction(inputData: data, payment: payment, events: $0) }
                        .take(1)
                        .trackActivity(activityTracker)

                    return Observable.concat(firstPhaseAction, secondPhaseAction, thirdPhaseAction)
                }
                .materialize()
        }
        .share()

    private typealias WaitUserInteractionResult = (InvoiceDTO, PaymentDTO) -> Observable<ModuleAction>

    private lazy var waitUserInteractionResult: WaitUserInteractionResult = { [userInteractionFinishedRelay, userInteractionFailedRelay] in
        let (invoice, payment) = ($0, $1)

        return userInteractionFailedRelay
            .map { throw PaymentError(.userInteractionFailed, underlyingError: $0, invoice: invoice, payment: payment) }
            .takeUntil(userInteractionFinishedRelay.take(1))
    }

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private let userInteractionFinishedRelay = PublishRelay<Void>()
    private let userInteractionFailedRelay = PublishRelay<Error>()
    private let activityTracker = ActivityTracker()
}

private enum ActionMapper {

    static func paymentAction(inputData: PaymentProgressInputData,
                              payment: PaymentDTO,
                              events: [InvoiceEventDTO]) throws -> PaymentProgressViewModel.ModuleAction? {

        return try events
            .sorted { $0.createdAt > $1.createdAt }
            .flatMap {
                try $0.changes.compactMap { change -> PaymentProgressViewModel.ModuleAction? in
                    switch change {
                    case let .invoiceStatusChanged(status) where status == .paid:
                        return .finishPayment(inputData.parameters.invoice, payment)
                    case let .invoiceStatusChanged(status) where status == .cancelled:
                        throw PaymentError(.invoiceCancelled, invoice: inputData.parameters.invoice, payment: payment)
                    case let .paymentStatusChanged(data) where data.paymentIdentifier == payment.identifier && data.status == .cancelled:
                        let error = data.error.map { NetworkError(.serverError($0)) }
                        throw PaymentError(.paymentCancelled, underlyingError: error, invoice: inputData.parameters.invoice, payment: payment)
                    case let .paymentStatusChanged(data) where data.paymentIdentifier == payment.identifier && data.status == .failed:
                        let error = data.error.map { NetworkError(.serverError($0)) }
                        throw PaymentError(.paymentFailed, underlyingError: error, invoice: inputData.parameters.invoice, payment: payment)
                    default:
                        return nil
                    }
                }
            }
            .first
    }

    static func userInteractionAction(payment: PaymentDTO, events: [InvoiceEventDTO]) -> PaymentProgressViewModel.ModuleAction? {
        return events
            .sorted { $0.createdAt > $1.createdAt }
            .flatMap {
                $0.changes.compactMap { change -> PaymentProgressViewModel.ModuleAction? in
                    guard case let .paymentInteractionRequested(data) = change, data.paymentIdentifier == payment.identifier else {
                        return nil
                    }
                    return .requestUserInteraction(data.userInteraction)
                }
            }
            .first
    }
}
