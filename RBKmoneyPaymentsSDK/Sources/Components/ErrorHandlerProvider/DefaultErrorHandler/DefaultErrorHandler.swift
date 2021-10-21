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

final class DefaultErrorHandler: ErrorHandlerProvider {

    // MARK: - Dependencies
    lazy var errorMessageFactory: DefaultErrorHandlerErrorMessageFactory = deferred()
    lazy var alertPresenter: AlertPresenter = deferred()

    // MARK: - Internal
    var errorHandler: (Observable<Error>) -> Observable<Void> {
        return { errorObservable -> Observable<Void> in
            return errorObservable.enumerated().flatMap { index, error -> Observable<Void> in
                guard self.shouldHandleError(error) else {
                    throw error
                }

                guard index < 5 else {
                    return self.commonHandler(for: error)
                }

                if let handler = self.silentHandler(for: error) {
                    return handler.catch(self.commonHandler)
                }

                return self.commonHandler(for: error)
            }
        }
    }

    // MARK: - Private
    private func silentHandler(for error: Error) -> Observable<Void>? {
        return nil
    }

    private func commonHandler(for error: Error) -> Observable<Void> {
        let content = AlertContent(
            title: R.string.localizable.alert_title_error(),
            message: errorMessageFactory.errorMessage(for: error),
            buttons: [.cancel, .retry]
        )

        return alertPresenter.presentAlert(content: content)
            .flatMap { action -> Single<Void> in
                guard action == .retry else {
                    throw error
                }
                return .just(())
            }
            .asObservable()
    }

    private func shouldHandleError(_ error: Error) -> Bool {
        if error is PaymentError {
            assertionFailure("Check the sequence that causes this error, PaymentError shouldn't reach this point")
            return false
        }

        if let networkError = error as? NetworkError, case .serverError = networkError.code {
            // pass server errors through
            return false
        }

        return true
    }
}
