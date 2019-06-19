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

final class ExpirationDateValidator {

    // MARK: - Internal
    func validate(_ value: String) -> ValidationResult {
        let digits = CharacterSet.decimalDigits
        let cleaned = String(value.unicodeScalars.filter(digits.contains))

        guard cleaned.count == 4 else {
            return .invalid
        }

        guard let month = Int(cleaned.prefix(2)), (1...12).contains(month) else {
            return .invalid
        }

        guard let year = Int(cleaned.suffix(2)) else {
            return .invalid
        }

        let components = calendar.dateComponents([.month, .year], from: Date())

        guard let currentMonth = components.month, let currentYear = components.year else {
            assertionFailure("Failed to get current month and year")
            return .unknown
        }

        if year > currentYear % 100 {
            return .valid
        } else if year == currentYear % 100 {
            if month >= currentMonth {
                return .valid
            } else {
                return .invalid
            }
        } else {
            return .invalid
        }
    }

    // MARK: - Private
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .current

        return calendar
    }()
}
