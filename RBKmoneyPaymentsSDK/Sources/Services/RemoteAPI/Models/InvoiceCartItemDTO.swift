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

struct InvoiceCartItemDTO: Codable {

    enum CodingKeys: String, CodingKey {
        case productName = "product"
        case quantity
        case price
        case total = "cost"
    }

    let productName: String
    let quantity: Int64
    let price: AmountDTO
    let total: AmountDTO?
}
