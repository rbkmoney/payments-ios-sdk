//
//  ActivityTracker.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 10/18/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//
//  This file was copied from RxSwift's example app and slightly modified.
//  An original version can be found at:
//  https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Services/ActivityIndicator.swift
//

import RxCocoa
import RxSwift

private struct ActivityToken<Element>: ObservableConvertibleType, Disposable {

    private let _source: Observable<Element>
    private let _dispose: Cancelable

    init(source: Observable<Element>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<Element> {
        return _source
    }
}

// Enables monitoring of sequence computation.
//
// If there is at least one sequence computation in progress, `true` will be sent.
// When all activities complete `false` will be sent.

class ActivityTracker: SharedSequenceConvertibleType {

    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _relay = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    init() {
        _loading = _relay.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        return Observable.using(
            _: { () -> ActivityToken<O.Element> in
                self.increment()
                return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
            },
            observableFactory: { token in
                return token.asObservable()
            }
        )
    }

    private func increment() {
        _lock.performLocked {
            _relay.accept(_relay.value + 1)
        }
    }

    private func decrement() {
        _lock.performLocked {
            _relay.accept(_relay.value - 1)
        }
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _loading
    }
}

extension ObservableConvertibleType {

    func trackActivity(_ activityTracker: ActivityTracker) -> Observable<Element> {
        return activityTracker.trackActivityOfObservable(self)
    }
}
