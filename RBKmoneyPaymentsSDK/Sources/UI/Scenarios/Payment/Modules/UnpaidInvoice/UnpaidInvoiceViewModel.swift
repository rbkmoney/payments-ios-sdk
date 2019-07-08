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

final class UnpaidInvoiceViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: UnpaidInvoiceInputData = deferred()
    lazy var errorMessageFactory: UnpaidInvoiceErrorMessageFactory = deferred()
    lazy var paymentErrorMapper: UnpaidInvoicePaymentErrorMapper = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let didTapHelp: Signal<Void>
        let didTapRetry: Signal<Void>
        let didTapReenterData: Signal<Void>
        let didTapRestartScenario: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        let retryRoute = input.didTapRetry
            .asObservable()
            .withLatestFrom(retryRouteObservable)

        let reenterDataRoute = input.didTapReenterData
            .asObservable()
            .withLatestFrom(reenterDataRouteObservable)

        let restartScenarioRoute = input.didTapRestartScenario
            .asObservable()
            .withLatestFrom(restartScenarioRouteObservable)

        let cancelRoute = input.didTapCancel
            .asObservable()
            .map(to: .cancel as PaymentRoute?)

        return Observable
            .merge(retryRoute, reenterDataRoute, restartScenarioRoute, cancelRoute)
            .compactMap { $0 }
            .bind(to: Binder(self) {
                $0.router.trigger(route: $1)
            })
    }

    // MARK: - Internal
    enum InvoiceStatus {
        case unpaid
        case cancelled
        case paid
        case refunded
    }

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    private(set) lazy var invoice = inputDataObservable
        .compactMap { $0.parameters.invoice }
        .asDriver(onError: .never)

    private(set) lazy var errorDescription = inputDataObservable
        .map { [errorMessageFactory] inputData -> String in
            let error = inputData.parameters.underlyingError ?? inputData.parameters
            return errorMessageFactory.errorMessage(for: error)
        }
        .asDriver(onError: .never)

    private(set) lazy var canRetry = retryRouteObservable
        .map { $0 != nil }
        .asDriver(onError: .never)

    private(set) lazy var canReenterData = reenterDataRouteObservable
        .map { $0 != nil }
        .asDriver(onError: .never)

    private(set) lazy var canRestartScenario = restartScenarioRouteObservable
        .map { $0 != nil }
        .asDriver(onError: .never)

    private(set) lazy var invoiceStatus = inputDataObservable
        .map { inputData -> InvoiceStatus in
            guard inputData.parameters.code == .unexpectedInvoiceStatus, let invoice = inputData.parameters.invoice else {
                return .unpaid
            }
            return invoice.status.status
        }
        .asDriver(onError: .never)

    // MARK: - Private
    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private lazy var retryRouteObservable = inputDataObservable.map { [paymentErrorMapper] inputData -> PaymentRoute? in
        paymentErrorMapper.retryRoute(for: inputData.parameters)
    }

    private lazy var reenterDataRouteObservable = inputDataObservable.map { [paymentErrorMapper] inputData -> PaymentRoute? in
        paymentErrorMapper.reenterDataRoute(for: inputData.parameters)
    }

    private lazy var restartScenarioRouteObservable = inputDataObservable.map { [paymentErrorMapper] inputData -> PaymentRoute? in
        paymentErrorMapper.restartScenarioRoute(for: inputData.parameters)
    }
}

private extension InvoiceStatusDTO {

    var status: UnpaidInvoiceViewModel.InvoiceStatus {
        switch self {
        case .unpaid:
            return .unpaid
        case .cancelled:
            return .cancelled
        case .paid, .fulfilled:
            return .paid
        case .refunded:
            return .refunded
        }
    }
}
