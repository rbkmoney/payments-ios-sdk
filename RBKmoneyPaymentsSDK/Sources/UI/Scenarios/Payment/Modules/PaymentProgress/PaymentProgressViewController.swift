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
import WebKit

// ⚠️⚠️⚠️
// WKWebView has a bug with POST requests, it completely ignores http body.
// This bug was fixed in iOS11. Use UIWebView instead if pre-iOS11 deployment
// target required.
// ⚠️⚠️⚠️

@available(iOS 11.0, *)
final class PaymentProgressViewController: UIViewController, ModuleView {

    // MARK: - Dependencies
    lazy var urlRequestFactory: PaymentProgress3DSURLRequestFactory = deferred()

    // MARK: - Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var throbberView: ThrobberView!
    @IBOutlet private var cancelBarButtonItem: UIBarButtonItem!

    // MARK: - ModuleView
    var output: PaymentProgressViewModel.Input {
        return PaymentProgressViewModel.Input(
            didTapCancel: cancelBarButtonItem.rx.tap.asSignal(),
            userInteractionFinished: userInteractionFinishedRelay.asSignal(),
            userInteractionFailed: userInteractionFailedRelay.asSignal()
        )
    }

    func setupBindings(to viewModel: PaymentProgressViewModel) -> Disposable {
        return Disposables.create(
            Observable
                .combineLatest([
                    viewModel.isLoading.asObservable(),
                    webView.rx.observe(Bool.self, #keyPath(WKWebView.isLoading)).compactMap { $0 }
                ])
                .map { $0.contains(true) }
                .bind(to: throbberView.rx.isAnimating),
            viewModel.shopName
                .drive(navigationItem.rx.title),
            viewModel.startUserInteraction
                .emit(to: startUserInteraction)
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

        webView.backgroundColor = Palette.colors.formBackground
        webView.layer.cornerRadius = 6
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self

        setWebViewHidden(true, animated: false)
    }

    private func setWebViewHidden(_ hidden: Bool, animated: Bool) {
        let animations = { () -> Void in
            self.webView.alpha = hidden ? 0 : 1
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: animations)
        } else {
            animations()
        }
    }

    private var startUserInteraction: Binder<UserInteractionDTO> {
        return Binder(self) { this, userInteraction in
            switch userInteraction {
            case .paymentTerminalReceipt, .cryptoCurrencyTransferRequest, .qrCodeDisplayRequest:
                assertionFailure("Unsupported user interaction requested.")
            case let .redirect(redirect):
                guard let urlRequest = this.urlRequestFactory.urlRequest(for: redirect.request) else {
                    assertionFailure("Unable to create URLRequest for BrowserRequestDTO \(redirect.request)")
                    return
                }

                this.webView.load(urlRequest)
                this.setWebViewHidden(false, animated: true)
            }
        }
    }

    private let userInteractionFinishedRelay = PublishRelay<Void>()
    private let userInteractionFailedRelay = PublishRelay<Error>()
}

@available(iOS 11.0, *)
extension PaymentProgressViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url

        guard url?.absoluteString == urlRequestFactory.terminationURLString else {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)

        setWebViewHidden(true, animated: true)

        userInteractionFinishedRelay.accept(())
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        userInteractionFailedRelay.accept(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        userInteractionFailedRelay.accept(error)
    }
}
