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

final class BankCardAssembly: ViewControllerAssembly<BankCardViewController, BankCardViewModel> {

    // MARK: - Internal
    func makeViewController(router: AnyRouter<PaymentRoute>, inputData: BankCardInputData) -> BankCardViewController {
        let viewController = R.storyboard.bankCard.initial()!

        viewController.cardNumberFormatter = BankCardCardNumberFormatterAssembly.makeFormatter()
        viewController.priceFormatter = PriceFormatterAssembly.makeFormatter()
        viewController.invoiceDetailsFormatter = InvoiceDetailsFormatterAssembly.makeFormatter()

        bindViewModel(to: viewController) {
            $0.router = router
            $0.inputData = inputData
            $0.remoteAPI = RemoteAPIAssembly.makeRemoteAPI()
            $0.cardDetector = CardDetectorAssembly.makeCardDetector()
            $0.cardNumberValidator = CardNumberValidatorAssembly.makeValidator()
            $0.expirationDateValidator = ExpirationDateValidatorAssembly.makeValidator()
            $0.cvvCodeValidator = CVVCodeValidatorAssembly.makeValidator()
            $0.cardholderValidator = CardholderValidatorAssembly.makeValidator()
            $0.emailValidator = EmailValidatorAssembly.makeValidator()
            $0.errorHandlerProvider = DefaultErrorHandlerAssembly.makeErrorHandler(parentViewController: viewController)
        }

        return viewController
    }
}
