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

final class CardDetector {

    // MARK: - Dependencies
    lazy var cardDescriptionsURL: URL = deferred()

    // MARK: - Internal
    func detectCard(from number: String) -> CardDescription? {
        let digits = CharacterSet.decimalDigits
        let cleaned = String(number.unicodeScalars.filter(digits.contains))

        return cardDescriptions.first { $0.prefixes.contains { cleaned.hasPrefix($0) } }
    }

    // MARK: - Private
    private lazy var cardDescriptions: [CardDescription] = {
        do {
            let data = try Data(contentsOf: cardDescriptionsURL)
            return try JSONDecoder().decode([CardDescription].self, from: data)
        } catch {
            assertionFailure("Failed to parse card descriptions file at \(cardDescriptionsURL)")
            return []
        }
    }()
}
