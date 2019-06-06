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

typealias ErrorNetworkResponse = DecodableNetworkResponse<ServerErrorDTO>

struct ServerErrorDTO: Codable {

    enum Code: Equatable {
        case operationNotPermitted
        case invalidPartyStatus
        case invalidShopStatus
        case invalidContractStatus
        case invalidShopID
        case invalidInvoiceCost
        case invalidInvoiceCart
        case invalidInvoiceStatus
        case invoicePaymentPending
        case invalidPaymentStatus
        case invalidPaymentResource
        case invalidPaymentToolToken
        case invalidPaymentSession
        case invalidRecurrentParent
        case insufficentAccountBalance
        case invoicePaymentAmountExceeded
        case inconsistentRefundCurrency
        case changesetConflict
        case invalidChangeset
        case invalidClaimStatus
        case invalidClaimRevision
        case limitExceeded
        case invalidDeadline
        case invalidRequest

        case invalidPaymentTool
        case accountLimitsExceeded
        case insufficientFunds
        case preauthorizationFailed
        case rejectedByIssuer
        case paymentRejected

        case unknown(String)
    }

    let code: Code?
    let message: String?
}

extension ServerErrorDTO.Code: Codable {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.RawValue.self)

        switch rawValue {
        case RawValue.operationNotPermitted.rawValue:
            self = .operationNotPermitted
        case RawValue.invalidPartyStatus.rawValue:
            self = .invalidPartyStatus
        case RawValue.invalidShopStatus.rawValue:
            self = .invalidShopStatus
        case RawValue.invalidContractStatus.rawValue:
            self = .invalidContractStatus
        case RawValue.invalidShopID.rawValue:
            self = .invalidShopID
        case RawValue.invalidInvoiceCost.rawValue:
            self = .invalidInvoiceCost
        case RawValue.invalidInvoiceCart.rawValue:
            self = .invalidInvoiceCart
        case RawValue.invalidInvoiceStatus.rawValue:
            self = .invalidInvoiceStatus
        case RawValue.invoicePaymentPending.rawValue:
            self = .invoicePaymentPending
        case RawValue.invalidPaymentStatus.rawValue:
            self = .invalidPaymentStatus
        case RawValue.invalidPaymentResource.rawValue:
            self = .invalidPaymentResource
        case RawValue.invalidPaymentToolToken.rawValue:
            self = .invalidPaymentToolToken
        case RawValue.invalidPaymentSession.rawValue:
            self = .invalidPaymentSession
        case RawValue.invalidRecurrentParent.rawValue:
            self = .invalidRecurrentParent
        case RawValue.insufficentAccountBalance.rawValue:
            self = .insufficentAccountBalance
        case RawValue.invoicePaymentAmountExceeded.rawValue:
            self = .invoicePaymentAmountExceeded
        case RawValue.inconsistentRefundCurrency.rawValue:
            self = .inconsistentRefundCurrency
        case RawValue.changesetConflict.rawValue:
            self = .changesetConflict
        case RawValue.invalidChangeset.rawValue:
            self = .invalidChangeset
        case RawValue.invalidClaimStatus.rawValue:
            self = .invalidClaimStatus
        case RawValue.invalidClaimRevision.rawValue:
            self = .invalidClaimRevision
        case RawValue.limitExceeded.rawValue:
            self = .limitExceeded
        case RawValue.invalidDeadline.rawValue:
            self = .invalidDeadline
        case RawValue.invalidRequest.rawValue:
            self = .invalidRequest
        case RawValue.invalidPaymentTool.rawValue:
            self = .invalidPaymentTool
        case RawValue.accountLimitsExceeded.rawValue:
            self = .accountLimitsExceeded
        case RawValue.insufficientFunds.rawValue:
            self = .insufficientFunds
        case RawValue.preauthorizationFailed.rawValue:
            self = .preauthorizationFailed
        case RawValue.rejectedByIssuer.rawValue:
            self = .rejectedByIssuer
        case RawValue.paymentRejected.rawValue:
            self = .paymentRejected
        default:
            self = .unknown(rawValue)
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .operationNotPermitted:
            try container.encode(RawValue.operationNotPermitted.rawValue)
        case .invalidPartyStatus:
            try container.encode(RawValue.invalidPartyStatus.rawValue)
        case .invalidShopStatus:
            try container.encode(RawValue.invalidShopStatus.rawValue)
        case .invalidContractStatus:
            try container.encode(RawValue.invalidContractStatus.rawValue)
        case .invalidShopID:
            try container.encode(RawValue.invalidShopID.rawValue)
        case .invalidInvoiceCost:
            try container.encode(RawValue.invalidInvoiceCost.rawValue)
        case .invalidInvoiceCart:
            try container.encode(RawValue.invalidInvoiceCart.rawValue)
        case .invalidInvoiceStatus:
            try container.encode(RawValue.invalidInvoiceStatus.rawValue)
        case .invoicePaymentPending:
            try container.encode(RawValue.invoicePaymentPending.rawValue)
        case .invalidPaymentStatus:
            try container.encode(RawValue.invalidPaymentStatus.rawValue)
        case .invalidPaymentResource:
            try container.encode(RawValue.invalidPaymentResource.rawValue)
        case .invalidPaymentToolToken:
            try container.encode(RawValue.invalidPaymentToolToken.rawValue)
        case .invalidPaymentSession:
            try container.encode(RawValue.invalidPaymentSession.rawValue)
        case .invalidRecurrentParent:
            try container.encode(RawValue.invalidRecurrentParent.rawValue)
        case .insufficentAccountBalance:
            try container.encode(RawValue.insufficentAccountBalance.rawValue)
        case .invoicePaymentAmountExceeded:
            try container.encode(RawValue.invoicePaymentAmountExceeded.rawValue)
        case .inconsistentRefundCurrency:
            try container.encode(RawValue.inconsistentRefundCurrency.rawValue)
        case .changesetConflict:
            try container.encode(RawValue.changesetConflict.rawValue)
        case .invalidChangeset:
            try container.encode(RawValue.invalidChangeset.rawValue)
        case .invalidClaimStatus:
            try container.encode(RawValue.invalidClaimStatus.rawValue)
        case .invalidClaimRevision:
            try container.encode(RawValue.invalidClaimRevision.rawValue)
        case .limitExceeded:
            try container.encode(RawValue.limitExceeded.rawValue)
        case .invalidDeadline:
            try container.encode(RawValue.invalidDeadline.rawValue)
        case .invalidRequest:
            try container.encode(RawValue.invalidRequest.rawValue)
        case .invalidPaymentTool:
            try container.encode(RawValue.invalidPaymentTool.rawValue)
        case .accountLimitsExceeded:
            try container.encode(RawValue.accountLimitsExceeded.rawValue)
        case .insufficientFunds:
            try container.encode(RawValue.insufficientFunds.rawValue)
        case .preauthorizationFailed:
            try container.encode(RawValue.preauthorizationFailed.rawValue)
        case .rejectedByIssuer:
            try container.encode(RawValue.rejectedByIssuer.rawValue)
        case .paymentRejected:
            try container.encode(RawValue.paymentRejected.rawValue)
        case let .unknown(value):
            try container.encode(value)
        }
    }

    private enum RawValue: String {
        case operationNotPermitted
        case invalidPartyStatus
        case invalidShopStatus
        case invalidContractStatus
        case invalidShopID
        case invalidInvoiceCost
        case invalidInvoiceCart
        case invalidInvoiceStatus
        case invoicePaymentPending
        case invalidPaymentStatus
        case invalidPaymentResource
        case invalidPaymentToolToken
        case invalidPaymentSession
        case invalidRecurrentParent
        case insufficentAccountBalance
        case invoicePaymentAmountExceeded
        case inconsistentRefundCurrency
        case changesetConflict
        case invalidChangeset
        case invalidClaimStatus
        case invalidClaimRevision
        case limitExceeded
        case invalidDeadline
        case invalidRequest

        case invalidPaymentTool = "InvalidPaymentTool"
        case accountLimitsExceeded = "AccountLimitsExceeded"
        case insufficientFunds = "InsufficientFunds"
        case preauthorizationFailed = "PreauthorizationFailed"
        case rejectedByIssuer = "RejectedByIssuer"
        case paymentRejected = "PaymentRejected"
    }
}
