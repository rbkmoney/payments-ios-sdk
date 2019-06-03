//
//  InvoiceFactory.swift
//  Example
//

import Foundation

enum InvoiceFactory {

    static func makeInvoiceWithTemplate(_ template: InvoiceTemplate, cost: Cost, completion: @escaping (Invoice?) -> Void) {
        guard let request = makeRequest(invoiceTemplate: template, cost: cost) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            completion(parseResponse(data: data, error: error))
        }

        task.resume()
    }

    private static func makeRequest(invoiceTemplate: InvoiceTemplate, cost: Cost) -> URLRequest? {
        guard let url = URL(string: "https://api.rbk.money/v2/processing/invoice-templates/\(invoiceTemplate.identifier)/invoices") else {
            return nil
        }

        let requestBody = RequestBody(
            amount: Int64(truncating: NSDecimalNumber(decimal: cost.amount * 100)),
            currency: cost.currency
        )

        let encoder = JSONEncoder()

        guard let requestBodyData = try? encoder.encode(requestBody) else {
            return nil
        }

        let requestID = UUID().uuidString.replacingOccurrences(of: "-", with: "")

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.httpBody = requestBodyData

        request.setValue("Bearer \(invoiceTemplate.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(requestID, forHTTPHeaderField: "X-Request-ID")

        return request
    }

    private static func parseResponse(data: Data?, error: Error?) -> Invoice? {
        guard let data = data, error == nil else {
            return nil
        }

        let decoder = JSONDecoder()

        guard let responseBody = try? decoder.decode(ResponseBody.self, from: data) else {
            return nil
        }

        return Invoice(identifier: responseBody.invoice.id, accessToken: responseBody.invoiceAccessToken.payload)
    }

    private struct RequestBody: Codable {

        let amount: Int64
        let currency: Currency
    }

    private struct ResponseBody: Codable {

        struct Invoice: Codable {
            let id: String
        }

        struct InvoiceAccessToken: Codable {
            let payload: String
        }

        let invoice: Invoice
        let invoiceAccessToken: InvoiceAccessToken
    }
}
