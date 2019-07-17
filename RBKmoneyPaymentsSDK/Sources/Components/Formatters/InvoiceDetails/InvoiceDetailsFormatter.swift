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

struct InvoiceDetailsFormatter {

    // MARK: - Internal
    func formattedDetails(invoice: InvoiceDTO) -> String {
        let products: [String]

        if let cartItems = invoice.cart, cartItems.count > 1 {
            products = cartItems.map { "\($0.productName) × \($0.quantity)" }
        } else {
            products = [invoice.productName]
        }

        let parts = products + [invoice.description ?? ""]

        let joined = parts
            .flatMap { $0.components(separatedBy: ".") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ". ")

        return joined.isEmpty ? "" : joined + "."
    }
}
