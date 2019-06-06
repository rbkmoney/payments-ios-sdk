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

enum InvoiceChangeDTO {

    struct PaymentStatusChangedData {
        let status: PaymentStatusDTO
        let paymentIdentifier: String
    }

    case invoiceCreated(InvoiceDTO)
    case invoiceStatusChanged(InvoiceStatusDTO)
    case paymentStarted(PaymentDTO)
    case paymentStatusChanged(PaymentStatusChangedData)
}

extension InvoiceChangeDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ChangeType.self, forKey: .type)

        switch type {
        case .invoiceCreated:
            let invoice = try container.decode(InvoiceDTO.self, forKey: .invoice)
            self = .invoiceCreated(invoice)
        case .invoiceStatusChanged:
            let status = try container.decode(InvoiceStatusDTO.self, forKey: .status)
            self = .invoiceStatusChanged(status)
        case .paymentStarted:
            let payment = try container.decode(PaymentDTO.self, forKey: .payment)
            self = .paymentStarted(payment)
        case .paymentStatusChanged:
            let data = PaymentStatusChangedData(
                status: try container.decode(PaymentStatusDTO.self, forKey: .status),
                paymentIdentifier: try container.decode(String.self, forKey: .paymentIdentifier)
            )
            self = .paymentStatusChanged(data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .invoiceCreated(invoice):
            try container.encode(ChangeType.invoiceCreated, forKey: .type)
            try container.encode(invoice, forKey: .invoice)
        case let .invoiceStatusChanged(status):
            try container.encode(ChangeType.invoiceStatusChanged, forKey: .type)
            try container.encode(status, forKey: .status)
        case let .paymentStarted(payment):
            try container.encode(ChangeType.paymentStarted, forKey: .type)
            try container.encode(payment, forKey: .payment)
        case let .paymentStatusChanged(data):
            try container.encode(ChangeType.paymentStatusChanged, forKey: .type)
            try container.encode(data.status, forKey: .status)
            try container.encode(data.paymentIdentifier, forKey: .paymentIdentifier)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "changeType"
        case invoice
        case status
        case payment
        case paymentIdentifier = "paymentID"
    }

    private enum ChangeType: String, Codable {
        case invoiceCreated = "InvoiceCreated"
        case invoiceStatusChanged = "InvoiceStatusChanged"
        case paymentStarted = "PaymentStarted"
        case paymentStatusChanged = "PaymentStatusChanged"
    }
}
