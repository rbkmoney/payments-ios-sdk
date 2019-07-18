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

final class BankCardViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var cardNumberFormatter: BankCardCardNumberFormatter = deferred()
    lazy var priceFormatter: BankCardPriceFormatter = deferred()
    lazy var invoiceDetailsFormatter: BankCardInvoiceDetailsFormatter = deferred()

    // MARK: - Outlets
    @IBOutlet private var headerView: InvoiceSummaryView!
    @IBOutlet private var cardNumberTextField: BankCardTextField!
    @IBOutlet private var expirationDateTextField: BankCardTextField!
    @IBOutlet private var cvvTextField: BankCardTextField!
    @IBOutlet private var cardholderTextField: BankCardTextField!
    @IBOutlet private var emailTextField: BankCardTextField!
    @IBOutlet private var payButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var throbberView: ThrobberView!
    @IBOutlet private var cancelBarButtonItem: UIBarButtonItem!

    // MARK: - ModuleView
    var output: BankCardViewModel.Input {
        return BankCardViewModel.Input(
            cardNumber: cardNumberTextField.rx.text.asDriver(),
            expirationDate: expirationDateTextField.rx.text.asDriver(),
            cvvCode: cvvTextField.rx.text.asDriver(),
            cardholder: cardholderTextField.rx.text.asDriver(),
            email: emailTextField.rx.text.asDriver(),
            didTapPay: payButton.rx.tap.asSignal(),
            didEndEditingCardNumber: cardNumberTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            didEndEditingCVV: cvvTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            didEndEditingExpirationDate: expirationDateTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            didEndEditingCardholder: cardholderTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            didEndEditingEmail: emailTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            didTapCancel: cancelBarButtonItem.rx.tap.asSignal()
        )
    }

    // swiftlint:disable:next function_body_length
    func setupBindings(to viewModel: BankCardViewModel) -> Disposable {
        return Disposables.create(
            viewModel.isLoading
                .drive(throbberView.rx.isAnimating),
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.invoice
                .map { [priceFormatter] in
                    let cost = priceFormatter.formattedPrice(amount: $0.amount, currency: $0.currency)
                    return R.string.localizable.bank_card_pay(cost).attributed(with: .button)
                }
                .drive(payButton.rx.attributedTitle(for: .normal)),
            viewModel.invoice
                .drive(setupHeader),

            // card number
            Observable
                .merge(
                    cardNumberTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .focused),
                    viewModel.validateCardNumber.asObservable().map { $0.customBorderStyle }
                )
                .bind(to: cardNumberTextField.rx.customBorderStyle),
            Observable
                .combineLatest(
                    Observable.merge(
                        viewModel.validateCardNumber.asObservable(),
                        cardNumberTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .unknown)
                    ),
                    viewModel.cardPaymentSystem.asObservable()
                )
                .map { $0.rightViewData(for: $1) }
                .bind(to: cardNumberTextField.rx.rightViewData),
            viewModel.cardNumberFieldMaxLength
                .drive(cardNumberFormatter.rx.maxLength),

            // cardholder
            Observable
                .merge(
                    cardholderTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .focused),
                    viewModel.validateCardholder.asObservable().map { $0.customBorderStyle }
                )
                .bind(to: cardholderTextField.rx.customBorderStyle),
            viewModel.validateCardholder
                .map { $0.defaultRightViewData }
                .drive(cardholderTextField.rx.rightViewData),

            // cvv
            Observable
                .merge(
                    cvvTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .focused),
                    viewModel.validateCVV.asObservable().map { $0.customBorderStyle }
                )
                .bind(to: cvvTextField.rx.customBorderStyle),
            viewModel.validateCVV
                .map { $0.defaultRightViewData }
                .drive(cvvTextField.rx.rightViewData),
            viewModel.formattedCVV
                .drive(cvvTextField.rx.text),

            // email
            Observable
                .merge(
                    emailTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .focused),
                    viewModel.validateEmail.asObservable().map { $0.customBorderStyle }
                )
                .bind(to: emailTextField.rx.customBorderStyle),
            viewModel.validateEmail
                .map { $0.defaultRightViewData }
                .drive(emailTextField.rx.rightViewData),
            viewModel.initialEmail
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .drive(Binder(emailTextField) {
                    $0.text = $1
                    $0.sendActions(for: .editingDidEnd)
                }),

            // date
            Observable
                .merge(
                    expirationDateTextField.rx.controlEvent([.editingDidBegin, .editingChanged]).map(to: .focused),
                    viewModel.validateDate.asObservable().map { $0.customBorderStyle }
                )
                .bind(to: expirationDateTextField.rx.customBorderStyle),
            viewModel.validateDate
                .map { $0.defaultRightViewData }
                .drive(expirationDateTextField.rx.rightViewData)
        )
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupInternalBindings()
    }

    // MARK: - Private
    private func setupUI() {
        titleLabel.attributedText = R.string.localizable.bank_card_header_title().attributed(with: .header)

        payButton.backgroundColor = Palette.colors.selectionBackground
        payButton.layer.cornerRadius = 22

        contentView.backgroundColor = Palette.colors.formBackground
        contentView.layer.cornerRadius = 6

        setupTextFields()
    }

    private func setupTextFields() {
        let textFields: [UITextField] = [
            cardNumberTextField,
            expirationDateTextField,
            cvvTextField,
            cardholderTextField,
            emailTextField
        ]
        let placeholders = [
            R.string.localizable.bank_card_card_number_placeholder(),
            R.string.localizable.bank_card_date_placeholder(),
            R.string.localizable.bank_card_cvc_placeholder(),
            R.string.localizable.bank_card_cardholder_placeholder(),
            R.string.localizable.bank_card_email_placeholder()
        ]

        zip(textFields, placeholders).forEach {
            $0.0.delegate = self
            $0.0.attributedPlaceholder = $0.1.attributed(with: .placeholder)
        }

        expirationDateTextField.inputView = expirationDatePickerView
        expirationDateTextField.tintColor = .clear
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

    private func setupInternalBindings() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { [weak self] notification -> UIEdgeInsets? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                guard let scrollViewFrame = self.map({ $0.scrollView.convert($0.scrollView.bounds, to: nil) }) else {
                    return nil
                }
                return UIEdgeInsets(top: 0, left: 0, bottom: scrollViewFrame.intersection(keyboardFrame).height, right: 0)
            }
            .bind(to: scrollView.rx.contentInset)
            .disposed(by: disposeBag)

        expirationDatePickerView.rx.didSelectDate
            .map { $0.formattedString }
            .emit(to: expirationDateTextField.rx.text)
            .disposed(by: disposeBag)

        payButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }

    private let expirationDatePickerView = BankCardExpirationDatePickerView()
    private let disposeBag = DisposeBag()
}

