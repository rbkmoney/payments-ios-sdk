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

final class PaymentProgressViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: PaymentProgressInputData = deferred()
    lazy var remoteAPI: PaymentProgressRemoteAPI = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        return input.didTapCancel
            .map(to: PaymentRoute.cancel)
            .emit(to: Binder(self) {
                $0.router.trigger(route: $1)
            })
    }

    // MARK: - Internal
    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    // MARK: - Private
    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private let activityTracker = ActivityTracker()
}
