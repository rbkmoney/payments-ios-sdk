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

/// Набор входных параметров для сценария "Payment".
public struct PaymentInputData {

    /// Идентификатор инвойса, который необходимо оплатить. Больше подробностей можно найти в
    /// [документации RBKmoney](https://developer.rbk.money/api/#tag/Invoices).
    public let invoiceIdentifier: String

    /// Токен доступа, имеющий необходимые права для проведения операций с указанным инвойсом. Обычно это токен доступа инвойса. Больше подробностей
    /// можно найти в [документации RBKmoney](https://developer.rbk.money/api/#tag/Invoices).
    public let invoiceAccessToken: String

    /// Название магазина.
    ///
    /// Произвольная строка текста, которая будет отображаться в заголовке экранов, отображаемых пользователю.
    public let shopName: String

    /// Email плательщика.
    ///
    /// Если перед отображением UI сценария email плательщика уже известен, то его можно указать в этом параметре. Значение будет использовано в
    /// качестве начального значения поля email на разных экранах, отображаемых пользователю. В любом случае, пользователь будет иметь возможность
    /// изменить значение поля email через UI.
    public let payerEmail: String?

    /// Разрешенные методы оплаты.
    ///
    /// Методы оплаты, которые разрешено использовать для оплаты инвойса. Конечный список методов оплаты, отображаемый пользователю в UI, будет
    /// зависеть от перечисленных в этом параметре методов и от требований, накладываемых каждым методом оплаты в отдельности. Требования указаны в
    /// описании перечисления `PaymentMethod`.
    ///
    /// Например, можно разрешить оплату только банковской картой, при этом другие методы не будут отображены в UI даже при возможности их
    /// применения.
    public let allowedPaymentMethods: [PaymentMethod]

    /// Набор входных данных для оплаты с помощью Apple Pay.
    public let applePayInputData: PaymentApplePayInputData?

    /// Инициализатор структуры.
    ///
    /// - Parameter invoiceIdentifier: обязательный
    /// - Parameter invoiceAccessToken: обязательный
    /// - Parameter shopName: обязательный
    /// - Parameter payerEmail: необязательный, по умолчанию - nil
    /// - Parameter allowedPaymentMethods: обязательный, по умолчанию - все доступные методы
    /// - Parameter applePayInputData: необязательный, по умолчанию - nil
    public init(invoiceIdentifier: String,
                invoiceAccessToken: String,
                shopName: String,
                payerEmail: String? = nil,
                allowedPaymentMethods: [PaymentMethod] = PaymentMethod.allCases,
                applePayInputData: PaymentApplePayInputData? = nil) {

        self.invoiceIdentifier = invoiceIdentifier
        self.invoiceAccessToken = invoiceAccessToken
        self.shopName = shopName
        self.payerEmail = payerEmail
        self.allowedPaymentMethods = allowedPaymentMethods
        self.applePayInputData = applePayInputData
    }
}
