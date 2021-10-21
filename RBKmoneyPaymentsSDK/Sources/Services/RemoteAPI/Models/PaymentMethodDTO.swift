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

enum PaymentMethodDTO {

    case bankCard(BankCard)
    case paymentTerminal(PaymentTerminal)
    case digitalWallet(DigitalWallet)
    case cryptoWallet(CryptoWallet)
    case mobileCommerce(MobileCommerce)
}

extension PaymentMethodDTO {

    struct BankCard: Codable {
        let paymentSystems: [BankCardPaymentSystemDTO]
        let tokenProviders: [BankCardTokenProviderDTO]?
    }

    struct PaymentTerminal: Codable {
        let providers: [PaymentTerminalProviderDTO]
    }

    struct DigitalWallet: Codable {
        let providers: [DigitalWalletProviderDTO]
    }

    struct CryptoWallet: Codable {
        let cryptoCurrencies: [CryptoWalletCurrencyDTO]
    }

    struct MobileCommerce: Codable {
        let operators: [MobileCommerceOperatorDTO]
    }
}

extension PaymentMethodDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PaymentMethodType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .bankCard:
            self = .bankCard(try singleValueContainer.decode(BankCard.self))
        case .paymentTerminal:
            self = .paymentTerminal(try singleValueContainer.decode(PaymentTerminal.self))
        case .digitalWallet:
            self = .digitalWallet(try singleValueContainer.decode(DigitalWallet.self))
        case .cryptoWallet:
            self = .cryptoWallet(try singleValueContainer.decode(CryptoWallet.self))
        case .mobileCommerce:
            self = .mobileCommerce(try singleValueContainer.decode(MobileCommerce.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paymentMethodType, forKey: .type)

        switch self {
        case let .bankCard(bankCard):
            try bankCard.encode(to: encoder)
        case let .paymentTerminal(paymentTerminal):
            try paymentTerminal.encode(to: encoder)
        case let .digitalWallet(digitalWallet):
            try digitalWallet.encode(to: encoder)
        case let .cryptoWallet(cryptoWallet):
            try cryptoWallet.encode(to: encoder)
        case let .mobileCommerce(mobileCommerce):
            try mobileCommerce.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "method"
    }

    private enum PaymentMethodType: String, Codable {
        case bankCard = "BankCard"
        case paymentTerminal = "PaymentTerminal"
        case digitalWallet = "DigitalWallet"
        case cryptoWallet = "CryptoWallet"
        case mobileCommerce = "MobileCommerce"
    }

    private var paymentMethodType: PaymentMethodType {
        switch self {
        case .bankCard:
            return .bankCard
        case .paymentTerminal:
            return .paymentTerminal
        case .digitalWallet:
            return .digitalWallet
        case .cryptoWallet:
            return .cryptoWallet
        case .mobileCommerce:
            return .mobileCommerce
        }
    }
}
