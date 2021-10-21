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

    case card(Card)
    case tokenizedCard(TokenizedCard)
    case digitalWallet(DigitalWallet)
    case paymentTerminal(PaymentTerminal)
    case cryptoWallet(CryptoWallet)
    case mobileCommerce(MobileCommerce)
}

extension PaymentToolSourceDTO {

    struct Card: Encodable {

        enum CodingKeys: String, CodingKey {
            case number = "cardNumber"
            case expiration = "expDate"
            case cvv
            case cardholder = "cardHolder"
        }

        let number: String
        let expiration: String
        let cvv: String?
        let cardholder: String?
    }

    enum TokenizedCard {

        struct ApplePay {
            let merchantIdentifier: String
            let paymentData: Data
            let paymentMethodDisplayName: String?
            let paymentMethodNetwork: String?
            let paymentMethodType: String
            let transactionIdentifier: String
        }

        struct GooglePay {
            let gatewayMerchantIdentifier: String
            let cardNetwork: String?
            let cardDetails: String?
            let cardImageURI: String?
            let cardDescription: String?
            let cardClass: String
            let tokenizationType: String
            let token: String
        }

        struct SamsungPay: Encodable {

            enum CodingKeys: String, CodingKey {
                case serviceIdentifier = "serviceID"
                case referenceIdentifier = "referenceID"
            }

            let serviceIdentifier: String
            let referenceIdentifier: String
        }

        typealias YandexPay = GooglePay

        case applePay(ApplePay)
        case googlePay(GooglePay)
        case samsungPay(SamsungPay)
        case yandexPay(YandexPay)
    }

    enum DigitalWallet {

        struct QIWI: Encodable {
            let phoneNumber: String
            let accessToken: String?
        }

        case qiwi(QIWI)
    }

    struct PaymentTerminal: Encodable {
        let provider: PaymentTerminalProviderDTO
    }

    struct CryptoWallet: Encodable {
        let cryptoCurrency: CryptoWalletCurrencyDTO
    }

    struct MobileCommerce: Encodable {

        struct Phone: Encodable {

            enum CodingKeys: String, CodingKey {
                case countryCode = "cc"
                case subscriberNumber = "ctn"
            }

            let countryCode: String
            let subscriberNumber: String
        }

        let mobilePhone: Phone
    }
}

extension PaymentToolSourceDTO.TokenizedCard.ApplePay: Encodable {

    func encode(to encoder: Encoder) throws {
        let value = EncodedApplePay(
            merchantIdentifier: merchantIdentifier,
            paymentToken: .init(
                token: .init(
                    paymentData: .init(
                        data: paymentData
                    ),
                    paymentMethod: .init(
                        displayName: paymentMethodDisplayName,
                        network: paymentMethodNetwork,
                        type: paymentMethodType
                    ),
                    transactionIdentifier: transactionIdentifier
                )
            )
        )
        try value.encode(to: encoder)
    }

    // swiftlint:disable nesting
    private struct EncodedApplePay: Encodable {

        enum CodingKeys: String, CodingKey {
            case merchantIdentifier = "merchantID"
            case paymentToken
        }

        struct PaymentToken: Encodable {

            struct Token: Encodable {

                struct Method: Encodable {
                    let displayName: String?
                    let network: String?
                    let type: String
                }

                struct PaymentData: Encodable {
                    let data: Data

                    func encode(to encoder: Encoder) throws {
                        let json = try JSONDecoder().decode(GenericJSON.self, from: data)
                        try json.encode(to: encoder)
                    }
                }

                let paymentData: PaymentData
                let paymentMethod: Method
                let transactionIdentifier: String
            }

            let token: Token
        }

        let merchantIdentifier: String
        let paymentToken: PaymentToken
    }
    // swiftlint:enable nesting
}

extension PaymentToolSourceDTO.TokenizedCard.GooglePay: Encodable {

