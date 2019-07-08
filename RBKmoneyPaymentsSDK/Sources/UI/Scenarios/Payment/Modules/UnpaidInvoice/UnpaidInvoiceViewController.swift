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

final class UnpaidInvoiceViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var priceFormatter: UnpaidInvoicePriceFormatter = deferred()
    lazy var invoiceDetailsFormatter: UnpaidInvoiceInvoiceDetailsFormatter = deferred()

    // MARK: - Outlets
    @IBOutlet private var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet private var headerView: InvoiceSummaryView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var errorDescriptionLabel: UILabel!
    @IBOutlet private var retryButton: UIButton!
    @IBOutlet private var reenterDataButton: UIButton!
    @IBOutlet private var restartScenarioButton: UIButton!
    @IBOutlet private var errorImageView: UIImageView!
    @IBOutlet private var headerViewHeightConstraint: NSLayoutConstraint!

    // MARK: - ModuleView
    var output: UnpaidInvoiceViewModel.Input {
        return UnpaidInvoiceViewModel.Input(
            didTapCancel: cancelBarButtonItem.rx.tap.asSignal(),
            didTapRetry: retryButton.rx.tap.asSignal(),
            didTapReenterData: reenterDataButton.rx.tap.asSignal(),
            didTapRestartScenario: restartScenarioButton.rx.tap.asSignal()
        )
    }

    func setupBindings(to viewModel: UnpaidInvoiceViewModel) -> Disposable {
        return Disposables.create(
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.invoice
                .drive(setupHeader),
            viewModel.invoiceStatus
                .drive(setupStatus),
            viewModel.errorDescription
                .map { $0.attributed(with: .errorDescription) }
                .drive(errorDescriptionLabel.rx.attributedText),
            viewModel.canRetry
                .drive(retryButton.rx.isVisible),
            viewModel.canReenterData
                .drive(reenterDataButton.rx.isVisible),
            viewModel.canRestartScenario
                .drive(restartScenarioButton.rx.isVisible)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.hidesBackButton = true

        contentView.backgroundColor = Palette.colors.formBackground
        contentView.layer.cornerRadius = 6

        setupButtons()
    }

    private func setupButtons() {
        let buttons: [UIButton] = [
            retryButton,
            reenterDataButton,
            restartScenarioButton
        ]

        let titles = [
            R.string.localizable.unpaid_action_retry().attributed(with: .common),
            R.string.localizable.unpaid_action_reenter_data().attributed(with: .main),
            R.string.localizable.unpaid_action_restart_scenario().attributed(with: .other)
        ]

        let backgroundColors: [UIColor] = [
            Palette.colors.selectionBackground,
            .clear,
            .clear
        ]

        zip(buttons, titles).forEach {
            $0.0.setAttributedTitle($0.1, for: .normal)
        }

        zip(buttons, backgroundColors).forEach {
            $0.0.backgroundColor = $0.1
        }

        retryButton.layer.cornerRadius = 22

        reenterDataButton.layer.cornerRadius = 4
        reenterDataButton.layer.borderWidth = 2
        reenterDataButton.layer.borderColor = Palette.colors.main.cgColor
    }

    private var setupHeader: Binder<InvoiceDTO?> {
        return Binder(self) { this, invoice in
            this.headerViewHeightConstraint.isActive = invoice == nil

            guard let invoice = invoice else {
                return
            }

            let model = InvoiceSummaryView.Model(
                cost: this.priceFormatter.formattedPrice(amount: invoice.amount, currency: invoice.currency),
                details: this.invoiceDetailsFormatter.formattedDetails(invoice: invoice)
            )

            this.headerView.setup(with: model)
        }
    }

    private var setupStatus: Binder<UnpaidInvoiceViewModel.InvoiceStatus> {
        return Binder(self) { this, status in
            this.errorImageView.image = status.image
            this.titleLabel.attributedText = status.title.attributed(with: .title)
        }
    }
}

private extension UnpaidInvoiceViewModel.InvoiceStatus {

    var image: UIImage? {
        switch self {
        case .unpaid:
            return R.image.result.unpaid()
        default:
            return R.image.result.warning()
        }
    }

    var title: String {
        switch self {
        case .unpaid:
            return R.string.localizable.unpaid_status_unpaid()
        case .cancelled:
            return R.string.localizable.unpaid_status_cancelled()
        case .paid:
            return R.string.localizable.unpaid_status_paid()
        case .refunded:
            return R.string.localizable.unpaid_status_refunded()
        }
    }
}

private extension TextAttributes {

    static let common = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.selectionForeground)

    static let main = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.main)

    static let other = TextAttributes()
        .font(.systemFont(ofSize: 11, weight: .black))
        .letterSpacing(1)
        .textColor(Palette.colors.main)

    static let title = TextAttributes()
        .font(Palette.fonts.large)
        .lineHeight(35)
        .textAlignment(.center)
        .textColor(Palette.colors.wrong)

    static let errorDescription = TextAttributes()
        .font(Palette.fonts.common)
        .lineHeight(20)
        .textAlignment(.center)
        .textColor(Palette.colors.darkText)
}
