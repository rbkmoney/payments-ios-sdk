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

enum PaymentToolDetailsDTO {

    struct CardData {
        let maskedNumber: String
        let bin: String?
        let lastDigits: String?
        let paymentSystem: BankCardPaymentSystemDTO
        let tokenProvider: BankCardTokenProviderDTO?
    }

    enum PaymentTerminalProvider: String, Codable {
        case euroset
    }

    enum DigitalWalletData {
        struct QIWI {
            let maskedPhoneNumber: String
        }

        case qiwi(QIWI)
    }

    case bankCard(CardData)
    case paymentTerminal(PaymentTerminalProvider)
    case digitalWallet(DigitalWalletData)
}

extension PaymentToolDetailsDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DetailsType.self, forKey: .type)

        switch type {
        case .bankCard:
            let cardData = CardData(
                maskedNumber: try container.decode(String.self, forKey: .maskedNumber),
                bin: try container.decodeIfPresent(String.self, forKey: .bin),
                lastDigits: try container.decodeIfPresent(String.self, forKey: .lastDigits),
                paymentSystem: try container.decode(BankCardPaymentSystemDTO.self, forKey: .paymentSystem),
                tokenProvider: try container.decodeIfPresent(BankCardTokenProviderDTO.self, forKey: .tokenProvider)
            )
            self = .bankCard(cardData)
        case .paymentTerminal:
            let provider = try container.decode(PaymentTerminalProvider.self, forKey: .provider)
            self = .paymentTerminal(provider)
        case .digitalWallet:
            let type = try container.decode(DigitalWalletType.self, forKey: .digitalWalletType)
            switch type {
            case .qiwi:
                let data = DigitalWalletData.QIWI(
                    maskedPhoneNumber: try container.decode(String.self, forKey: .maskedPhoneNumber)
                )
                self = .digitalWallet(.qiwi(data))
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .bankCard(card):
            try container.encode(DetailsType.bankCard, forKey: .type)
            try container.encode(card.maskedNumber, forKey: .maskedNumber)
            try container.encodeIfPresent(card.bin, forKey: .bin)
            try container.encodeIfPresent(card.lastDigits, forKey: .lastDigits)
            try container.encode(card.paymentSystem, forKey: .paymentSystem)
            try container.encodeIfPresent(card.tokenProvider, forKey: .tokenProvider)
        case let .paymentTerminal(provider):
            try container.encode(DetailsType.paymentTerminal, forKey: .type)
            try container.encode(provider, forKey: .provider)
        case let .digitalWallet(provider):
            try container.encode(DetailsType.digitalWallet, forKey: .type)
            switch provider {
            case let .qiwi(data):
                try container.encode(DigitalWalletType.qiwi, forKey: .digitalWalletType)
                try container.encode(data.maskedPhoneNumber, forKey: .maskedPhoneNumber)
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "detailsType"
        case maskedNumber = "cardNumberMask"
        case bin
        case lastDigits
        case paymentSystem
        case tokenProvider
        case provider
        case digitalWalletType = "digitalWalletDetailsType"
        case maskedPhoneNumber = "phoneNumberMask"
    }

    private enum DetailsType: String, Codable {
        case bankCard = "PaymentToolDetailsBankCard"
        case paymentTerminal = "PaymentToolDetailsPaymentTerminal"
        case digitalWallet = "PaymentToolDetailsDigitalWallet"
    }

    private enum DigitalWalletType: String, Codable {
        case qiwi = "DigitalWalletDetailsQIWI"
    }
}
