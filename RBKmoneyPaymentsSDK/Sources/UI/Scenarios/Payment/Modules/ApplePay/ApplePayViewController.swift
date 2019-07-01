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

import PassKit
import RxCocoa
import RxSwift
import UIKit

final class ApplePayViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var priceFormatter: ApplePayPriceFormatter = deferred()
    lazy var invoiceDetailsFormatter: ApplePayInvoiceDetailsFormatter = deferred()
    lazy var applePayInfoProvider: ApplePayInfoProvider = deferred()

    // MARK: - Outlets
    @IBOutlet private var throbberView: ThrobberView!
    @IBOutlet private var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet private var headerView: InvoiceSummaryView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var emailTextField: BankCardTextField!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var payButtonContainerView: UIView!

    // MARK: - ModuleView
    var output: ApplePayViewModel.Input {
        return ApplePayViewModel.Input(
            didTapCancel: cancelBarButtonItem.rx.tap.asSignal(),
            didTapPay: payButton.rx.tap.asSignal(),
            email: emailTextField.rx.text.asDriver(),
            didEndEditingEmail: emailTextField.rx.controlEvent(.editingDidEnd).asSignal(),
            paymentToken: paymentTokenRelay.asSignal()
        )
    }

    func setupBindings(to viewModel: ApplePayViewModel) -> Disposable {
        return Disposables.create(
            viewModel.isLoading
                .drive(throbberView.rx.isAnimating),
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.invoice
                .drive(setupHeader),
            viewModel.requestInputData
                .emit(to: presentPaymentUI),

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
                })
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
        titleLabel.attributedText = R.string.localizable.apple_pay_header_title().attributed(with: .header)

        payButtonContainerView.clipsToBounds = true
        payButtonContainerView.layer.cornerRadius = 22

        payButtonContainerView.embedSubview(payButton)

        contentView.backgroundColor = Palette.colors.formBackground
        contentView.layer.cornerRadius = 6

        emailTextField.attributedPlaceholder = R.string.localizable.apple_pay_email_placeholder().attributed(with: .placeholder)
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

    private var presentPaymentUI: Binder<ApplePayRequestData> {
        return Binder(self) { this, requestData in
            let label = this.invoiceDetailsFormatter.formattedDetails(invoice: requestData.invoice)
            let amount = NSDecimalNumber(decimal: requestData.invoice.amount.value)
            let summaryItem = PKPaymentSummaryItem(label: label, amount: amount, type: .final)

            let request = with(PKPaymentRequest()) {
                $0.paymentSummaryItems = [summaryItem]
                $0.supportedNetworks = this.applePayInfoProvider.paymentNetworks(from: requestData.paymentSystems)
                $0.currencyCode = requestData.invoice.currency.rawValue
                $0.countryCode = requestData.countryCode
                $0.merchantIdentifier = requestData.merchantIdentifier
                $0.merchantCapabilities = this.applePayInfoProvider.capabilities
            }

            guard let viewController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                assertionFailure("Failed to create payment authorization view controller")
                return
            }

            viewController.delegate = this

            this.present(viewController, animated: true)
        }
    }

    private let paymentTokenRelay = PublishRelay<PKPaymentToken>()
    private let payButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    private var authorizedPayment: PKPayment?
    private let disposeBag = DisposeBag()
}

extension ApplePayViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true) {
            guard let payment = self.authorizedPayment else {
                return
            }

            self.authorizedPayment = nil
            self.paymentTokenRelay.accept(payment.token)
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        authorizedPayment = payment
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
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
}

private extension TextAttributes {

    static let header = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.darkText)
        .textAlignment(.left)

    static let placeholder = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.placeholder)
}
