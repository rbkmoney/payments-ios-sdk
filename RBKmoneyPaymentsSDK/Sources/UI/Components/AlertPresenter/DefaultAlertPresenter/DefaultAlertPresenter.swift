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

import RxSwift
import UIKit

final class DefaultAlertPresenter: AlertPresenter {

    // MARK: - Initialization
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }

    // MARK: - Internal
    func presentAlert(content: AlertContent) -> Single<AlertContent.Button.Action> {
        return createAlert(for: content).retryWhen { errors -> Observable<Void> in
            return errors.flatMap { error -> Observable<Void> in
                guard error is Error else {
                    throw error
                }
                return Observable.just(()).delaySubscription(.milliseconds(500), scheduler: MainScheduler.instance)
            }
        }
    }

    // MARK: - Private
    private func createAlert(for content: AlertContent) -> Single<AlertContent.Button.Action> {
        let worker = Single<AlertContent.Button.Action>.create { singleAction in
            guard let viewController = self.parentViewController else {
                assertionFailure("Can't present alert, apparently parent view controller is already deallocated")
                singleAction(.error(Error.internalInconsistency))
                return Disposables.create()
            }

            guard viewController.presentedViewController == nil else {
                singleAction(.error(Error.doublePresentation))
                return Disposables.create()
            }

            let alertController = UIAlertController(title: content.title, message: content.message, preferredStyle: .alert)

            content.buttons.forEach { button in
                alertController.addAction(UIAlertAction(title: button.title, style: button.style.alertActionStyle) { _ in
                    singleAction(.success(button.action))
                })
            }

            viewController.present(alertController, animated: true)

            return Disposables.create { [weak alertController] in
                alertController?.presentingViewController?.dismiss(animated: true)
            }
        }

        return worker.subscribeOn(MainScheduler.instance)
    }

    private enum Error: Swift.Error {
        case internalInconsistency
        case doublePresentation
    }

    private weak var parentViewController: UIViewController?
}

private extension AlertContent.Button.Style {

    var alertActionStyle: UIAlertAction.Style {
        switch self {
        case .standard:
            return .default
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        }
    }
}
