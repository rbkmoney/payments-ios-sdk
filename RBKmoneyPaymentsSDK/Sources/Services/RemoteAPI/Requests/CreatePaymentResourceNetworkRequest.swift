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
        // We know that source may contain Data. This will be ApplePay payment token,
        // an "UTF-8 encoded serialization of a JSON dictionary", essentially a String.
        // Unfortunately, Codable won't allow us to append already encoded data, so
        // here is a trick. We store data as base64 string with begin and end markers using
        // custom DataEncodingStrategy. Encoder will also add surrounding quotes. Later, we
        // search encoded data for our markers, remove them, remove surrounding quotes also
        // and decode base64 to get original data.

        let encoder = with(JSONEncoder()) {
            $0.dateEncodingStrategy = .customISO8601
            $0.dataEncodingStrategy = .custom {
                let value = Constants.encodedDataStart + $0.base64EncodedString() + Constants.encodedDataEnd

                var container = $1.singleValueContainer()
                try container.encode(value)
            }
        }

        let intermediateData = try encoder.encode(source)

        let resultData = String(data: intermediateData, encoding: .utf8).flatMap {
            return $0
                .components(separatedBy: "\"\(Constants.encodedDataStart)")
                .flatMap { $0.components(separatedBy: "\(Constants.encodedDataEnd)\"") }
                .filter { !$0.isEmpty }
                .enumerated()
                .compactMap {
                    if $0.offset.isMultiple(of: 2) {
                        return $0.element
                    } else {
                        return Data(base64Encoded: $0.element).flatMap { String(data: $0, encoding: .utf8) }
                    }
                }
                .joined()
                .data(using: .utf8)
        }

        guard let data = resultData else {
            throw Error.noJSONData
        }

        bodyParameters = .rawJSON(data)
        authorizationToken = invoiceAccessToken
    }

    private enum Error: Swift.Error {
        case noJSONData
    }

    private enum Constants {
        static let encodedDataStart = "@base64_"
        static let encodedDataEnd = "_base64@"
    }
}
