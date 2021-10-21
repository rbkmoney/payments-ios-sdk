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

extension ObservableType {

    /// Catches error and completes the sequence
    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            return .empty()
        }
    }

    /// Asserts the observable sequence never emits error
    func catchErrorNever(file: StaticString = #file, line: UInt = #line) -> Observable<Element> {
        return self.catch { error in
            assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
            return .empty()
        }
    }
}

enum SharedSequenceErrorHandler {
    case never
}

extension ObservableType {

    func asDriver(onError errorHandler: SharedSequenceErrorHandler, file: StaticString = #file, line: UInt = #line) -> Driver<Element> {
        return asDriver { error in
            switch errorHandler {
            case .never:
                assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
                return .empty()
            }
        }
    }

    func asSignal(onError errorHandler: SharedSequenceErrorHandler, file: StaticString = #file, line: UInt = #line) -> Signal<Element> {
        return asSignal { error in
            switch errorHandler {
            case .never:
                assertionFailure("Unexpected error in observable sequence: \(error)", file: file, line: line)
                return .empty()
            }
        }
    }
}

extension ObservableType {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Observable<Element> {
        return retry(when: errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Completable {
        return retry(when: errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == MaybeTrait {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Maybe<Element> {
        return retry(when: errorHandlerProvider.errorHandler)
    }
}

extension PrimitiveSequence where Trait == SingleTrait {

    func retry(using errorHandlerProvider: ErrorHandlerProvider) -> Single<Element> {
        return retry(when: errorHandlerProvider.errorHandler)
    }
}
