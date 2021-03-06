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
import RxSwift

protocol PaymentProgressRemoteAPI {

    func createPayment(paymentParameters: PaymentParametersDTO, invoiceIdentifier: String, invoiceAccessToken: String) -> Single<PaymentDTO>
    func obtainInvoiceEvents(invoiceIdentifier: String, invoiceAccessToken: String) -> Single<[InvoiceEventDTO]>
    func obtainPayment(paymentExternalIdentifier: String, invoiceIdentifier: String, invoiceAccessToken: String) -> Single<PaymentDTO>
}

protocol PaymentProgress3DSURLRequestFactory {

    func urlRequest(for browserRequest: BrowserRequestDTO) -> URLRequest?

    var terminationURLString: String { get }
}

protocol PaymentProgressPaymentExternalIdentifierGenerator {

    func generateIdentifier() -> String
}
