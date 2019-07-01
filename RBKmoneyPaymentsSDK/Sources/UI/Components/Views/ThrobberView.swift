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

import RxCocoa
import RxSwift
import UIKit

final class ThrobberView: UIView {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Internal
    func startAnimating() {
        guard !activityIndicatorView.isAnimating else {
            return
        }

        activityIndicatorView.startAnimating()

        isHidden = false
        ignoreFinishedFlag = false

        UIView.animate(
            withDuration: Constants.fadeAnimationDuration,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.containerView.alpha = 1
            }
        )
    }

    func stopAnimating() {
        guard activityIndicatorView.isAnimating else {
            return
        }

        activityIndicatorView.stopAnimating()

        ignoreFinishedFlag = true

        UIView.animate(
            withDuration: Constants.fadeAnimationDuration,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.containerView.alpha = 0
            },
            completion: { isFinished in
                if isFinished || self.ignoreFinishedFlag {
                    self.isHidden = true
                }
            }
        )
    }

    // MARK: - Private
    private func initialize() {
        isHidden = true
        ignoreFinishedFlag = true

        with(containerView) {
            $0.alpha = 0
        }

        with(circleView) {
            $0.backgroundColor = Palette.colors.throbberCircle
            $0.cornerRadius = Constants.circleSide / 2
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        with(activityIndicatorView) {
            $0.hidesWhenStopped = false
            $0.color = Palette.colors.throbber
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [circleView, activityIndicatorView].forEach {
            containerView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: Constants.circleSide),
            circleView.heightAnchor.constraint(equalToConstant: Constants.circleSide),
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        embedSubview(containerView)
    }

    private var ignoreFinishedFlag: Bool = false
    private let containerView = UIView()
    private let circleView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView()
}

private enum Constants {

    static let fadeAnimationDuration: TimeInterval = 0.25
    static let circleSide: CGFloat = 40
}

extension Reactive where Base: ThrobberView {

    var isAnimating: Binder<Bool> {
        return Binder(base) { base, isAnimating in
            if isAnimating {
                base.startAnimating()
            } else {
                base.stopAnimating()
            }
        }
    }
}