    func encode(to encoder: Encoder) throws {
        let value = EncodedGooglePay(
            gatewayMerchantIdentifier: gatewayMerchantIdentifier,
            paymentToken: .init(
                cardInfo: .init(
                    cardNetwork: cardNetwork,
                    cardDetails: cardDetails,
                    cardImageURI: cardImageURI,
                    cardDescription: cardDescription,
                    cardClass: cardClass
                ),
                paymentMethodToken: .init(
                    tokenizationType: tokenizationType,
                    token: token
                )
            )
        )
        try value.encode(to: encoder)
    }

    // swiftlint:disable nesting
    private struct EncodedGooglePay: Encodable {

        enum CodingKeys: String, CodingKey {
            case gatewayMerchantIdentifier = "gatewayMerchantID"
            case paymentToken
        }

        struct PaymentToken: Encodable {

            struct CardInfo: Encodable {

                enum CodingKeys: String, CodingKey {
                    case cardNetwork
                    case cardDetails
                    case cardImageURI = "cardImageUri"
                    case cardDescription
                    case cardClass
                }

                let cardNetwork: String?
                let cardDetails: String?
                let cardImageURI: String?
                let cardDescription: String?
                let cardClass: String
            }

            struct PaymentMethodToken: Encodable {
                let tokenizationType: String
                let token: String
            }

            let cardInfo: CardInfo
            let paymentMethodToken: PaymentMethodToken
        }

        let gatewayMerchantIdentifier: String
        let paymentToken: PaymentToken
    }
    // swiftlint:enable nesting
}

extension PaymentToolSourceDTO.TokenizedCard: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(provider, forKey: .provider)

        switch self {
        case let .applePay(applePay):
            try applePay.encode(to: encoder)
        case let .googlePay(googlePay):
            try googlePay.encode(to: encoder)
        case let .samsungPay(samsungPay):
            try samsungPay.encode(to: encoder)
        case let .yandexPay(yandexPay):
            try yandexPay.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case provider
    }

    private enum Provider: String, Codable {
        case applePay = "ApplePay"
        case googlePay = "GooglePay"
        case samsungPay = "SamsungPay"
        case yandexPay = "YandexPay"
    }

    private var provider: Provider {
        switch self {
        case .applePay:
            return .applePay
        case .googlePay:
            return .googlePay
        case .samsungPay:
            return .samsungPay
        case .yandexPay:
            return .yandexPay
        }
    }
}

extension PaymentToolSourceDTO.DigitalWallet: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(digitalWalletType, forKey: .type)

        switch self {
        case let .qiwi(qiwi):
            try qiwi.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "digitalWalletType"
    }

    private enum DigitalWalletType: String, Codable {
        case qiwi = "DigitalWalletQIWI"
    }

    private var digitalWalletType: DigitalWalletType {
        switch self {
        case .qiwi:
            return .qiwi
        }
    }
}

extension PaymentToolSourceDTO: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentToolType, forKey: .type)

        switch self {
        case let .card(card):
            try card.encode(to: encoder)
        case let .paymentTerminal(paymentTerminal):
            try paymentTerminal.encode(to: encoder)
        case let .digitalWallet(digitalWallet):
            try digitalWallet.encode(to: encoder)
        case let .tokenizedCard(tokenizedCard):
            try tokenizedCard.encode(to: encoder)
        case let .cryptoWallet(cryptoWallet):
            try cryptoWallet.encode(to: encoder)
        case let .mobileCommerce(mobileCommerce):
            try mobileCommerce.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "paymentToolType"
    }

    private enum PaymentToolType: String, Codable {
        case card = "CardData"
        case paymentTerminal = "PaymentTerminalData"
        case digitalWallet = "DigitalWalletData"
        case tokenizedCard = "TokenizedCardData"
        case cryptoWallet = "CryptoWalletData"
        case mobileCommerce = "MobileCommerceData"
    }

    private var paymentToolType: PaymentToolType {
        switch self {
        case .card:
            return .card
        case .paymentTerminal:
            return .paymentTerminal
        case .digitalWallet:
            return .digitalWallet
        case .tokenizedCard:
            return .tokenizedCard
        case .cryptoWallet:
            return .cryptoWallet
        case .mobileCommerce:
            return .mobileCommerce
        }
    }
}
