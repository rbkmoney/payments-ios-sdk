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

final class FormSheetPresentationController: UIPresentationController {

    // MARK: - Overrides
    override func presentationTransitionWillBegin() {
        containerView?.embedSubview(dimmingView)
        containerView?.sendSubviewToBack(dimmingView)

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let preferredSize = container.preferredContentSize

        let defaultSize = CGSize(
            width: (parentSize.width * Constants.childContentSizeFactor).rounded(),
            height: (parentSize.height * Constants.childContentSizeFactor).rounded()
        )

        return CGSize(
            width: preferredSize.width > 0 ? min(preferredSize.width, defaultSize.width) : defaultSize.width,
            height: preferredSize.height > 0 ? min(preferredSize.height, defaultSize.height) : defaultSize.height
        )
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let parentSize = containerView?.bounds.size else {
            return .zero
        }

        let childSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: parentSize)

        return CGRect(
            origin: CGPoint(x: ((parentSize.width - childSize.width) / 2).rounded(), y: ((parentSize.height - childSize.height) / 2).rounded()),
            size: childSize
        )
    }

    // MARK: - Private
    private let dimmingView = with(UIView()) {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
        $0.alpha = 0
    }

    private enum Constants {
        static let childContentSizeFactor: CGFloat = 0.85
    }
}
