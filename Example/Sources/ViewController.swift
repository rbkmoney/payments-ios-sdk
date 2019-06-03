//
//  ViewController.swift
//  Example
//

import UIKit
import RBKmoneyPaymentsSDK

final class ViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: ActivityIndicatorView!

    @IBAction private func purchaseFirstProduct() {
        performPurchase(with: Constants.firstProductInvoiceTemplate)
    }

    @IBAction private func purchaseSecondProduct() {
        performPurchase(with: Constants.secondProductInvoiceTemplate)
    }

    @IBAction private func purchaseThirdProduct() {
        performPurchase(with: Constants.thirdProductInvoiceTemplate)
    }

    private func performPurchase(with invoiceTemplate: InvoiceTemplate) {
        activityIndicatorView.startAnimating()

        InvoiceFactory.makeInvoiceWithTemplate(invoiceTemplate) { [weak self] invoice in
            DispatchQueue.main.async {
                guard let this = self else {
                    return
                }

                this.activityIndicatorView.stopAnimating()

                guard let invoice = invoice else {
                    let alert = UIAlertController(title: "Error", message: "Unable to get invoice!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))

                    self?.present(alert, animated: true)
                    return
                }

                print("Cool! We have got an invoice: \(invoice)")
            }
        }
    }
}

private enum Constants {

    static let firstProductInvoiceTemplate = InvoiceTemplate(identifier: "", accessToken: "")
    static let secondProductInvoiceTemplate = InvoiceTemplate(identifier: "", accessToken: "")
    static let thirdProductInvoiceTemplate = InvoiceTemplate(identifier: "", accessToken: "")
}
