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

struct CardNumberValidator {

    // MARK: - Internal
    func validate(_ value: String) -> ValidationResult {
        let digits = CharacterSet.decimalDigits
        let cleaned = String(value.unicodeScalars.filter(digits.contains))

        return luhnCheck(cleaned) ? .valid : .invalid
    }

    // MARK: - Private
    private func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let reversedCharacters = number.reversed().map { String($0) }

        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return false
            }

            switch ((idx % 2 == 1), digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }

        return sum % 10 == 0
    }
}
