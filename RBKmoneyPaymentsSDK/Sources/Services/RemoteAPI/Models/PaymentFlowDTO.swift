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

import Foundation

enum PaymentFlowDTO {

    case instant
    case hold(Hold)
}

extension PaymentFlowDTO {

    struct Hold: Codable {

        enum CodingKeys: String, CodingKey {
            case expirationAction = "onHoldExpiration"
            case untilDate = "heldUntil"
        }

        enum ExpirationAction: String, Codable {
            case cancel
            case capture
        }

        let expirationAction: ExpirationAction
        let untilDate: Date?

        init(expirationAction: ExpirationAction = .cancel) {
            self.expirationAction = expirationAction
            self.untilDate = nil
        }
    }
}

extension PaymentFlowDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(FlowType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .instant:
            self = .instant
        case .hold:
            self = .hold(try singleValueContainer.decode(Hold.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flowType, forKey: .type)

        switch self {
        case .instant:
            break
        case let .hold(hold):
            try hold.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    private enum FlowType: String, Codable {
        case instant = "PaymentFlowInstant"
        case hold = "PaymentFlowHold"
    }

    private var flowType: FlowType {
        switch self {
        case .instant:
            return .instant
        case .hold:
            return .hold
        }
    }
}
