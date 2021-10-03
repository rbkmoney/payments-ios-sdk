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

extension PrimitiveSequence where Trait == SingleTrait {

    static func combineLatest<T1, T2>(_ source1: Single<T1>,
                                      _ source2: Single<T2>,
                                      resultSelector: @escaping (T1, T2) throws -> Element) -> Single<Element> {

        return Observable.combineLatest(source1.asObservable(), source2.asObservable(), resultSelector: resultSelector).asSingle()
    }

    static func combineLatest<T1, T2>(_ source1: Single<T1>,
                                      _ source2: Single<T2>) -> Single<Element> where Element == (T1, T2) {

        return Observable.combineLatest(source1.asObservable(), source2.asObservable()).asSingle()
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Single<Element> {
        return asObservable().trackActivity(activityTracker).asSingle()
    }

    func compactMap<T>(_ transform: @escaping (Element) throws -> T?) -> Maybe<T> {
        return asObservable().compactMap(transform).asMaybe()
    }

    func map<R>(to value: R) -> Single<R> {
        return map { _ in value }
    }
}

extension PrimitiveSequence where Trait == CompletableTrait, Element == Swift.Never {

    static func execute(_ action: @escaping () throws -> Void) -> Completable {
        return create { observer in
            do {
                try action()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func catchErrorJustComplete() -> Completable {
        return self.catch { _ in
            return .empty()
        }
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Completable {
        return asObservable().trackActivity(activityTracker).asCompletable()
    }
}

extension PrimitiveSequence where Trait == MaybeTrait {

    func catchErrorJustComplete() -> Maybe<Element> {
        return self.catch { _ in
            return .empty()
        }
    }

    func trackActivity(_ activityTracker: ActivityTracker) -> Maybe<Element> {
        return asObservable().trackActivity(activityTracker).asMaybe()
    }

    func compactMap<T>(_ transform: @escaping (Element) throws -> T?) -> Maybe<T> {
        return asObservable().compactMap(transform).asMaybe()
    }

    func map<R>(to value: R) -> Maybe<R> {
        return map { _ in value }
    }
}
