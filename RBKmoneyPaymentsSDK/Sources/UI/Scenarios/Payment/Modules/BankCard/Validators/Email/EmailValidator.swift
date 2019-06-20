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

struct EmailValidator {

    // MARK: - Internal
    func validate(_ value: String) -> ValidationResult {
        return type(of: self).emailPredicate.evaluate(with: value) ? .valid : .invalid
    }

    // MARK: - Private
    private static let emailRegularExpression = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,254}[A-Z0-9a-z])?" +
                                                "@" +
                                                "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}" +
                                                "[A-Za-z]{2,8}"

    private static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegularExpression)
}
