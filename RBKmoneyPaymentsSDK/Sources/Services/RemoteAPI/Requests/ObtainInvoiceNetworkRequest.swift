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

/// https://developer.rbk.money/api/#operation/getInvoiceByID
struct ObtainInvoiceNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .get
    let path: NetworkRequestPath
    let bodyParameters: NetworkRequestParameters = .none
    let authorizationToken: String?

    init(invoiceIdentifier: String, invoiceAccessToken: String) {
        path = .relative("processing/invoices/\(invoiceIdentifier)")
        authorizationToken = invoiceAccessToken
    }
}
