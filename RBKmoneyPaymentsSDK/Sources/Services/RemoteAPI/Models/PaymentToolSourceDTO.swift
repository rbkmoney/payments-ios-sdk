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

enum PaymentToolSourceDTO {

    struct CardData {
        let number: String
        let expiration: String
        let cvv: String?
        let cardHolder: String?
    }

    enum TokenizedCardData {
        struct ApplePay {
            let merchantIdentifier: String
            let paymentToken: Data
        }

        struct GooglePay {
            let gatewayMerchantIdentifier: String
            let paymentToken: Data
        }

        struct SamsungPay {
            let serviceIdentifier: String
            let referenceIdentifier: String
        }

        case applePay(ApplePay)
        case googlePay(GooglePay)
        case samsungPay(SamsungPay)
    }

    enum DigitalWalletData {
        struct QIWI {
            let phoneNumber: String
        }

        case qiwi(QIWI)
    }

    enum PaymentTerminalProvider: String, Codable {
        case euroset
    }

    case cardData(CardData)
    case tokenizedCardData(TokenizedCardData)
    case digitalWalletData(DigitalWalletData)
    case paymentTerminalData(PaymentTerminalProvider)
}

extension PaymentToolSourceDTO: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .cardData(card):
            try container.encode(PaymentToolType.cardData, forKey: .type)
            try container.encode(card.number, forKey: .cardNumber)
            try container.encode(card.expiration, forKey: .cardExpiration)
            try container.encodeIfPresent(card.cvv, forKey: .cvv)
            try container.encodeIfPresent(card.cardHolder, forKey: .cardHolder)
        case let .tokenizedCardData(provider):
            try container.encode(PaymentToolType.tokenizedCardData, forKey: .type)
            switch provider {
            case let .applePay(card):
                try container.encode(TokenizedCardDataProvider.applePay, forKey: .provider)
                try container.encode(card.merchantIdentifier, forKey: .merchantIdentifier)
                try container.encode(card.paymentToken, forKey: .paymentToken)
            case let .googlePay(card):
                try container.encode(TokenizedCardDataProvider.googlePay, forKey: .provider)
                try container.encode(card.gatewayMerchantIdentifier, forKey: .gatewayMerchantIdentifier)
                try container.encode(card.paymentToken, forKey: .paymentToken)
            case let .samsungPay(card):
                try container.encode(TokenizedCardDataProvider.samsungPay, forKey: .provider)
                try container.encode(card.serviceIdentifier, forKey: .serviceIdentifier)
                try container.encode(card.referenceIdentifier, forKey: .referenceIdentifier)
            }
        case let .digitalWalletData(provider):
            try container.encode(PaymentToolType.digitalWalletData, forKey: .type)
            switch provider {
            case let .qiwi(data):
                try container.encode(DigitalWalletType.qiwi, forKey: .digitalWalletType)
                try container.encode(data.phoneNumber, forKey: .phoneNumber)
            }
        case let .paymentTerminalData(provider):
            try container.encode(PaymentToolType.paymentTerminalData, forKey: .type)
            try container.encode(provider, forKey: .provider)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "paymentToolType"
        case cardNumber
        case cardExpiration = "expDate"
        case cvv
        case cardHolder
        case provider
        case digitalWalletType
        case merchantIdentifier = "merchantID"
        case gatewayMerchantIdentifier = "gatewayMerchantID"
        case paymentToken
        case serviceIdentifier = "serviceID"
        case referenceIdentifier = "referenceID"
        case phoneNumber
    }

    private enum PaymentToolType: String, Codable {
        case cardData = "CardData"
        case paymentTerminalData = "PaymentTerminalData"
        case digitalWalletData = "DigitalWalletData"
        case tokenizedCardData = "TokenizedCardData"
    }

    private enum TokenizedCardDataProvider: String, Codable {
        case applePay = "ApplePay"
        case googlePay = "GooglePay"
        case samsungPay = "SamsungPay"
    }

    private enum DigitalWalletType: String, Codable {
        case qiwi = "DigitalWalletQIWI"
    }
}
