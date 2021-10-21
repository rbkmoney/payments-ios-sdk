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

final class ApplePayInfo {

    // MARK: - Internal
    func paymentNetworks(from paymentSystems: [PaymentSystem]) -> [PKPaymentNetwork] {
        let available = PKPaymentRequest.availableNetworks()
        let mapped = paymentSystems.compactMap { $0.paymentNetwork }
        return Array(Set(available).intersection(mapped))
    }

    var capabilities: PKMerchantCapability {
        return .capability3DS
    }

    func applePayAvailability(for paymentSystems: [PaymentSystem]) -> ApplePayAvailability {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            return .unavailable
        }

        let canMakePayments = PKPaymentAuthorizationViewController.canMakePayments(
            usingNetworks: paymentNetworks(from: paymentSystems),
            capabilities: capabilities
        )

        return canMakePayments ? .available : .cardSetupRequired
    }
}

private extension PaymentSystem {

    var paymentNetwork: PKPaymentNetwork? {
        switch self {
        case .visa:
            return .visa
        case .mastercard:
            return .masterCard
        case .visaelectron:
            return nil
        case .maestro:
            if #available(iOS 12.0, *) {
                return .maestro
            } else {
                return nil
            }
        case .forbrugsforeningen:
            return nil
        case .dankort:
            return nil
        case .amex:
            return .amex
        case .dinersclub:
            return nil
        case .discover:
            return .discover
        case .unionpay:
            return .chinaUnionPay
        case .jcb:
            return .JCB
        case .nspkmir:
            return nil
        case .elo:
            if #available(iOS 12.1.1, *) {
                return .elo
            } else {
                return nil
            }
        case .rupay:
            return nil
        case .dummy:
            return nil
        case .uzcard:
            return nil
        case .unknown:
            return nil
        }
    }
}
