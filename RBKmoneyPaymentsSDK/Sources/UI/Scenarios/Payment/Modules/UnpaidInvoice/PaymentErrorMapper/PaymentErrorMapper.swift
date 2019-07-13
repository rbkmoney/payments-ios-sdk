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

struct PaymentErrorMapper {

    // swiftlint:disable:next cyclomatic_complexity
    func retryRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotObtainInvoice, .cannotObtainInvoicePaymentMethods:
            if let networkError = error.underlyingError as? NetworkError, case .serverError = networkError.code {
                return nil
            }

            return .initial

        case .cannotCreatePaymentResource, .paymentCancelled:
            return .back

        case .cannotCreatePayment:
            guard let invoice = error.invoice,
                  let paymentResource = error.paymentResource,
                  let payerEmail = error.payerEmail,
                  let paymentMethod = error.paymentMethod,
                  let paymentSystems = error.paymentSystems
            else {
                return nil
            }

            typealias Source = PaymentProgressInputData.Parameters.Source
            let source = Source.resource(paymentResource, payerEmail: payerEmail, paymentExternalIdentifier: error.paymentExternalIdentifier)

            return .paymentProgress(.init(invoice: invoice, paymentMethod: paymentMethod, paymentSystems: paymentSystems, source: source))

        case .cannotObtainInvoiceEvents, .userInteractionFailed:
            guard let invoice = error.invoice,
                  let payment = error.payment,
                  let paymentMethod = error.paymentMethod,
                  let paymentSystems = error.paymentSystems
            else {
                return nil
            }

            return .paymentProgress(.init(invoice: invoice, paymentMethod: paymentMethod, paymentSystems: paymentSystems, source: .payment(payment)))

        case .paymentFailed:
            guard let networkError = error.underlyingError as? NetworkError, case let .serverError(serverError) = networkError.code else {
                return nil
            }

            switch serverError.code {
            case .insufficientFunds?, .invalidPaymentTool?, .rejectedByIssuer?, .paymentRejected?, .preauthorizationFailed?:
                return .back
            default:
                return nil
            }

        case .invoiceExpired,
             .unexpectedInvoiceStatus,
             .noPaymentMethods,
             .invoiceCancelled:

            return nil
        }
    }

    func reenterDataRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotCreatePaymentResource,
             .cannotCreatePayment,
             .cannotObtainInvoiceEvents,
             .userInteractionFailed,
             .paymentCancelled,
             .paymentFailed:

            guard let invoice = error.invoice, let paymentMethod = error.paymentMethod, let paymentSystems = error.paymentSystems else {
                return nil
            }

            switch paymentMethod {
            case .bankCard:
                return .bankCard(.init(invoice: invoice, paymentSystems: paymentSystems))
            case .applePay:
                return .applePay(.init(invoice: invoice, paymentSystems: paymentSystems))
            }

        case .cannotObtainInvoice,
             .invoiceExpired,
             .unexpectedInvoiceStatus,
             .cannotObtainInvoicePaymentMethods,
             .noPaymentMethods,
             .invoiceCancelled:

            return nil
        }
    }

    func restartScenarioRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotCreatePaymentResource,
             .cannotCreatePayment,
             .cannotObtainInvoiceEvents,
             .userInteractionFailed,
             .paymentCancelled,
             .paymentFailed:

            return .paymentMethod

        case .cannotObtainInvoice,
             .invoiceExpired,
             .unexpectedInvoiceStatus,
             .cannotObtainInvoicePaymentMethods,
             .noPaymentMethods,
             .invoiceCancelled:

            return nil
        }
    }
}
