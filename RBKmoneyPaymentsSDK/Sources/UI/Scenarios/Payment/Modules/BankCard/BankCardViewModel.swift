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

final class BankCardViewModel: ModuleViewModel {

    // MARK: - Dependencies
    lazy var router: AnyRouter<PaymentRoute> = deferred()
    lazy var inputData: BankCardInputData = deferred()
    lazy var remoteAPI: BankCardRemoteAPI = deferred()
    lazy var cardDetector: BankCardCardDetector = deferred()
    lazy var cardNumberValidator: Validator = deferred()
    lazy var expirationDateValidator: Validator = deferred()
    lazy var cvvCodeValidator: Validator = deferred()
    lazy var cardholderValidator: Validator = deferred()
    lazy var emailValidator: Validator = deferred()

    // MARK: - ModuleViewModel
    struct Input {
        let cardNumber: Driver<String?>
        let expirationDate: Driver<String?>
        let cvvCode: Driver<String?>
        let cardholder: Driver<String?>
        let email: Driver<String?>
        let didTapPay: Signal<Void>
        let didEndEditingCardNumber: Signal<Void>
        let didEndEditingCVV: Signal<Void>
        let didEndEditingExpirationDate: Signal<Void>
        let didEndEditingCardholder: Signal<Void>
        let didEndEditingEmail: Signal<Void>
        let didTapCancel: Signal<Void>
    }

