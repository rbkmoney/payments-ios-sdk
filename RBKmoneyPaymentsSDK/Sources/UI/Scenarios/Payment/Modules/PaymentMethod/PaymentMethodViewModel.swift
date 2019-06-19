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

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let didSelectItem: Signal<Item>
    }

    func setup(with input: Input) -> Disposable {
        let continueRoute = input.didSelectItem
            .asObservable()
            .withLatestFrom(invoice) { ($0, $1) }
            .map { tuple -> PaymentRoute in
                let (item, invoice) = tuple

                switch item.method {
                case .bankCard:
                    return .bankCard(invoice, item.paymentSystems)
                case .applePay:
                    return .applePay(invoice, item.paymentSystems)
                }
            }

        let cancelRoute = input.didTapCancel
            .asObservable()
            .map(to: PaymentRoute.cancel)

        return Observable
            .merge(continueRoute, cancelRoute)
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
        .map { $0.shopName }
        .asDriver(onError: .never)

    private(set) lazy var invoice = inputDataObservable
        .flatMap { [remoteAPI, activityTracker] data -> Single<InvoiceDTO> in
            let invoice = remoteAPI.obtainInvoice(
                invoiceIdentifier: data.invoiceIdentifier,
                invoiceAccessToken: data.invoiceAccessToken
            )
            return invoice.trackActivity(activityTracker)
        }
        .asDriver(onError: .never)

    private(set) lazy var items = inputDataObservable
        .flatMap { [remoteAPI, activityTracker, methodsMapper] data -> Single<[Item]> in
            let methods = remoteAPI.obtainInvoicePaymentMethods(
                invoiceIdentifier: data.invoiceIdentifier,
                invoiceAccessToken: data.invoiceAccessToken
            )
            return methods.map({ methodsMapper(data, $0) }).trackActivity(activityTracker)
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private lazy var methodsMapper = { [applePayInfoProvider] (data: PaymentMethodInputData, methods: [PaymentMethodDTO]) -> [Item] in
        var result = [Item]()

        // ApplePay
        // 1. Host application has requested ApplePay method
        // 2. Host application has provided MerchantIdentifier
        // 3. Server supports ApplePay tokenized card data with non-zero count of payment systems
        // 4. Device supports ApplePay with provided payment systems
        if data.allowedPaymentMethods.contains(.applePay) && data.applePayMerchantIdentifier != nil {
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
        if data.allowedPaymentMethods.contains(.bankCard) {
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

        return result
    }

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private let activityTracker = ActivityTracker()
}
