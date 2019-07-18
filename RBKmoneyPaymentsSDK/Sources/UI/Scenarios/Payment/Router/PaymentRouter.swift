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

    case initial
    case paymentMethod
    case bankCard(BankCardInputData.Parameters)
    case applePay(ApplePayInputData.Parameters)
    case paymentProgress(PaymentProgressInputData.Parameters)
    case paidInvoice(PaidInvoiceInputData.Parameters)
    case unpaidInvoice(UnpaidInvoiceInputData.Parameters)
    case back
    case cancel
    case finish(PaymentMethod)
}

final class PaymentRouter: Router {

    // MARK: - Dependencies
    lazy var rootViewController: PaymentRouterRootViewController = deferred()
    lazy var paymentInputData: PaymentInputData = deferred()
    lazy var paymentDelegate: PaymentDelegate = deferred() // swiftlint:disable:this weak_delegate

    // MARK: - Internal
    func configure() {
        trigger(route: .initial)
    }

    // MARK: - Router
    func trigger(route: PaymentRoute) {
        switch route {
        case .initial:
            let inputData = PaymentMethodInputData(paymentInputData: paymentInputData)
            let module = paymentMethodAssembly.makeViewController(router: anyRouter, inputData: inputData)
            rootViewController.setViewControllers([module], animated: true, transitionStyle: .default)

        case .paymentMethod:
            let modules = Array(rootViewController.viewControllers.prefix(1))
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .default)

        case let .bankCard(parameters):
            let inputData = BankCardInputData(parameters: parameters, paymentInputData: paymentInputData)
            let module = bankCardAssembly.makeViewController(router: anyRouter, inputData: inputData)
            let modules = Array(rootViewController.viewControllers.prefix(1)) + [module]
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .default)

        case let .applePay(parameters):
            let inputData = ApplePayInputData(parameters: parameters, paymentInputData: paymentInputData)
            let module = applePayAssembly.makeViewController(router: anyRouter, inputData: inputData)
            let modules = Array(rootViewController.viewControllers.prefix(1)) + [module]
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .default)

        case let .paymentProgress(parameters):
            let inputData = PaymentProgressInputData(parameters: parameters, paymentInputData: paymentInputData)
            let module = paymentProgressAssembly.makeViewController(router: anyRouter, inputData: inputData)
            let modules = Array(rootViewController.viewControllers.prefix(2)) + [module]
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .fade)

        case let .paidInvoice(parameters):
            let inputData = PaidInvoiceInputData(parameters: parameters, paymentInputData: paymentInputData)
            let module = paidInvoiceAssembly.makeViewController(router: anyRouter, inputData: inputData)
            rootViewController.setViewControllers([module], animated: true, transitionStyle: .default)

        case let .unpaidInvoice(parameters):
            let inputData = UnpaidInvoiceInputData(parameters: parameters, paymentInputData: paymentInputData)
            let module = unpaidInvoiceAssembly.makeViewController(router: anyRouter, inputData: inputData)
            let modules = Array(rootViewController.viewControllers.prefix(2)) + [module]
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .default)

        case .back:
            let modules = Array(rootViewController.viewControllers.dropLast())
            rootViewController.setViewControllers(modules, animated: true, transitionStyle: .default)

        case .cancel:
            paymentDelegate.paymentCancelled(invoiceIdentifier: paymentInputData.invoiceIdentifier)

        case let .finish(paymentMethod):
            paymentDelegate.paymentFinished(invoiceIdentifier: paymentInputData.invoiceIdentifier, paymentMethod: paymentMethod)
        }
    }

    // MARK: - Private
    private lazy var paymentMethodAssembly = PaymentMethodAssembly()
    private lazy var bankCardAssembly = BankCardAssembly()
    private lazy var applePayAssembly = ApplePayAssembly()
    private lazy var paymentProgressAssembly = PaymentProgressAssembly()
    private lazy var paidInvoiceAssembly = PaidInvoiceAssembly()
    private lazy var unpaidInvoiceAssembly = UnpaidInvoiceAssembly()
}
