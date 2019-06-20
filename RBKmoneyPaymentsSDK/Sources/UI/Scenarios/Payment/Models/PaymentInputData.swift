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

public struct PaymentInputData {

    public let invoiceIdentifier: String

    public let invoiceAccessToken: String

    public let shopName: String

    public let allowedPaymentMethods: [PaymentMethod]

    public let applePayMerchantIdentifier: String?

    public init(invoiceIdentifier: String,
                invoiceAccessToken: String,
                shopName: String,
                allowedPaymentMethods: [PaymentMethod] = PaymentMethod.allCases,
                applePayMerchantIdentifier: String? = nil) {

        self.invoiceIdentifier = invoiceIdentifier
        self.invoiceAccessToken = invoiceAccessToken
        self.shopName = shopName
        self.allowedPaymentMethods = allowedPaymentMethods
        self.applePayMerchantIdentifier = applePayMerchantIdentifier
    }
}
