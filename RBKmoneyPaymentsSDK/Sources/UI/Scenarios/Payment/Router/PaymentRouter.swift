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

import Foundation

enum PaymentRoute: Route {

    case paymentMethod
    case bankCard(InvoiceDTO, Set<PaymentSystem>)
    case applePay(InvoiceDTO, Set<PaymentSystem>)
    case cancel
    case finish(PaymentMethod)
}

final class PaymentRouter: Router {

    // MARK: - Dependencies
    lazy var rootViewControllerProvider: PaymentRouterRootViewControllerProvider = deferred()
    lazy var paymentInputData: PaymentInputData = deferred()
    lazy var paymentDelegate: PaymentDelegate = deferred() // swiftlint:disable:this weak_delegate

    // MARK: - Internal
    func configure() {
        trigger(route: .paymentMethod)
    }

    // MARK: - Router
    func trigger(route: PaymentRoute) {
        switch route {
        case .paymentMethod:
            let module = paymentMethodAssembly.makeViewController(router: anyRouter, inputData: paymentInputData)
            rootViewControllerProvider.rootViewController?.viewControllers = [module]
        case let .bankCard(invoice, paymentSystems):
            print("Display BankCard module with invoice: \(invoice), payment systems: \(paymentSystems)")
        case let .applePay(invoice, paymentSystems):
            print("Display ApplePay module with invoice: \(invoice), payment systems: \(paymentSystems)")
        case .cancel:
            paymentDelegate.paymentCancelled(invoiceIdentifier: paymentInputData.invoiceIdentifier)
        case let .finish(paymentMethod):
            paymentDelegate.paymentFinished(invoiceIdentifier: paymentInputData.invoiceIdentifier, paymentMethod: paymentMethod)
        }
    }

    // MARK: - Private
    private lazy var paymentMethodAssembly = PaymentMethodAssembly()
}
