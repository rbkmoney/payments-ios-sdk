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

/// Набор входных данных для оплаты с помощью Apple Pay.
public struct PaymentApplePayInputData {

    /// Идентификатор Apple Pay Merchant.
    ///
    /// Идентификатор продавца является необходимым, в числе прочих требований, для оплаты с помощью Apple Pay. Больше подробностей можно найти в
    /// [документации по настройке Apple Pay](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements).
    public let merchantIdentifier: String

    /// Двухбуквенный ISO 3166 код страны, где платеж будет обрабатываться, например, "RU".
    ///
    /// Больше подробностей можно найти в [документации](https://developer.apple.com/documentation/passkit/pkpaymentrequest/1619246-countrycode).
    public let countryCode: String

    /// Инициализатор структуры.
    ///
    /// - Parameter merchantIdentifier: обязательный
    /// - Parameter countryCode: обязательный
    public init(merchantIdentifier: String, countryCode: String) {
        self.merchantIdentifier = merchantIdentifier
        self.countryCode = countryCode
    }
}
