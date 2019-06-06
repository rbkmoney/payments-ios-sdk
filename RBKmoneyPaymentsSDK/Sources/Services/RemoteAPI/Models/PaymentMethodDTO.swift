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

    enum PaymentTerminalProvider: String, Codable {
        case euroset
    }

    enum DigitalWalletProvider: String, Codable {
        case qiwi
    }

    case bankCard([BankCardPaymentSystemDTO], [BankCardTokenProviderDTO]?)
    case paymentTerminal([PaymentTerminalProvider])
    case digitalWallet([DigitalWalletProvider])
}

extension PaymentMethodDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PaymentMethodType.self, forKey: .type)

        switch type {
        case .bankCard:
            let paymentSystems = try container.decode([BankCardPaymentSystemDTO].self, forKey: .paymentSystems)
            let tokenProviders = try container.decodeIfPresent([BankCardTokenProviderDTO].self, forKey: .tokenProviders)
            self = .bankCard(paymentSystems, tokenProviders)
        case .paymentTerminal:
            let providers = try container.decode([PaymentTerminalProvider].self, forKey: .providers)
            self = .paymentTerminal(providers)
        case .digitalWallet:
            let providers = try container.decode([DigitalWalletProvider].self, forKey: .providers)
            self = .digitalWallet(providers)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .bankCard(paymentSystems, tokenProviders):
            try container.encode(PaymentMethodType.bankCard, forKey: .type)
            try container.encode(paymentSystems, forKey: .paymentSystems)
            try container.encodeIfPresent(tokenProviders, forKey: .tokenProviders)
        case let .paymentTerminal(providers):
            try container.encode(PaymentMethodType.paymentTerminal, forKey: .type)
            try container.encode(providers, forKey: .providers)
        case let .digitalWallet(providers):
            try container.encode(PaymentMethodType.digitalWallet, forKey: .type)
            try container.encode(providers, forKey: .providers)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "method"
        case paymentSystems
        case tokenProviders
        case providers
    }

    private enum PaymentMethodType: String, Codable {
        case bankCard = "BankCard"
        case paymentTerminal = "PaymentTerminal"
        case digitalWallet = "DigitalWallet"
    }
}
