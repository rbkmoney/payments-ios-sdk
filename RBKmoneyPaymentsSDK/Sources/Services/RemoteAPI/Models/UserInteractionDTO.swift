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

    struct ReceiptData {
        let shortPaymentIdentifier: String
        let dueDate: Date
    }

    case paymentTerminalReceipt(ReceiptData)
    case redirect(BrowserRequestDTO)
}

extension UserInteractionDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(InteractionType.self, forKey: .type)

        switch type {
        case .paymentTerminalReceipt:
            let data = ReceiptData(
                shortPaymentIdentifier: try container.decode(String.self, forKey: .shortPaymentIdentifier),
                dueDate: try container.decode(Date.self, forKey: .dueDate)
            )
            self = .paymentTerminalReceipt(data)
        case .redirect:
            let request = try container.decode(BrowserRequestDTO.self, forKey: .request)
            self = .redirect(request)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .paymentTerminalReceipt(data):
            try container.encode(InteractionType.paymentTerminalReceipt, forKey: .type)
            try container.encode(data.shortPaymentIdentifier, forKey: .shortPaymentIdentifier)
            try container.encode(data.dueDate, forKey: .dueDate)
        case let .redirect(request):
            try container.encode(InteractionType.redirect, forKey: .type)
            try container.encode(request, forKey: .request)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "interactionType"
        case shortPaymentIdentifier = "shortPaymentID"
        case dueDate
        case request
    }

    private enum InteractionType: String, Codable {
        case paymentTerminalReceipt = "PaymentTerminalReceipt"
        case redirect = "Redirect"
    }
}
