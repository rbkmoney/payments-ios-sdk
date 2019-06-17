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

struct PriceFormatter {

    // MARK: - Internal
    func formattedPrice(amount: AmountDTO, currency: CurrencyDTO) -> String {
        let numberFormatter = with(NumberFormatter()) {
            $0.numberStyle = .currency
            $0.locale = Locale.current
            $0.currencySymbol = currency.symbol
        }

        guard let string = numberFormatter.string(from: NSDecimalNumber(decimal: amount.value)) else {
            assertionFailure("Unable to get string from \(amount.value) \(currency)")
            return ""
        }

        return string
    }
}

private extension CurrencyDTO {

    var symbol: String {
        switch self {
        case .rub:
            return "₽"
        case .usd:
            return "$"
        case .eur:
            return "€"
        }
    }
}