extension BankCardViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === cardNumberTextField {
            return cardNumberFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        } else {
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === cardNumberTextField {
            expirationDateTextField.becomeFirstResponder()
            return false
        }

        if textField === expirationDateTextField {
            cvvTextField.becomeFirstResponder()
            return false
        }

        if textField === cvvTextField {
            cardholderTextField.becomeFirstResponder()
            return false
        }

        if textField === cardholderTextField {
            emailTextField.becomeFirstResponder()
            return false
        }

        return true
    }
}

private extension ValidationResult {

    var customBorderStyle: BankCardTextField.CustomBorderStyle {
        switch self {
        case .unknown:
            return .unknown
        case .valid:
            return .valid
        case .invalid:
            return .invalid
        }
    }

    var defaultRightViewData: (UIImage?, UITextField.ViewMode) {
        switch self {
        case .unknown:
            return (nil, .always)
        case .valid:
            return (R.image.bankCard.checkmark(), .always)
        case .invalid:
            return (R.image.bankCard.cross(), .always)
        }
    }

    func rightViewData(for cardPaymentSystem: PaymentSystem?) -> (UIImage?, UITextField.ViewMode) {
        switch self {
        case .unknown:
            return (cardPaymentSystem?.image, .always)
        case .valid:
            return (cardPaymentSystem?.image, .always)
        case .invalid:
            return (R.image.bankCard.cross(), .always)
        }
    }
}

private extension PaymentSystem {

    var image: UIImage? {
        switch self {
        case .visa:
            return R.image.bankCard.visa()
        case .maestro, .mastercard:
            return R.image.bankCard.mastercard()
        case .nspkmir:
            return R.image.bankCard.nspkmir()
        default:
            return nil
        }
    }
}

private extension TextAttributes {

    static let header = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.darkText)
        .textAlignment(.left)

    static let button = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.selectionForeground)

    static let placeholder = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.placeholder)
}
