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

    // MARK: - Internal
    func retryRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotObtainInvoice, .cannotObtainInvoicePaymentMethods:
            if let networkError = error.underlyingError as? NetworkError, case .serverError = networkError.code {
                return nil
            }
            return .initial
        case .cannotCreatePayment:
            guard let invoice = error.invoice, let paymentResource = error.paymentResource, let payerEmail = error.payerEmail else {
                return nil
            }
            return .paymentProgress(.init(invoice: invoice, source: .resource(paymentResource, payerEmail: payerEmail)))
        case .cannotObtainInvoiceEvents, .userInteractionFailed:
            guard let invoice = error.invoice, let payment = error.payment else {
                return nil
            }
            return .paymentProgress(.init(invoice: invoice, source: .payment(payment)))
        default:
            return nil
        }
    }

    func reenterDataRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotCreatePaymentResource:
            return .back
        case .paymentFailed:
            guard let serverError = error.underlyingError as? NetworkError, case let .serverError(value) = serverError.code else {
                return nil
            }
            switch value.code {
            case .insufficientFunds?, .invalidPaymentTool?, .rejectedByIssuer?, .paymentRejected?, .preauthorizationFailed?:
                return .back
            default:
                return nil
            }
        default:
            return nil
        }
    }

    func restartScenarioRoute(for error: PaymentError) -> PaymentRoute? {
        switch error.code {
        case .cannotCreatePaymentResource, .cannotCreatePayment, .cannotObtainInvoiceEvents, .paymentCancelled, .paymentFailed:
            return .paymentMethod
        default:
            return nil
        }
    }
}