    // swiftlint:disable:next function_body_length
    func setup(with input: Input) -> Disposable {
        let disposable = CompositeDisposable()

        input.didTapPay
            .emit(to: didTapPayRelay)
            .disposed(with: disposable)

        input.cardholder
            .drive(cardholderRelay)
            .disposed(with: disposable)

        input.cardNumber
            .map { $0?.filter("0123456789".contains) }
            .drive(cardNumberRelay)
            .disposed(with: disposable)

        input.cvvCode
            .map { $0?.filter("0123456789".contains) }
            .drive(cvvCodeRelay)
            .disposed(with: disposable)

        input.expirationDate
            .drive(expirationDateRelay)
            .disposed(with: disposable)

        input.email
            .drive(emailRelay)
            .disposed(with: disposable)

        input.didEndEditingCVV
            .emit(to: didEndEditingCVVRelay)
            .disposed(with: disposable)

        input.didEndEditingCardNumber
            .emit(to: didEndEditingCardNumberRelay)
            .disposed(with: disposable)

        input.didEndEditingExpirationDate
            .emit(to: didEndEditingExpirationDateRelay)
            .disposed(with: disposable)

        input.didEndEditingCardholder
            .emit(to: didEndEditingCardholderRelay)
            .disposed(with: disposable)

        input.didEndEditingEmail
            .emit(to: didEndEditingEmailRelay)
            .disposed(with: disposable)

        let continueRoute = paymentToolWithEmail
            .withLatestFrom(inputDataObservable) { ($0, $1) }
            .flatMap { [createPaymentResource] tuple -> Observable<PaymentRoute> in
                let ((paymentTool, email), data) = tuple
                return createPaymentResource(paymentTool, data).map { PaymentRoute.progress($0, email) }
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
        .map { $0.invoice }
        .asDriver(onError: .never)

    private(set) lazy var shopName = inputDataObservable
        .map { $0.paymentInputData.shopName }
        .asDriver(onError: .never)

    private(set) lazy var formattedCVV = cvvCodeRelay
        .asDriver()
        .map { code -> String? in
            guard let cvv = code, cvv.count > 3 else {
                return code
            }
            return String(cvv.prefix(3))
        }

    private(set) lazy var cardPaymentSystem = cardDescription
        .map { $0.paymentSystem }
        .asDriver(onError: .never)

    private(set) lazy var cardNumberFieldMaxLength = cardDescription
        .map { $0.lengths.max() }
        .asDriver(onError: .never)

    private(set) lazy var validateCardNumber: Driver<ValidationResult> = Observable
        .merge(emptyCardNumber, correctCardNumber, emptyCardNumberLength, supportedCardValidation)
        .asDriver(onError: .never)

    private(set) lazy var validateCVV: Driver<ValidationResult> = Observable
        .merge(emptyCVV, correctCVV)
        .asDriver(onError: .never)

    private(set) lazy var validateDate: Driver<ValidationResult> = Observable
        .merge(emptyDate, correctDate)
        .asDriver(onError: .never)

    private(set) lazy var validateCardholder: Driver<ValidationResult> = Observable
        .merge(emptyCardholder, correctCardholder)
        .asDriver(onError: .never)

    private(set) lazy var validateEmail: Driver<ValidationResult> = Observable
        .merge(emptyEmail, correctEmail)
        .asDriver(onError: .never)

    // MARK: - Private
    private let cardNumberRelay = BehaviorRelay<String?>(value: nil)
    private let expirationDateRelay = BehaviorRelay<String?>(value: nil)
    private let cvvCodeRelay = BehaviorRelay<String?>(value: nil)
    private let cardholderRelay = BehaviorRelay<String?>(value: nil)
    private let emailRelay = BehaviorRelay<String?>(value: nil)

    private let didEndEditingCardNumberRelay = PublishRelay<Void>()
    private let didEndEditingCVVRelay = PublishRelay<Void>()
    private let didEndEditingExpirationDateRelay = PublishRelay<Void>()
    private let didEndEditingCardholderRelay = PublishRelay<Void>()
    private let didEndEditingEmailRelay = PublishRelay<Void>()

    private let didTapPayRelay = PublishRelay<Void>()

    private lazy var cardDescription = cardNumberRelay
        .flatMap { [weak self] number -> Observable<CardDescription> in
            guard let this = self, let number = number, number.isEmpty == false else {
                return .empty()
            }
            return this.cardDetector.detectCard(from: number).asObservable()
        }

    private lazy var emptyCardNumberLength = didTapPayRelay
        .withLatestFrom(Observable.combineLatest(cardNumberRelay, cardDescription))
        .map { cardNumber, cardDescription -> ValidationResult  in
            guard let cardNumber = cardNumber, cardNumber.isEmpty == false else {
                return .invalid
            }
            return cardDescription.lengths.contains(cardNumber.count) ? .valid : .invalid
        }

    private lazy var supportedCardValidation: Observable<ValidationResult> = Observable
        .combineLatest(inputDataObservable, cardDescription)
        .map { $0.0.paymentSystems.contains($0.1.paymentSystem) ? .valid : .invalid }

    private lazy var emptyCardNumber = didTapPayRelay
        .withLatestFrom(cardNumberRelay)
        .validate(with: cardNumberValidator)

    private lazy var emptyCVV = didTapPayRelay
        .withLatestFrom(cvvCodeRelay)
        .validate(with: cvvCodeValidator)

    private lazy var emptyDate = didTapPayRelay
        .withLatestFrom(expirationDateRelay)
        .validate(with: expirationDateValidator)

    private lazy var emptyCardholder = didTapPayRelay
        .withLatestFrom(cardholderRelay)
        .validate(with: cardholderValidator)

    private lazy var emptyEmail = didTapPayRelay
        .withLatestFrom(emailRelay)
        .validate(with: emailValidator)

    private lazy var correctCardNumber = didEndEditingCardNumberRelay
        .withLatestFrom(cardNumberRelay)
        .filter { $0?.isEmpty == false }
        .validate(with: cardNumberValidator)
        .withLatestFrom(correctCardNumberLength) { ($0, $1) }
        .map { tuple -> ValidationResult in
            if tuple.0 == .valid {
                return tuple.1
            } else {
                return tuple.0
            }
        }

    private lazy var correctCardNumberLength = didEndEditingCardNumberRelay
        .withLatestFrom(Observable.combineLatest(cardNumberRelay, cardDescription))
        .map { cardNumber, cardDescription -> ValidationResult  in
            guard let cardNumber = cardNumber, cardNumber.isEmpty == false else {
                return .unknown
            }
            return cardDescription.lengths.contains(cardNumber.count) ? .valid : .invalid
        }

    private lazy var correctCVV = didEndEditingCVVRelay
        .withLatestFrom(cvvCodeRelay)
        .filter { $0?.isEmpty == false }
        .validate(with: cvvCodeValidator)

    private lazy var correctDate = didEndEditingExpirationDateRelay
        .withLatestFrom(expirationDateRelay)
        .filter { $0?.isEmpty == false }
        .validate(with: expirationDateValidator)

    private lazy var correctCardholder = didEndEditingCardholderRelay
        .withLatestFrom(cardholderRelay)
        .filter { $0?.isEmpty == false }
        .validate(with: cardholderValidator)

    private lazy var correctEmail = didEndEditingEmailRelay
        .withLatestFrom(emailRelay)
        .filter { $0?.isEmpty == false }
        .validate(with: emailValidator)

    private lazy var inputDataObservable = Observable
        .deferred { [weak self] in .just(self?.inputData) }
        .compactMap { $0 }

    private lazy var paymentToolWithEmail = didTapPayRelay
        .withLatestFrom(Driver.combineLatest([validateCardNumber, validateCVV, validateDate, validateCardholder, validateEmail]))
        .filter { $0.allSatisfy { $0 == .valid } }
        .withLatestFrom(Observable.combineLatest(cardNumberRelay, expirationDateRelay, cvvCodeRelay, cardholderRelay, emailRelay))
        .flatMap { tuple -> Observable<(PaymentToolSourceDTO, String)> in
            guard let number = tuple.0, let expiration = tuple.1, let cvv = tuple.2, let cardHolder = tuple.3, let email = tuple.4 else {
                return .empty()
            }

            let cardData = PaymentToolSourceDTO.CardData(number: number, expiration: expiration, cvv: cvv, cardHolder: cardHolder)
            return .just((.cardData(cardData), email))
        }

    private lazy var createPaymentResource = { [remoteAPI, activityTracker]
                                               (paymentTool: PaymentToolSourceDTO, data: BankCardInputData) -> Observable<PaymentResourceDTO> in

        let resource = remoteAPI.createPaymentResource(
            paymentTool: paymentTool,
            invoiceAccessToken: data.paymentInputData.invoiceAccessToken
        )
        return resource.trackActivity(activityTracker)
    }

    private let activityTracker = ActivityTracker()
}
