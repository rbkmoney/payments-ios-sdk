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

import RxSwift

final class RemoteAPI {

    // MARK: - Dependencies
    lazy var networkClient: RemoteAPINetworkClient = deferred()
    lazy var fingerprintProvider: RemoteAPIFingerprintProvider = deferred()

    // MARK: - Internal
    func obtainInvoice(invoiceIdentifier: String, invoiceAccessToken: String) -> Single<InvoiceDTO> {
        let request = ObtainInvoiceNetworkRequest(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken)
        return networkClient.performRequest(request).payload()
    }

    func obtainInvoicePaymentMethods(invoiceIdentifier: String, invoiceAccessToken: String) -> Single<[PaymentMethodDTO]> {
        let request = ObtainInvoicePaymentMethodsNetworkRequest(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken)
        return networkClient.performRequest(request).payload()
    }

    func createPaymentResource(paymentTool: PaymentToolSourceDTO, invoiceAccessToken: String) -> Single<PaymentResourceDTO> {
        do {
            let clientInfo = ClientInfoDTO(fingerprint: fingerprintProvider.fingerprint, ipAddress: nil)
            let source = PaymentResourceSourceDTO(paymentTool: paymentTool, clientInfo: clientInfo)
            let request = try CreatePaymentResourceNetworkRequest(source: source, invoiceAccessToken: invoiceAccessToken)
            return networkClient.performRequest(request).payload()
        } catch {
            return .error(NetworkError(.cannotEncodeRequestBody, underlyingError: error))
        }
    }

    func createPayment(paymentParameters: PaymentParametersDTO, invoiceIdentifier: String, invoiceAccessToken: String) -> Single<PaymentDTO> {
        do {
            let request = try CreatePaymentNetworkRequest(
                paymentParameters: paymentParameters,
                invoiceIdentifier: invoiceIdentifier,
                invoiceAccessToken: invoiceAccessToken
            )
            return networkClient.performRequest(request).payload()
        } catch {
            return .error(NetworkError(.cannotEncodeRequestBody, underlyingError: error))
        }
    }

    func obtainInvoiceEvents(invoiceIdentifier: String, invoiceAccessToken: String) -> Single<[InvoiceEventDTO]> {
        let request = ObtainInvoiceEventsNetworkRequest(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken)
        return networkClient.performRequest(request).payload()
    }

    func obtainPayments(invoiceIdentifier: String, invoiceAccessToken: String) -> Single<[PaymentDTO]> {
        let request = ObtainPaymentsNetworkRequest(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken)
        return networkClient.performRequest(request).payload()
    }

    func obtainPayment(paymentIdentifier: String, invoiceIdentifier: String, invoiceAccessToken: String) -> Single<PaymentDTO> {
        return obtainPayments(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken).map {
            guard let element = $0.first(where: { $0.identifier == paymentIdentifier }) else {
                throw NetworkError(.elementNotFound)
            }
            return element
        }
    }

    func obtainPayment(paymentExternalIdentifier: String, invoiceIdentifier: String, invoiceAccessToken: String) -> Single<PaymentDTO> {
        return obtainPayments(invoiceIdentifier: invoiceIdentifier, invoiceAccessToken: invoiceAccessToken).map {
            guard let element = $0.first(where: { $0.externalIdentifier == paymentExternalIdentifier }) else {
                throw NetworkError(.elementNotFound)
            }
            return element
        }
    }
}
