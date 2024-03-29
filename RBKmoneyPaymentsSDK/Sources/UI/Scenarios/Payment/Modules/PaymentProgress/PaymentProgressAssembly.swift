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

final class PaymentProgressAssembly: ViewControllerAssembly<PaymentProgressViewController, PaymentProgressViewModel> {

    // MARK: - Internal
    func makeViewController(router: AnyRouter<PaymentRoute>, inputData: PaymentProgressInputData) -> PaymentProgressViewController {
        let viewController = R.storyboard.paymentProgress.initial()!

        viewController.urlRequestFactory = ThreeDSURLRequestFactoryAssembly.makeRequestFactory(terminationURL: Self.terminationURL)

        bindViewModel(to: viewController) {
            $0.router = router
            $0.inputData = inputData
            $0.remoteAPI = RemoteAPIAssembly.makeRemoteAPI()
            $0.errorHandlerProvider = DefaultErrorHandlerAssembly.makeErrorHandler(parentViewController: viewController)
            $0.externalIdentifierGenerator = UniqueIdentifierGeneratorAssembly.makeGenerator()
            $0.redirectURL = Self.terminationURL
        }

        return viewController
    }

    private static let terminationURL = URL(string: "internal://termination.url")!
}
