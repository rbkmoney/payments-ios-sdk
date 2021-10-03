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

struct CryptoAmountDTO {

    let value: Decimal
}

extension CryptoAmountDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        if let decimal = Decimal(string: raw) {
            value = decimal
        } else {
            throw DecodingError.valueNotFound(Decimal.self, DecodingError.Context(codingPath: [], debugDescription: "Can't create decimal value"))
        }
    }

    func encode(to encoder: Encoder) throws {
        let string = "\(value)"
        try string.encode(to: encoder)
    }
}
