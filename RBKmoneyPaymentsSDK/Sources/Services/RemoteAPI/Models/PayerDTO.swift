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

    typealias CustomerIdentifier = String

    struct PaymentResource {
        let paymentToolToken: String
        let paymentSessionIdentifier: String?
        let paymentToolDetails: PaymentToolDetailsDTO?
        let clientInfo: ClientInfoDTO?
        let contactInfo: ContactInfoDTO
    }

    struct RecurrentPayment {
        let contactInfo: ContactInfoDTO
        let parent: RecurrentPaymentParentDTO
    }

    case customer(CustomerIdentifier)
    case paymentResource(PaymentResource)
    case recurrentPayment(RecurrentPayment)
}

extension PayerDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PayerType.self, forKey: .type)

        switch type {
        case .customer:
            let identifier = try container.decode(CustomerIdentifier.self, forKey: .customerIdentifier)
            self = .customer(identifier)
        case .paymentResource:
            let resource = PaymentResource(
                paymentToolToken: try container.decode(String.self, forKey: .paymentToolToken),
                paymentSessionIdentifier: try container.decodeIfPresent(String.self, forKey: .paymentSessionIdentifier),
                paymentToolDetails: try container.decodeIfPresent(PaymentToolDetailsDTO.self, forKey: .paymentToolDetails),
                clientInfo: try container.decodeIfPresent(ClientInfoDTO.self, forKey: .clientInfo),
                contactInfo: try container.decode(ContactInfoDTO.self, forKey: .contactInfo)
            )
            self = .paymentResource(resource)
        case .recurrentPayment:
            let payment = RecurrentPayment(
                contactInfo: try container.decode(ContactInfoDTO.self, forKey: .contactInfo),
                parent: try container.decode(RecurrentPaymentParentDTO.self, forKey: .recurrentPaymentParent)
            )
            self = .recurrentPayment(payment)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .customer(identifier):
            try container.encode(PayerType.customer, forKey: .type)
            try container.encode(identifier, forKey: .customerIdentifier)
        case let .paymentResource(resource):
            try container.encode(PayerType.paymentResource, forKey: .type)
            try container.encode(resource.paymentToolToken, forKey: .paymentToolToken)
            try container.encodeIfPresent(resource.paymentSessionIdentifier, forKey: .paymentSessionIdentifier)
            try container.encodeIfPresent(resource.paymentToolDetails, forKey: .paymentToolDetails)
            try container.encodeIfPresent(resource.clientInfo, forKey: .clientInfo)
            try container.encode(resource.contactInfo, forKey: .contactInfo)
        case let .recurrentPayment(payment):
            try container.encode(PayerType.recurrentPayment, forKey: .type)
            try container.encode(payment.contactInfo, forKey: .contactInfo)
            try container.encode(payment.parent, forKey: .recurrentPaymentParent)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "payerType"
        case customerIdentifier = "customerID"
        case paymentToolToken
        case paymentSessionIdentifier = "paymentSession"
        case paymentToolDetails
        case clientInfo
        case contactInfo
        case recurrentPaymentParent = "recurrentParentPayment"
    }

    private enum PayerType: String, Codable {
        case customer = "CustomerPayer"
        case paymentResource = "PaymentResourcePayer"
        case recurrentPayment = "RecurrentPayer"
    }
}
