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

final class PaymentMethodViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: PaymentMethodInputData = deferred()
    lazy var remoteAPI: PaymentMethodRemoteAPI = deferred()
    lazy var applePayInfoProvider: PaymentMethodApplePayInfoProvider = deferred()
    lazy var errorHandlerProvider: ErrorHandlerProvider = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let didSelectItem: Signal<Item>
    }

    func setup(with input: Input) -> Disposable {
        let continueRoute = input.didSelectItem
            .asObservable()
            .withLatestFrom(invoice) { item, invoice -> PaymentRoute in
                switch item.method {
                case .bankCard:
                    return .bankCard(.init(invoice: invoice, paymentSystems: item.paymentSystems))
                case .applePay:
                    return .applePay(.init(invoice: invoice, paymentSystems: item.paymentSystems))
                }
            }

        let cancelRoute = input.didTapCancel
            .asObservable()
            .map(to: PaymentRoute.cancel)

        let unpaidRoute = moduleDataObservable
            .compactMap { $0.error as? PaymentError }
            .map { PaymentRoute.unpaidInvoice($0) }

        return Observable
            .merge(continueRoute, cancelRoute, unpaidRoute)
            .bind(to: Binder(self) {
                $0.router.trigger(route: $1)
            })
    }

    // MARK: - Internal
    struct Item {
        let method: PaymentMethod
        fileprivate let paymentSystems: Set<PaymentSystem>
    }

    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    private(set) lazy var invoice = moduleDataObservable
        .compactMap { $0.element?.invoice }
        .asDriver(onError: .never)

    private(set) lazy var items = moduleDataObservable
        .compactMap { $0.element?.items }
        .asDriver(onError: .never)

    // MARK: - Private
    struct ModuleData {
        let invoice: InvoiceDTO
        let items: [Item]
    }

    private lazy var moduleDataObservable = inputDataObservable
        .flatMap { [remoteAPI, activityTracker, errorHandlerProvider, invoiceMapper, methodsMapper] data -> Observable<Event<ModuleData>> in
            let obtainInvoice = remoteAPI.obtainInvoice(
                invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                invoiceAccessToken: data.paymentInputData.invoiceAccessToken
            )

            return obtainInvoice
                .retry(using: errorHandlerProvider)
                .catchError { throw PaymentError(.cannotObtainInvoice, underlyingError: $0) }
                .map(invoiceMapper)
                .flatMap { invoice -> Single<ModuleData> in
                    let obtainInvoicePaymentMethods = remoteAPI.obtainInvoicePaymentMethods(
                        invoiceIdentifier: data.paymentInputData.invoiceIdentifier,
                        invoiceAccessToken: data.paymentInputData.invoiceAccessToken
                    )

                    return obtainInvoicePaymentMethods
                        .retry(using: errorHandlerProvider)
                        .catchError { throw PaymentError(.cannotObtainInvoicePaymentMethods, underlyingError: $0, invoice: invoice) }
                        .map { ModuleData(invoice: invoice, items: try methodsMapper(data, invoice, $0)) }
                }
                .asObservable()
                .materialize()
                .trackActivity(activityTracker)
        }
        .share(replay: 1)

    private typealias InvoiceMapper = (InvoiceDTO) throws -> InvoiceDTO

    private lazy var invoiceMapper: InvoiceMapper = { invoice in
        let currentDate = Date()

        guard invoice.status == .unpaid else {
            throw PaymentError(.unexpectedInvoiceStatus, invoice: invoice)
        }

        guard invoice.dueDate > currentDate else {
            throw PaymentError(.invoiceExpired, invoice: invoice)
        }

        return invoice
    }

    private typealias MethodsMapper = (PaymentMethodInputData, InvoiceDTO, [PaymentMethodDTO]) throws -> [Item]

    private lazy var methodsMapper: MethodsMapper = { [applePayInfoProvider] data, invoice, methods in
        var result = [Item]()

        // ApplePay
        // 1. Host application has requested ApplePay method
        // 2. Host application has provided MerchantIdentifier
        // 3. Server supports ApplePay tokenized card data with non-zero count of payment systems
        // 4. Device supports ApplePay with provided payment systems
        if data.paymentInputData.allowedPaymentMethods.contains(.applePay) && data.paymentInputData.applePayMerchantIdentifier != nil {
            let paymentSystems = methods.flatMap { item -> [PaymentSystem] in
                guard case let .bankCard(paymentSystems, .some(tokenProviders)) = item, tokenProviders.contains(.applePay) else {
                    return []
                }
                return paymentSystems
            }
            if paymentSystems.isEmpty == false && applePayInfoProvider.applePayAvailability(for: paymentSystems) != .unavailable {
                result.append(Item(method: .applePay, paymentSystems: Set(paymentSystems)))
            }
        }

        // BankCard
        // 1. Host application has requested BankCard method
        // 2. Server supports non-zero count of payment systems
        if data.paymentInputData.allowedPaymentMethods.contains(.bankCard) {
            let paymentSystems = methods.flatMap { item -> [PaymentSystem] in
                guard case let .bankCard(paymentSystems, .none) = item else {
                    return []
                }
                return paymentSystems
            }
            if paymentSystems.isEmpty == false {
                result.append(Item(method: .bankCard, paymentSystems: Set(paymentSystems)))
            }
        }

        guard result.isEmpty == false else {
            throw PaymentError(.noPaymentMethods, invoice: invoice)
        }

        return result
    }

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private let activityTracker = ActivityTracker()
}
