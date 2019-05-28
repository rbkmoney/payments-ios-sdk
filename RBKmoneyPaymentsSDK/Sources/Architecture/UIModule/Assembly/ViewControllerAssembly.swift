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

class ViewControllerAssembly<View, ViewModel> where View: UIViewController & ModuleView, View.ViewModel == ViewModel {

    typealias Injection = (ViewModel) -> Void

    func bindViewModel(to viewController: View, injection: Injection? = nil) {
        bindViewModel(viewModel(injection: injection), to: viewController)
    }

    private func viewModel(injection: Injection?) -> ViewModel {
        return with(ViewModel()) {
            injection?($0)
        }
    }

    private func bindViewModel(_ viewModel: ViewModel, to viewController: View) {
        if viewController.isViewLoaded {
            viewController.bindViewModel(viewModel)
        } else {
            viewController.scheduleViewModelBinding(viewModel)
        }
    }
}

private extension ModuleView where Self: UIViewController {

    func scheduleViewModelBinding(_ viewModel: ViewModel) {
        _ = rx.viewDidLoad
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.bindViewModel(viewModel)
            })
    }
}
