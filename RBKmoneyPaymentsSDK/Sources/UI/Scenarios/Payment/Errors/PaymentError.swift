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

struct PaymentError: Error {

    enum Code {
        // payment method screen
        case cannotObtainInvoice
        case invoiceExpired
        case unexpectedInvoiceStatus

        case cannotObtainInvoicePaymentMethods
        case noPaymentMethods

        // bank card screen, apple pay screen
        case cannotCreatePaymentResource

        // payment progress screen
        case cannotCreatePayment

        case cannotObtainInvoiceEvents
        case userInteractionFailed
        case invoiceCancelled
        case paymentCancelled
        case paymentFailed
    }

    let code: Code
    let underlyingError: Error?

    let invoice: InvoiceDTO?

    let paymentResource: PaymentResourceDTO?
    let payerEmail: String?

    let payment: PaymentDTO?

    init(_ code: Code,
         underlyingError: Error? = nil,
         invoice: InvoiceDTO? = nil,
         paymentResource: PaymentResourceDTO? = nil,
         payerEmail: String? = nil,
         payment: PaymentDTO? = nil) {

        self.code = code
        self.underlyingError = underlyingError
        self.invoice = invoice
        self.paymentResource = paymentResource
        self.payerEmail = payerEmail
        self.payment = payment
    }
}
