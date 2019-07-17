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

public enum PaymentRootViewControllerAssembly {

    // MARK: - Public
    public static func makeViewController(paymentInputData: PaymentInputData, paymentDelegate: PaymentDelegate) -> UIViewController {
        let rootViewController = PaymentRootViewController()

        rootViewController.systemInfoProvider = SystemInfoAssembly.makeSystemInfo()
        rootViewController.transitionConfigurator = TransitionConfiguratorAssembly.makeFormSheetModalTransitionConfigurator()

        rootViewController.configure()

        let router = PaymentRouterAssembly.makeRouter(
            rootViewController: rootViewController,
            paymentInputData: paymentInputData,
            paymentDelegate: paymentDelegate
        )

        // Make strong reference to router, leaving it alive until root view controller is deallocated.
        // It's a bit hacky way, but we won't create a property on root view controller just to store
        // router there. Root view controller should know nothing about router.
        objc_setAssociatedObject(rootViewController, &AssociatedObjectKey.router, router, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return rootViewController
    }

    // MARK: - Private
    private enum AssociatedObjectKey {
        static var router: Int32 = 0
    }
}
