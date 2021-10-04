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

final class PaidInvoiceViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var priceFormatter: PaidInvoicePriceFormatter = deferred()
    lazy var invoiceDetailsFormatter: PaidInvoiceInvoiceDetailsFormatter = deferred()

    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var headerView: InvoiceSummaryView!
    @IBOutlet private var doneButton: UIButton!
    @IBOutlet private var doneBarButtonItem: UIBarButtonItem!

    // MARK: - ModuleView
    var output: PaidInvoiceViewModel.Input {
        return PaidInvoiceViewModel.Input(
            didTapDone: Signal.merge(doneBarButtonItem.rx.tap.asSignal(), doneButton.rx.tap.asSignal())
        )
    }

    func setupBindings(to viewModel: PaidInvoiceViewModel) -> Disposable {
        return Disposables.create(
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.invoice
                .drive(setupHeader),
            viewModel.payer
                .drive(setupDescription)
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

        titleLabel.attributedText = R.string.localizable.paid_title().attributed(with: .title)

        doneButton.setAttributedTitle(R.string.localizable.paid_action_done().attributed(with: .button), for: .normal)
        doneButton.backgroundColor = Palette.colors.selectionBackground
        doneButton.layer.cornerRadius = 22
    }

    private var setupHeader: Binder<InvoiceDTO> {
        return Binder(self) { this, invoice in
            let model = InvoiceSummaryView.Model(
                cost: this.priceFormatter.formattedPrice(amount: invoice.amount, currency: invoice.currency),
                details: this.invoiceDetailsFormatter.formattedDetails(invoice: invoice)
            )
            this.headerView.setup(with: model)
        }
    }

    private var setupDescription: Binder<PayerDTO> {
        return Binder(self) { this, payer in
            let message: String

            switch payer {
            case let .paymentResource(resource):
                let prefix: String

                if case let .bankCard(cardData)? = resource.paymentToolDetails {
                    if let lastDigits = cardData.lastDigits {
                        prefix = R.string.localizable.paid_card_with_last_digits_description(cardData.paymentSystem.title, lastDigits)
                    } else {
                        prefix = R.string.localizable.paid_card_description(cardData.paymentSystem.title)
                    }
                } else {
                    prefix = R.string.localizable.paid_description()
                }

                if let email = resource.contactInfo.email {
                    message = "\(prefix)\n\(R.string.localizable.paid_email_description(email))"
                } else {
                    message = prefix
                }
            default:
                message = R.string.localizable.paid_description()
            }

            this.messageLabel.attributedText = message.attributed(with: .message)
        }
    }
}

private extension TextAttributes {

    static let title = TextAttributes()
        .font(Palette.fonts.large)
        .lineHeight(35)
        .textAlignment(.center)
        .textColor(Palette.colors.darkText)

    static let message = TextAttributes()
        .font(Palette.fonts.common)
        .lineHeight(20)
        .textAlignment(.center)
        .textColor(Palette.colors.darkText)

    static let button = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.selectionForeground)
}

private extension PaymentSystem {

    var title: String {
        switch self {
        case .visa:
            return "Visa"
        case .mastercard:
            return "MasterCard"
        case .visaelectron:
            return "Visa Electron"
        case .maestro:
            return "Maestro"
        case .forbrugsforeningen:
            return "FBF"
        case .dankort:
            return "Dankort"
        case .amex:
            return "Amex"
        case .dinersclub:
            return "Diners Club"
        case .discover:
            return "Discover"
        case .unionpay:
            return "UnionPay"
        case .jcb:
            return "JCB"
        case .nspkmir:
            return "МИР"
        case .elo:
            return "ELO"
        case .rupay:
            return "RuPay"
        case .dummy:
            return "DummyPay"
        case .uzcard:
            return "UZCÁRD"
        case .unknown:
            return ""
        }
    }
}
