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

    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.userInterfaceIdiom.isPhone ? [.portrait, .portraitUpsideDown] : .all
    }

    // MARK: - Private
    private func setupUI() {
        preferredContentSize = CGSize(width: 375, height: round(min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.8))
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = UIDevice.current.userInterfaceIdiom.isPhone ? .fullScreen : .formSheet
        modalPresentationCapturesStatusBarAppearance = UIDevice.current.userInterfaceIdiom.isPhone

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

private extension UIUserInterfaceIdiom {

    var isPhone: Bool {
        return self == .phone
    }
}
