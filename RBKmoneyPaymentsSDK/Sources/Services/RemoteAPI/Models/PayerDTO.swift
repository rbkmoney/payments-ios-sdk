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

enum PayerDTO {

    case customer(Customer)
    case paymentResource(PaymentResource)
    case recurrentPayment(RecurrentPayment)
}

extension PayerDTO {

    struct Customer: Codable {

        enum CodingKeys: String, CodingKey {
            case identifier = "customerID"
            case paymentToolToken
            case paymentToolDetails
            case paymentSessionInfo = "sessionInfo"
        }

        let identifier: String
        let paymentToolToken: String?
        let paymentToolDetails: PaymentToolDetailsDTO?
        let paymentSessionInfo: PaymentSessionInfoDTO?

        init(identifier: String, paymentSessionInfo: PaymentSessionInfoDTO?) {
            self.identifier = identifier
            self.paymentToolToken = nil
            self.paymentToolDetails = nil
            self.paymentSessionInfo = paymentSessionInfo
        }
    }

    struct PaymentResource: Codable {

        enum CodingKeys: String, CodingKey {
            case paymentToolToken
            case paymentSessionIdentifier = "paymentSession"
            case paymentToolDetails
            case clientInfo
            case contactInfo
            case paymentSessionInfo = "sessionInfo"
        }

        let paymentToolToken: String
        let paymentSessionIdentifier: String
        let paymentToolDetails: PaymentToolDetailsDTO?
        let clientInfo: ClientInfoDTO?
        let contactInfo: ContactInfoDTO
        let paymentSessionInfo: PaymentSessionInfoDTO?

        init(paymentToolToken: String, paymentSessionIdentifier: String, contactInfo: ContactInfoDTO, paymentSessionInfo: PaymentSessionInfoDTO?) {
            self.paymentToolToken = paymentToolToken
            self.paymentSessionIdentifier = paymentSessionIdentifier
            self.paymentToolDetails = nil
            self.clientInfo = nil
            self.contactInfo = contactInfo
            self.paymentSessionInfo = paymentSessionInfo
        }
    }

    struct RecurrentPayment: Codable {

        enum CodingKeys: String, CodingKey {
            case contactInfo
            case parent = "recurrentParentPayment"
            case paymentToolToken
            case paymentToolDetails
            case paymentSessionInfo = "sessionInfo"
        }

        let contactInfo: ContactInfoDTO
        let parent: RecurrentPaymentParentDTO
        let paymentToolToken: String?
        let paymentToolDetails: PaymentToolDetailsDTO?
        let paymentSessionInfo: PaymentSessionInfoDTO?

        init(contactInfo: ContactInfoDTO, parent: RecurrentPaymentParentDTO, paymentSessionInfo: PaymentSessionInfoDTO?) {
            self.contactInfo = contactInfo
            self.parent = parent
            self.paymentToolToken = nil
            self.paymentToolDetails = nil
            self.paymentSessionInfo = paymentSessionInfo
        }
    }
}

extension PayerDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PayerType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .customer:
            self = .customer(try singleValueContainer.decode(Customer.self))
        case .paymentResource:
            self = .paymentResource(try singleValueContainer.decode(PaymentResource.self))
        case .recurrentPayment:
            self = .recurrentPayment(try singleValueContainer.decode(RecurrentPayment.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payerType, forKey: .type)

        switch self {
        case let .customer(customer):
            try customer.encode(to: encoder)
        case let .paymentResource(paymentResource):
            try paymentResource.encode(to: encoder)
        case let .recurrentPayment(recurrentPayment):
            try recurrentPayment.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "payerType"
    }

    private enum PayerType: String, Codable {
        case customer = "CustomerPayer"
        case paymentResource = "PaymentResourcePayer"
        case recurrentPayment = "RecurrentPayer"
    }

    private var payerType: PayerType {
        switch self {
        case .customer:
            return .customer
        case .paymentResource:
            return .paymentResource
        case .recurrentPayment:
            return .recurrentPayment
        }
    }
}
