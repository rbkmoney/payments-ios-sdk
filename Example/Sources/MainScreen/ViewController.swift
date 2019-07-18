//
//  ViewController.swift
//  Example
//

import UIKit
import RBKmoneyPaymentsSDK

final class ViewController: UIViewController {

    @IBOutlet private var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet private var bundleVersionLabel: UILabel!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bundleVersionLabel.text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        tableView.dataSource = self
    }

    private func processItem(_ item: ExampleProduct) {
        if let invoice = item.invoice {
            processItem(item, invoice: invoice)
        } else if let invoiceTemplate = item.invoiceTemplate {
            processItem(item, invoiceTemplate: invoiceTemplate)
        } else {
            showAlert(title: "Error", message: "Either invoice or invoice template should be specified!")
        }
    }

    private func processItem(_ item: ExampleProduct, invoiceTemplate: InvoiceTemplate) {
        activityIndicatorView.startAnimating()

        InvoiceFactory.makeInvoiceWithTemplate(invoiceTemplate, cost: item.cost) { [weak self] invoice in
            DispatchQueue.main.async {
                guard let this = self else {
                    return
                }

                this.activityIndicatorView.stopAnimating()

                guard let invoice = invoice else {
                    this.showAlert(title: "Error", message: "Unable to get invoice!")
                    return
                }

                this.processItem(item, invoice: invoice)
            }
        }
    }

    private func processItem(_ item: ExampleProduct, invoice: Invoice) {
        let paymentInputData = PaymentInputData(
            invoiceIdentifier: invoice.identifier,
            invoiceAccessToken: invoice.accessToken,
            shopName: item.shopName,
            payerEmail: item.payerEmail,
            allowedPaymentMethods: item.allowedPaymentMethods,
            applePayMerchantIdentifier: item.applePayMerchantIdentifier
        )

        let viewController = PaymentRootViewControllerAssembly.makeViewController(
            paymentInputData: paymentInputData,
            paymentDelegate: self
        )

        present(viewController, animated: true)
    }

    private func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExampleProduct.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell else {
            fatalError("Can't dequeue ProductTableViewCell")
        }

        typealias Model = ProductTableViewCell.Model

        let item = ExampleProduct.items[indexPath.row]
        let model = Model(emoji: item.emoji, title: item.title, description: item.description, cost: item.cost, buttonColor: item.buttonColor)

        cell.setup(with: model)

        cell.action = { [unowned self] in self.processItem(item) }

        return cell
    }
}

extension ViewController: PaymentDelegate {

    func paymentCancelled(invoiceIdentifier: String) {
        print("Payment cancelled, invoice identifier: \(invoiceIdentifier)")
        dismiss(animated: true)
    }

    func paymentFinished(invoiceIdentifier: String, paymentMethod: PaymentMethod) {
        print("Payment finished, invoice identifier: \(invoiceIdentifier), payment method: \(paymentMethod)")
        dismiss(animated: true)
    }
}
