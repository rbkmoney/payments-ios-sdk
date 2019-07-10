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

import UIKit

final class PaymentRouterDefaultRootViewController: PaymentRouterRootViewController {

    // MARK: - Types
    typealias TransitionConfigurator = PaymentRouterRootViewControllerTransitionConfigurator & UINavigationControllerDelegate

    // MARK: - Initialization
    init(navigationController: UINavigationController, transitionConfigurator: TransitionConfigurator) {
        self.navigationController = navigationController
        self.transitionConfigurator = transitionConfigurator

        navigationController.delegate = transitionConfigurator
    }

    // MARK: - PaymentRouterRootViewController
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, transitionStyle: TransitionStyle) {
        transitionConfigurator.transitionStyle = transitionStyle
        navigationController?.setViewControllers(viewControllers, animated: animated)
    }

    var viewControllers: [UIViewController] {
        return navigationController?.viewControllers ?? []
    }

    // MARK: - Private
    private var transitionConfigurator: PaymentRouterRootViewControllerTransitionConfigurator

    private weak var navigationController: UINavigationController?
}

final class PaymentRouterDefaultPaymentDelegate: PaymentDelegate {

    // MARK: - Initialization
    init(paymentDelegate: PaymentDelegate) {
        self.paymentDelegate = paymentDelegate
    }

    // MARK: - PaymentDelegate
    func paymentCancelled(invoiceIdentifier: String) {
        paymentDelegate?.paymentCancelled(invoiceIdentifier: invoiceIdentifier)
    }

    func paymentFinished(invoiceIdentifier: String, paymentMethod: PaymentMethod) {
        paymentDelegate?.paymentFinished(invoiceIdentifier: invoiceIdentifier, paymentMethod: paymentMethod)
    }

    // MARK: - Private
    private weak var paymentDelegate: PaymentDelegate?
}

extension NavigationTransitionConfigurator: PaymentRouterRootViewControllerTransitionConfigurator {
}
