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

import RxSwift

protocol RemoteAPINetworkClient {

    func performRequest(_ request: ObtainInvoiceNetworkRequest) -> Single<InvoiceNetworkResponse>
    func performRequest(_ request: ObtainInvoicePaymentMethodsNetworkRequest) -> Single<InvoicePaymentMethodsNetworkResponse>
    func performRequest(_ request: CreatePaymentResourceNetworkRequest) -> Single<PaymentResourceNetworkResponse>
    func performRequest(_ request: CreatePaymentNetworkRequest) -> Single<PaymentNetworkResponse>
    func performRequest(_ request: ObtainInvoiceEventsNetworkRequest) -> Single<InvoiceEventsNetworkResponse>
}

protocol RemoteAPIFingerprintProvider {

    var fingerprint: String { get }
}
