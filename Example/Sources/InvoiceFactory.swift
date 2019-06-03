//
//  InvoiceFactory.swift
//  Example
//

import Foundation

enum InvoiceFactory {

    static func makeInvoiceWithTemplate(_ template: InvoiceTemplate, completion: @escaping (Invoice?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            completion(nil)
        }
    }
}
