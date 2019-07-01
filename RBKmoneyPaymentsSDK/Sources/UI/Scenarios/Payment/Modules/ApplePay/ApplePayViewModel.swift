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

import PassKit.PKPaymentToken
import RxCocoa
import RxSwift

final class ApplePayViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: ApplePayInputData = deferred()
    lazy var remoteAPI: ApplePayRemoteAPI = deferred()
    lazy var emailValidator: Validator = deferred()
    lazy var locale: Locale = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let didTapCancel: Signal<Void>
        let didTapPay: Signal<Void>
        let email: Driver<String?>
        let didEndEditingEmail: Signal<Void>
        let paymentToken: Signal<PKPaymentToken>
    }

    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.didTapPay
            .emit(to: didTapPayRelay)
            .disposed(with: disposable)

        input.email
            .drive(emailRelay)
            .disposed(with: disposable)

        input.didEndEditingEmail
            .emit(to: didEndEditingEmailRelay)
            .disposed(with: disposable)

        input.paymentToken
            .emit(to: paymentTokenRelay)
            .disposed(with: disposable)

        let continueRoute = paymentToolWithEmail
            .withLatestFrom(inputDataObservable) { ($0, $1) }
            .flatMap { [createPaymentResource] tuple -> Observable<PaymentRoute> in
                let ((paymentTool, email), data) = tuple

                return createPaymentResource(paymentTool, data)
                    .map { PaymentRoute.paymentProgress(.init(invoice: data.parameters.invoice, paymentResource: $0, payerEmail: email)) }
            }

        let cancelRoute = input.didTapCancel
            .asObservable()
            .map(to: PaymentRoute.cancel)

        Observable
            .merge(continueRoute, cancelRoute)
            .bind(to: Binder(self) {
                $0.router.trigger(route: $1)
            })
            .disposed(with: disposable)

        return disposable
    }

    // MARK: - Internal
    private(set) lazy var isLoading = activityTracker.asDriver()

    private(set) lazy var invoice = inputDataObservable
        .map { $0.parameters.invoice }
        .asDriver(onError: .never)

    private(set) lazy var initialEmail = inputDataObservable
        .compactMap { $0.paymentInputData.payerEmail }
        .asDriver(onError: .never)

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    private(set) lazy var validateEmail: Driver<ValidationResult> = Observable
        .merge(emptyEmail, correctEmail)
        .asDriver(onError: .never)

    private(set) lazy var requestInputData = didTapPayRelay
        .withLatestFrom(emptyEmail)
        .filter { $0 == .valid }
        .withLatestFrom(inputDataObservable)
        .compactMap(requestMapper)
        .asSignal(onError: .never)

    // MARK: - Private
    private let didTapPayRelay = PublishRelay<Void>()
    private let emailRelay = BehaviorRelay<String?>(value: nil)
    private let didEndEditingEmailRelay = PublishRelay<Void>()
    private let paymentTokenRelay = PublishRelay<PKPaymentToken>()

    private lazy var correctEmail = didEndEditingEmailRelay
        .withLatestFrom(emailRelay)
        .map { [emailValidator] email -> ValidationResult in
            guard let email = email, email.isEmpty == false else {
                return .unknown
            }
            return emailValidator.validate(email)
        }

    private lazy var emptyEmail = didTapPayRelay
        .withLatestFrom(emailRelay)
        .validate(with: emailValidator)

    private lazy var requestMapper = { [locale] (inputData: ApplePayInputData) -> ApplePayRequestData? in
        guard let merchantIdentifier = inputData.paymentInputData.applePayMerchantIdentifier else {
            assertionFailure("Missing Apple Pay merchant identifier")
            return nil
        }
        guard let countryCode = locale.regionCode else {
            assertionFailure("Failed to get current region code")
            return nil
        }
        return ApplePayRequestData(
            invoice: inputData.parameters.invoice,
            paymentSystems: Array(inputData.parameters.paymentSystems),
            merchantIdentifier: merchantIdentifier,
            countryCode: countryCode
        )
    }

    private lazy var paymentToolWithEmail = Observable
        .combineLatest(
            emailRelay,
            paymentTokenRelay,
            inputDataObservable.compactMap { $0.paymentInputData.applePayMerchantIdentifier }
        )
        .flatMap { email, token, merchantIdentifier -> Observable<(PaymentToolSourceDTO, String)> in
            guard let email = email else {
                return .empty()
            }

            let applePay = PaymentToolSourceDTO.TokenizedCardData.ApplePay(
                merchantIdentifier: merchantIdentifier,
                paymentData: token.paymentData,
                paymentMethodDisplayName: token.paymentMethod.displayName,
                paymentMethodNetwork: token.paymentMethod.network?.rawValue,
                paymentMethodType: token.paymentMethod.type.asString(),
                transactionIdentifier: token.transactionIdentifier
            )
            return .just((.tokenizedCardData(.applePay(applePay)), email))
        }

    private lazy var createPaymentResource = { [remoteAPI, activityTracker]
                                               (paymentTool: PaymentToolSourceDTO, data: ApplePayInputData) -> Observable<PaymentResourceDTO> in

        let resource = remoteAPI.createPaymentResource(
            paymentTool: paymentTool,
            invoiceAccessToken: data.paymentInputData.invoiceAccessToken
        )
        return resource.trackActivity(activityTracker)
    }

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private let activityTracker = ActivityTracker()
}

private extension PKPaymentMethodType {

    func asString() -> String {
        switch self {
        case .unknown:
            return "unknown"
        case .debit:
            return "debit"
        case .credit:
            return "credit"
        case .prepaid:
            return "prepaid"
        case .store:
            return "store"
        @unknown default:
            assertionFailure("Unsupported payment method type")
            return "unknown"
        }
    }
}
