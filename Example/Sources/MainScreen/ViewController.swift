//
//  ViewController.swift
//  Example
//

import UIKit
import RBKmoneyPaymentsSDK

final class ViewController: UIViewController {

    @IBOutlet private weak var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet private weak var bundleVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bundleVersionLabel.text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    @IBAction private func purchaseFirstProduct() {
        performPurchase(invoiceTemplate: Constants.firstProductInvoiceTemplate, cost: Constants.firstProductCost)
    }

    @IBAction private func purchaseSecondProduct() {
        performPurchase(invoiceTemplate: Constants.secondProductInvoiceTemplate, cost: Constants.secondProductCost)
    }

    @IBAction private func purchaseThirdProduct() {
        performPurchase(invoiceTemplate: Constants.thirdProductInvoiceTemplate, cost: Constants.thirdProductCost)
    }

    private func performPurchase(invoiceTemplate: InvoiceTemplate, cost: Cost) {
        activityIndicatorView.startAnimating()

        InvoiceFactory.makeInvoiceWithTemplate(invoiceTemplate, cost: cost) { [weak self] invoice in
            DispatchQueue.main.async {
                guard let this = self else {
                    return
                }

                this.activityIndicatorView.stopAnimating()

                guard let invoice = invoice else {
                    this.showAlert(title: "Error", message: "Unable to get invoice!")
                    return
                }

                let paymentInputData = PaymentInputData(
                    invoiceIdentifier: invoice.identifier,
                    invoiceAccessToken: invoice.accessToken,
                    applePayMerchantIdentifier: Bundle.main.infoDictionary?["APPLE_PAY_MERCHANT_IDENTIFIER"] as? String,
                    shopName: "test.shop.ru"
                )

                let viewController = PaymentRootViewControllerAssembly.makeViewController(
                    paymentInputData: paymentInputData,
                    paymentDelegate: this
                )

                this.present(viewController, animated: true)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
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

private enum Constants {

    static let firstProductInvoiceTemplate = InvoiceTemplate(
        identifier: "1AYpfar3Yzw",
        accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTY1Mjc3LCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZcGZibm9RV3UiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6IjYxNmI3NzQ1LTVmZmItNDQ3ZC04ZjEwLTU5ODUwZGEzOGNiMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZcGZhcjNZencuaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZcGZhcjNZenc6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.CF6udq7_wwIX0wmnKQdxv7cTjy99mKjIMvrdvXBKsV0mp48UaDZnnjX8xfS0xLP3padCgWTG6bcTtkuQNE-Sqg"
    )
    static let firstProductCost = Cost(amount: 10, currency: .rub)

    static let secondProductInvoiceTemplate = InvoiceTemplate(
        identifier: "1AYuebbSaRM",
        accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTcyNTYxLCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZdWVjT3Fpb0siLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6Ijc3OGI2ZWI4LTYzZTUtNDEwNS04ZWQ5LWUxYjQ1Mjk1OGNjMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWViYlNhUk0uaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWViYlNhUk06cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.4l24Pt8GL1UoEOFohlKtvGmjob9mhrcFRprDPpYzu_82mIyQByzbyih7FJdiUY6L_y72m7GVFMBnD-BZCPel8g"
    )
    static let secondProductCost = Cost(amount: 2.99, currency: .usd)

    static let thirdProductInvoiceTemplate = InvoiceTemplate(
        identifier: "1AYuby17Ho8",
        accessToken: "eyJhbGciOiJFUzI1NiIsImtpZCI6IllKSWl0UWNNNll6TkgtT0pyS2s4VWdjdFBVMlBoLVFCLS1tLXJ5TWtrU3MiLCJ0eXAiOiJKV1QifQ.eyJhY3IiOiIwIiwiYWxsb3dlZC1vcmlnaW5zIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImh0dHBzOi8vZGFzaGJvYXJkLnJiay5tb25leSJdLCJhdWQiOiJrb2ZmaW5nIiwiYXV0aF90aW1lIjoxNTU5NTY1Mjc2LCJhenAiOiJrb2ZmaW5nIiwiZW1haWwiOiJhbGV4ZXkueXVraW5Ac2ltYmlyc29mdC5jb20iLCJleHAiOjAsImZhbWlseV9uYW1lIjoiWXVraW4iLCJnaXZlbl9uYW1lIjoiQWxleGV5IiwiaWF0IjoxNTU5NTcyNTYxLCJpc3MiOiJodHRwczovL2F1dGgucmJrLm1vbmV5L2F1dGgvcmVhbG1zL2V4dGVybmFsIiwianRpIjoiMUFZdWJ6NFAzcjYiLCJuYW1lIjoiQWxleGV5IFl1a2luIiwibmJmIjowLCJub25jZSI6Ijc3OGI2ZWI4LTYzZTUtNDEwNS04ZWQ5LWUxYjQ1Mjk1OGNjMSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFsZXhleS55dWtpbkBzaW1iaXJzb2Z0LmNvbSIsInJlc291cmNlX2FjY2VzcyI6eyJjb21tb24tYXBpIjp7InJvbGVzIjpbInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWJ5MTdIbzguaW52b2ljZV90ZW1wbGF0ZV9pbnZvaWNlczp3cml0ZSIsInBhcnR5LiouaW52b2ljZV90ZW1wbGF0ZXMuMUFZdWJ5MTdIbzg6cmVhZCJdfX0sInNjb3BlIjoib3BlbmlkIiwic2Vzc2lvbl9zdGF0ZSI6IjE2ZjU1ODkwLTY3NDEtNDUwYy1iNjBlLTUxMWM0ODRjOTYyNSIsInN1YiI6ImVhOTIyNzJiLTI5MDYtNDQwYS1iOTY0LWYyNWY1NjIzZDUxZSIsInR5cCI6IkJlYXJlciJ9.XrYKE8n7jBVcYtSPu-YrfdUHJn7NDkfMs15Cgoohyce0zMqXUisu677leLNvIPnC-EsW3E4caHGrrsfTsLekcQ"
    )
    static let thirdProductCost = Cost(amount: 5.50, currency: .eur)
}
