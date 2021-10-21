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

/// https://developer.rbk.money/api/#operation/createPaymentResource
struct CreatePaymentResourceNetworkRequest: NetworkRequest {

    let httpMethod: NetworkRequestHTTPMethod = .post
    let path: NetworkRequestPath = .relative("processing/payment-resources")
    let bodyParameters: NetworkRequestParameters
    let authorizationToken: String?

    init(source: PaymentResourceSourceDTO, invoiceAccessToken: String) throws {
        let encoder = with(JSONEncoder()) {
            $0.dateEncodingStrategy = .customISO8601
        }

        bodyParameters = .rawJSON(try encoder.encode(source))
        authorizationToken = invoiceAccessToken
    }
}
