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

    case invoiceCreated(InvoiceCreated)
    case invoiceStatusChanged(InvoiceStatusChanged)
    case paymentStarted(PaymentStarted)
    case paymentStatusChanged(PaymentStatusChanged)
    case paymentInteractionRequested(PaymentInteractionRequested)
    case refundStarted(RefundStarted)
    case refundStatusChanged(RefundStatusChanged)
}

extension InvoiceChangeDTO {

    struct InvoiceCreated: Codable {
        let invoice: InvoiceDTO
    }

    struct InvoiceStatusChanged: Codable {
        let status: InvoiceStatusDTO
        let reason: String?
    }

    struct PaymentStarted: Codable {
        let payment: PaymentDTO
    }

    struct PaymentStatusChanged: Codable {

        enum CodingKeys: String, CodingKey {
            case status
            case error
            case paymentIdentifier = "paymentID"
        }

        let status: PaymentStatusDTO
        let error: ServerErrorDTO?
        let paymentIdentifier: String
    }

    struct PaymentInteractionRequested: Codable {

        enum CodingKeys: String, CodingKey {
            case userInteraction
            case paymentIdentifier = "paymentID"
        }

        let userInteraction: UserInteractionDTO
        let paymentIdentifier: String
    }

    struct RefundStarted: Codable {

        enum CodingKeys: String, CodingKey {
            case refund
            case paymentIdentifier = "paymentID"
        }

        let refund: RefundDTO
        let paymentIdentifier: String
    }

    struct RefundStatusChanged: Codable {

        enum CodingKeys: String, CodingKey {
            case paymentIdentifier = "paymentID"
            case refundIdentifier = "refundID"
            case status
            case error
        }

        let paymentIdentifier: String
        let refundIdentifier: String
        let status: RefundStatusDTO
        let error: ServerErrorDTO?
    }
}

extension InvoiceChangeDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ChangeType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .invoiceCreated:
            self = .invoiceCreated(try singleValueContainer.decode(InvoiceCreated.self))
        case .invoiceStatusChanged:
            self = .invoiceStatusChanged(try singleValueContainer.decode(InvoiceStatusChanged.self))
        case .paymentStarted:
            self = .paymentStarted(try singleValueContainer.decode(PaymentStarted.self))
        case .paymentStatusChanged:
            self = .paymentStatusChanged(try singleValueContainer.decode(PaymentStatusChanged.self))
        case .paymentInteractionRequested:
            self = .paymentInteractionRequested(try singleValueContainer.decode(PaymentInteractionRequested.self))
        case .refundStarted:
            self = .refundStarted(try singleValueContainer.decode(RefundStarted.self))
        case .refundStatusChanged:
            self = .refundStatusChanged(try singleValueContainer.decode(RefundStatusChanged.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(changeType, forKey: .type)

        switch self {
        case let .invoiceCreated(invoiceCreated):
            try invoiceCreated.encode(to: encoder)
        case let .invoiceStatusChanged(invoiceStatusChanged):
            try invoiceStatusChanged.encode(to: encoder)
        case let .paymentStarted(paymentStarted):
            try paymentStarted.encode(to: encoder)
        case let .paymentStatusChanged(paymentStatusChanged):
            try paymentStatusChanged.encode(to: encoder)
        case let .paymentInteractionRequested(paymentInteractionRequested):
            try paymentInteractionRequested.encode(to: encoder)
        case let .refundStarted(refundStarted):
            try refundStarted.encode(to: encoder)
        case let .refundStatusChanged(refundStatusChanged):
            try refundStatusChanged.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "changeType"
    }

    private enum ChangeType: String, Codable {
        case invoiceCreated = "InvoiceCreated"
        case invoiceStatusChanged = "InvoiceStatusChanged"
        case paymentStarted = "PaymentStarted"
        case paymentStatusChanged = "PaymentStatusChanged"
        case paymentInteractionRequested = "PaymentInteractionRequested"
        case refundStarted = "RefundStarted"
        case refundStatusChanged = "RefundStatusChanged"
    }

    private var changeType: ChangeType {
        switch self {
        case .invoiceCreated:
            return .invoiceCreated
        case .invoiceStatusChanged:
            return .invoiceStatusChanged
        case .paymentStarted:
            return .paymentStarted
        case .paymentStatusChanged:
            return .paymentStatusChanged
        case .paymentInteractionRequested:
            return .paymentInteractionRequested
        case .refundStarted:
            return .refundStarted
        case .refundStatusChanged:
            return .refundStatusChanged
        }
    }
}
