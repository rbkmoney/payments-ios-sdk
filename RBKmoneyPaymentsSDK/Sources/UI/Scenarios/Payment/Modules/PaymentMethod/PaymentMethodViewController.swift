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

import RxCocoa
import RxSwift
import UIKit

final class PaymentMethodViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var priceFormatter: PaymentMethodPriceFormatter = deferred()
    lazy var invoiceDetailsFormatter: PaymentMethodInvoiceDetailsFormatter = deferred()

    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var throbberView: ThrobberView!
    @IBOutlet private var cancelBarButtonItem: UIBarButtonItem!

    // MARK: - ModuleView
    var output: PaymentMethodViewModel.Input {
        return PaymentMethodViewModel.Input(
            didTapCancel: cancelBarButtonItem.rx.tap.asSignal(),
            didSelectItem: tableView.rx.modelSelected(PaymentMethodViewModel.Item.self).asSignal()
        )
    }

    func setupBindings(to viewModel: PaymentMethodViewModel) -> Disposable {
        let cellIdentifier = R.reuseIdentifier.paymentMethodCell.identifier

        return Disposables.create(
            viewModel.isLoading
                .drive(throbberView.rx.isAnimating),
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.invoice
                .drive(setupTableHeaderFooter),
            viewModel.items
                .drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: PaymentMethodCell.self)) { _, element, cell in
                    cell.setup(with: element.method.cellModel)
                }
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        tableView.register(R.nib.paymentMethodCell)
    }

    private var setupTableHeaderFooter: Binder<InvoiceDTO> {
        return Binder(self) { this, invoice in
            let width = this.tableView.frame.width

            let model = PaymentMethodsTableHeaderView.Model(
                cost: this.priceFormatter.formattedPrice(amount: invoice.amount, currency: invoice.currency),
                details: this.invoiceDetailsFormatter.formattedDetails(invoice: invoice)
            )
            this.tableHeaderView.frame = CGRect(origin: .zero, size: PaymentMethodsTableHeaderView.size(with: model, width: width))
            this.tableHeaderView.setup(with: model)

            this.tableFooterView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: Constants.tableFooterHeight))

            this.tableView.tableHeaderView = this.tableHeaderView
            this.tableView.tableFooterView = this.tableFooterView
        }
    }

    private lazy var tableHeaderView = PaymentMethodsTableHeaderView()
    private lazy var tableFooterView = PaymentMethodsTableFooterView()
}

private enum Constants {

    static let tableFooterHeight: CGFloat = 150
}

private extension PaymentMethod {

    var cellModel: PaymentMethodCell.Model {
        switch self {
        case .bankCard:
            return .init(
                icon: R.image.paymentMethods.bankcard(),
                title: R.string.localizable.payment_method_bank_card(),
                subtitle: nil,
                style: .default
            )
        case .applePay:
            return .init(
                icon: R.image.paymentMethods.applepay(),
                title: nil,
                subtitle: nil,
                style: .black
            )
        }
    }
}
