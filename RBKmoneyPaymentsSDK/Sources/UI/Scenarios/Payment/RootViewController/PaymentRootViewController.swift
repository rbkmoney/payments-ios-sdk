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

final class PaymentRootViewController: UINavigationController {

    // MARK: - Dependencies
    lazy var systemInfoProvider: PaymentRootViewControllerSystemInfoProvider = deferred()

    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return systemInfoProvider.isPhoneDevice ? [.portrait, .portraitUpsideDown] : .all
    }

    // MARK: - Internal
    func configure() {
        let screenSize = systemInfoProvider.deviceScreenSize

        preferredContentSize = CGSize(
            width: Constants.preferredContentWidth,
            height: (min(screenSize.width, screenSize.height) * Constants.preferredContentHeightFactor).rounded()
        )

        modalTransitionStyle = .coverVertical
        modalPresentationStyle = systemInfoProvider.isPhoneDevice ? .fullScreen : .formSheet
        modalPresentationCapturesStatusBarAppearance = systemInfoProvider.isPhoneDevice

        with(navigationBar) {
            $0.barStyle = .default
            $0.isTranslucent = false

            $0.tintColor = Palette.colors.topBarIcons

            $0.setBackgroundImage(UIImage.color(Palette.colors.topBarBackground, options: .resizable), for: .any, barMetrics: .default)
            $0.shadowImage = UIImage.color(.clear, options: .resizable)

            $0.titleTextAttributes = [
                .foregroundColor: Palette.colors.screenTitle,
                .font: Palette.fonts.screenTitle
            ]

            let backButtonImage = R.image.common.back()

            $0.backIndicatorImage = backButtonImage
            $0.backIndicatorTransitionMaskImage = backButtonImage
        }
    }
}

private enum Constants {

    static let preferredContentWidth: CGFloat = 375
    static let preferredContentHeightFactor: CGFloat = 0.8
}
