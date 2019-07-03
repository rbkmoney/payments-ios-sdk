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

struct ErrorMessageFactory {

    // MARK: - Internal
    func errorMessage(for error: Error) -> String {
        switch error {
        case let error as NetworkError:
            return message(for: error)
        case let error as PaymentError:
            return message(for: error)
        case let error as URLError:
            return message(for: error)
        default:
            return error.localizedDescription
        }
    }

    // MARK: - Private
    private func message(for error: NetworkError) -> String {
        switch error.code {
        case .cannotEncodeRequestBody:
            return R.string.localizable.error_message_cannot_build_request()
        case .cannotMapResponse:
            return R.string.localizable.error_message_response_mapping_error()
        case .wrongResponseType:
            return R.string.localizable.error_message_unknown_error()
        case let .unacceptableResponseStatusCode(code):
            return R.string.localizable.error_message_unacceptable_status_code(code)
        case let .serverError(error):
            return message(for: error)
        }
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func message(for error: ServerErrorDTO) -> String {
        guard let code = error.code else {
            return R.string.localizable.error_message_unknown_error()
        }

        switch code {
        case .operationNotPermitted:
            return R.string.localizable.error_message_operation_not_permitted()
        case .invalidPartyStatus:
            return R.string.localizable.error_message_invalid_party_status()
        case .invalidShopStatus:
            return R.string.localizable.error_message_invalid_shop_status()
        case .invalidContractStatus:
            return R.string.localizable.error_message_invalid_contract_status()
        case .invalidShopID:
            return R.string.localizable.error_message_invalid_shop_id()
        case .invalidInvoiceCost:
            return R.string.localizable.error_message_invalid_invoice_cost()
        case .invalidInvoiceCart:
            return R.string.localizable.error_message_invalid_invoice_cart()
        case .invalidInvoiceStatus:
            return R.string.localizable.error_message_invalid_invoice_status()
        case .invoicePaymentPending:
            return R.string.localizable.error_message_invoice_payment_pending()
        case .invalidPaymentStatus:
            return R.string.localizable.error_message_invalid_payment_status()
        case .invalidPaymentResource:
            return R.string.localizable.error_message_invalid_payment_resource()
        case .invalidPaymentToolToken:
            return R.string.localizable.error_message_invalid_payment_tool_token()
        case .invalidPaymentSession:
            return R.string.localizable.error_message_invalid_payment_session()
        case .invalidRecurrentParent:
            return R.string.localizable.error_message_invalid_recurrent_parent()
        case .insufficentAccountBalance:
            return R.string.localizable.error_message_insufficent_account_balance()
        case .invoicePaymentAmountExceeded:
            return R.string.localizable.error_message_invoice_payment_amount_exceeded()
        case .inconsistentRefundCurrency:
            return R.string.localizable.error_message_inconsistent_refund_currency()
        case .changesetConflict:
            return R.string.localizable.error_message_changeset_conflict()
        case .invalidChangeset:
            return R.string.localizable.error_message_invalid_changeset()
        case .invalidClaimStatus:
            return R.string.localizable.error_message_invalid_claim_status()
        case .invalidClaimRevision:
            return R.string.localizable.error_message_invalid_claim_revision()
        case .limitExceeded:
            return R.string.localizable.error_message_limit_exceeded()
        case .invalidDeadline:
            return R.string.localizable.error_message_invalid_deadline()
        case .invalidRequest:
            return R.string.localizable.error_message_invalid_request()
        case .invalidPaymentTool:
            return R.string.localizable.error_message_invalid_payment_tool()
        case .accountLimitsExceeded:
            return R.string.localizable.error_message_account_limits_exceeded()
        case .insufficientFunds:
            return R.string.localizable.error_message_insufficient_funds()
        case .preauthorizationFailed:
            return R.string.localizable.error_message_preauthorization_failed()
        case .rejectedByIssuer:
            return R.string.localizable.error_message_rejected_by_issuer()
        case .paymentRejected:
            return R.string.localizable.error_message_payment_rejected()
        case let .unknown(code):
            return R.string.localizable.error_message_unknown_server_error(code)
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func message(for error: PaymentError) -> String {
        switch error.code {
        case .cannotObtainInvoice:
            return R.string.localizable.error_message_cannot_obtain_invoice()
        case .invoiceExpired:
            return R.string.localizable.error_message_invoice_expired()
        case .unexpectedInvoiceStatus:
            return R.string.localizable.error_message_unexpected_invoice_status()
        case .cannotObtainInvoicePaymentMethods:
            return R.string.localizable.error_message_cannot_obtain_invoice_payment_methods()
        case .noPaymentMethods:
            return R.string.localizable.error_message_no_payment_methods()
        case .cannotCreatePaymentResource:
            return R.string.localizable.error_message_cannot_create_payment_resource()
        case .cannotCreatePayment:
            return R.string.localizable.error_message_cannot_create_payment()
        case .cannotObtainInvoiceEvents:
            return R.string.localizable.error_message_cannot_obtain_invoice_events()
        case .userInteractionFailed:
            return R.string.localizable.error_message_user_interaction_failed()
        case .invoiceCancelled:
            return R.string.localizable.error_message_invoice_cancelled()
        case .paymentCancelled:
            return R.string.localizable.error_message_payment_cancelled()
        case .paymentFailed:
            return R.string.localizable.error_message_payment_failed()
        }
    }

    private func message(for error: URLError) -> String {
        switch error.code {
        case .secureConnectionFailed, .serverCertificateUntrusted, .clientCertificateRejected:
            return R.string.localizable.error_message_server_insecure_connection()
        case .cannotFindHost, .cannotConnectToHost:
            return R.string.localizable.error_message_server_unavailable()
        case .notConnectedToInternet, .networkConnectionLost:
            return R.string.localizable.error_message_no_internet()
        default:
            return R.string.localizable.error_message_request_failed()
        }
    }
}
