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

/// Сборка, предоставляющая статический метод для создания корневого вьюконтроллера сценария "Payment".
public enum PaymentRootViewControllerAssembly {

    /// Создает корневой вьюконтроллер для сценария "Payment".
    ///
    /// Последовательность действий для отображения пользователю UI оплаты инвойса включает в себя:
    ///
    /// * создание корневого вьюконтроллера с указанием параметров и делегата
    /// * представление пользователю UI сценария модально методом
    ///   [UIViewController.present(_:animated:completion:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621380-present)
    /// * реализация методов делегата, вызываемых при отмене и завершении платежа
    /// * скрытие UI сценария после обработки отмены/завершения платежа методом
    ///   [UIViewController.dismiss(animated:completion:)](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss)
    ///
    /// - Parameter paymentInputData: Набор входных параметров для сценария
    ///
    /// - Parameter paymentDelegate: Объект, реализующий протокол делегата сценария "Payment". Сценарий будет иметь слабую ссылку на этот объект,
    ///   поэтому ответственность за время жизни этого объекта целиком и полностью лежит на вызывающем коде
    ///
    /// - Returns: Сконфигурированный корневой вьюконтроллер сценария
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

    private enum AssociatedObjectKey {
        static var router: Int32 = 0
    }
}
