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

enum UserInteractionDTO {

    case paymentTerminalReceipt(PaymentTerminalReceipt)
    case redirect(Redirect)
    case cryptoCurrencyTransferRequest(CryptoCurrencyTransferRequest)
    case qrCodeDisplayRequest(QRCodeDisplayRequest)
}

extension UserInteractionDTO {

    struct PaymentTerminalReceipt: Codable {

        enum CodingKeys: String, CodingKey {
            case shortPaymentIdentifier = "shortPaymentID"
            case dueDate
        }

        let shortPaymentIdentifier: String
        let dueDate: Date
    }

    struct Redirect: Codable {
        let request: BrowserRequestDTO
    }

    struct CryptoCurrencyTransferRequest: Codable {
        let cryptoAddress: String
        let symbolicCode: String
        let cryptoAmount: CryptoAmountDTO
    }

    struct QRCodeDisplayRequest: Codable {
        let qrCode: String
    }
}

extension UserInteractionDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(InteractionType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .paymentTerminalReceipt:
            self = .paymentTerminalReceipt(try singleValueContainer.decode(PaymentTerminalReceipt.self))
        case .redirect:
            self = .redirect(try singleValueContainer.decode(Redirect.self))
        case .cryptoCurrencyTransferRequest:
            self = .cryptoCurrencyTransferRequest(try singleValueContainer.decode(CryptoCurrencyTransferRequest.self))
        case .qrCodeDisplayRequest:
            self = .qrCodeDisplayRequest(try singleValueContainer.decode(QRCodeDisplayRequest.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(interactionType, forKey: .type)

        switch self {
        case let .paymentTerminalReceipt(paymentTerminalReceipt):
            try paymentTerminalReceipt.encode(to: encoder)
        case let .redirect(redirect):
            try redirect.encode(to: encoder)
        case let .cryptoCurrencyTransferRequest(cryptoCurrencyTransferRequest):
            try cryptoCurrencyTransferRequest.encode(to: encoder)
        case let .qrCodeDisplayRequest(qrCodeDisplayRequest):
            try qrCodeDisplayRequest.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "interactionType"
    }

    private enum InteractionType: String, Codable {
        case paymentTerminalReceipt = "PaymentTerminalReceipt"
        case redirect = "Redirect"
        case cryptoCurrencyTransferRequest = "CryptoCurrencyTransferRequest"
        case qrCodeDisplayRequest = "QrCodeDisplayRequest"
    }

    private var interactionType: InteractionType {
        switch self {
        case .paymentTerminalReceipt:
            return .paymentTerminalReceipt
        case .redirect:
            return .redirect
        case .cryptoCurrencyTransferRequest:
            return .cryptoCurrencyTransferRequest
        case .qrCodeDisplayRequest:
            return .qrCodeDisplayRequest
        }
    }
}
