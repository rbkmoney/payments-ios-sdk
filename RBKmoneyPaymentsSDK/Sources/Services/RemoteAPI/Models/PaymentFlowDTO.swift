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

    struct HoldParameters {
        enum ExpirationAction: String, Codable {
            case cancel
            case capture
        }

        let expirationAction: ExpirationAction
        let heldUntil: Date?
    }

    case instant
    case hold(HoldParameters)
}

extension PaymentFlowDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(FlowType.self, forKey: .type)

        switch type {
        case .instant:
            self = .instant
        case .hold:
            let parameters = HoldParameters(
                expirationAction: try container.decode(HoldParameters.ExpirationAction.self, forKey: .expirationAction),
                heldUntil: try container.decodeIfPresent(Date.self, forKey: .heldUntil)
            )
            self = .hold(parameters)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .instant:
            try container.encode(FlowType.instant, forKey: .type)
        case let .hold(parameters):
            try container.encode(FlowType.hold, forKey: .type)
            try container.encode(parameters.expirationAction, forKey: .expirationAction)
            try container.encodeIfPresent(parameters.heldUntil, forKey: .heldUntil)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case expirationAction = "onHoldExpiration"
        case heldUntil
    }

    private enum FlowType: String, Codable {
        case instant = "PaymentFlowInstant"
        case hold = "PaymentFlowHold"
    }
}
