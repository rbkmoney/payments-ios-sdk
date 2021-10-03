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
        let string: String

        switch self {
        case .operationNotPermitted:
            string = RawValue.operationNotPermitted.rawValue
        case .invalidPartyStatus:
            string = RawValue.invalidPartyStatus.rawValue
        case .invalidShopStatus:
            string = RawValue.invalidShopStatus.rawValue
        case .invalidContractStatus:
            string = RawValue.invalidContractStatus.rawValue
        case .invalidShopID:
            string = RawValue.invalidShopID.rawValue
        case .invalidInvoiceCost:
            string = RawValue.invalidInvoiceCost.rawValue
        case .invalidInvoiceCart:
            string = RawValue.invalidInvoiceCart.rawValue
        case .invalidInvoiceStatus:
            string = RawValue.invalidInvoiceStatus.rawValue
        case .invoicePaymentPending:
            string = RawValue.invoicePaymentPending.rawValue
        case .invalidPaymentStatus:
            string = RawValue.invalidPaymentStatus.rawValue
        case .invalidPaymentResource:
            string = RawValue.invalidPaymentResource.rawValue
        case .invalidPaymentToolToken:
            string = RawValue.invalidPaymentToolToken.rawValue
        case .invalidPaymentSession:
            string = RawValue.invalidPaymentSession.rawValue
        case .invalidRecurrentParent:
            string = RawValue.invalidRecurrentParent.rawValue
        case .insufficentAccountBalance:
            string = RawValue.insufficentAccountBalance.rawValue
        case .invoicePaymentAmountExceeded:
            string = RawValue.invoicePaymentAmountExceeded.rawValue
        case .inconsistentRefundCurrency:
            string = RawValue.inconsistentRefundCurrency.rawValue
        case .changesetConflict:
            string = RawValue.changesetConflict.rawValue
        case .invalidChangeset:
            string = RawValue.invalidChangeset.rawValue
        case .invalidClaimStatus:
            string = RawValue.invalidClaimStatus.rawValue
        case .invalidClaimRevision:
            string = RawValue.invalidClaimRevision.rawValue
        case .limitExceeded:
            string = RawValue.limitExceeded.rawValue
        case .invalidDeadline:
            string = RawValue.invalidDeadline.rawValue
        case .invalidRequest:
            string = RawValue.invalidRequest.rawValue
        case .invalidPaymentTool:
            string = RawValue.invalidPaymentTool.rawValue
        case .accountLimitsExceeded:
            string = RawValue.accountLimitsExceeded.rawValue
        case .insufficientFunds:
            string = RawValue.insufficientFunds.rawValue
        case .preauthorizationFailed:
            string = RawValue.preauthorizationFailed.rawValue
        case .rejectedByIssuer:
            string = RawValue.rejectedByIssuer.rawValue
        case .paymentRejected:
            string = RawValue.paymentRejected.rawValue
        case let .unknown(value):
            string = value
        }

        try string.encode(to: encoder)
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
