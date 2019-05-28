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

extension Reactive where Base: UIViewController {

    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidLoad)).map(to: ()))
    }

    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewWillAppear)).map(to: ()))
    }

    var viewDidAppear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidAppear)).map(to: ()))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewWillDisappear)).map(to: ()))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return ControlEvent(events: methodInvoked(#selector(UIViewController.viewDidDisappear)).map(to: ()))
    }
}
