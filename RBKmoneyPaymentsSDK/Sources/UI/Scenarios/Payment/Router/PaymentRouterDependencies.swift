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

protocol PaymentRouterRootViewControllerTransitionConfigurator {

    var pushTransitionStyle: TransitionStyle { get set }
}

protocol PaymentRouterRootViewController {

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool, transitionStyle: TransitionStyle)
    func pushViewController(_ viewController: UIViewController, animated: Bool, transitionStyle: TransitionStyle)
}

extension PaymentRouterRootViewController {

    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        setViewControllers(viewControllers, animated: animated, transitionStyle: .default)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewController(viewController, animated: animated, transitionStyle: .default)
    }
}
