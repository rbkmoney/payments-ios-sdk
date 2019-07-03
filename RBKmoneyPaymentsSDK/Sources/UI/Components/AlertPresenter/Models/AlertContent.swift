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

import Foundation

struct AlertContent {

    struct Button {
        enum Action {
            case okay
            case yes
            case nope
            case cancel
            case retry
        }

        enum Style {
            case standard
            case cancel
            case destructive
        }

        let title: String
        let style: Style
        let action: Action
    }

    let title: String?
    let message: String?
    let buttons: [Button]
}

extension AlertContent.Button {

    static let okay = AlertContent.Button(title: R.string.localizable.alert_button_ok(), style: .standard, action: .okay)
    static let yes = AlertContent.Button(title: R.string.localizable.alert_button_yes(), style: .standard, action: .yes)
    static let nope = AlertContent.Button(title: R.string.localizable.alert_button_nope(), style: .cancel, action: .nope)
    static let cancel = AlertContent.Button(title: R.string.localizable.alert_button_cancel(), style: .cancel, action: .cancel)
    static let retry = AlertContent.Button(title: R.string.localizable.alert_button_retry(), style: .standard, action: .retry)
}
