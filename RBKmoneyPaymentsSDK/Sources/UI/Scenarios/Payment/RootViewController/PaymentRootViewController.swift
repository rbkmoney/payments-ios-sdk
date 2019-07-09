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
    lazy var transitionConfigurator: UIViewControllerTransitioningDelegate = deferred()

    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return systemInfoProvider.isPhoneDevice ? [.portrait, .portraitUpsideDown] : .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Internal
    func configure() {
        setupNavigationBar()
        setupPresentation()
    }

    // MARK: - Private
    private func setupUI() {
        view.clipsToBounds = true
        view.layer.cornerRadius = systemInfoProvider.isPhoneDevice ? 0 : Constants.cornerRadius
    }

    private func setupNavigationBar() {
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

    private func setupPresentation() {
        if systemInfoProvider.isPhoneDevice {
            modalPresentationStyle = .fullScreen
        } else {
            modalPresentationStyle = .custom
            transitioningDelegate = transitionConfigurator
            preferredContentSize = CGSize(width: Constants.preferredContentWidth, height: CGFloat.greatestFiniteMagnitude)
        }
    }

    private enum Constants {
        static let preferredContentWidth: CGFloat = 420
        static let cornerRadius: CGFloat = 13
    }
}
