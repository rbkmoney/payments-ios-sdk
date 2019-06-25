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

enum BrowserRequestDTO {

    typealias URITemplate = String

    struct FormData {
        struct Item: Codable {
            let key: String
            let template: URITemplate
        }

        let uriTemplate: URITemplate
        let items: [Item]
    }

    case get(URITemplate)
    case post(FormData)
}

extension BrowserRequestDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(RequestType.self, forKey: .type)

        switch type {
        case .get:
            let template = try container.decode(URITemplate.self, forKey: .uriTemplate)
            self = .get(template)
        case .post:
            let data = FormData(
                uriTemplate: try container.decode(URITemplate.self, forKey: .uriTemplate),
                items: try container.decode([FormData.Item].self, forKey: .form)
            )
            self = .post(data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .get(template):
            try container.encode(RequestType.get, forKey: .type)
            try container.encode(template, forKey: .uriTemplate)
        case let .post(data):
            try container.encode(RequestType.post, forKey: .type)
            try container.encode(data.uriTemplate, forKey: .uriTemplate)
            try container.encode(data.items, forKey: .form)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "requestType"
        case uriTemplate
        case form
    }

    private enum RequestType: String, Codable {
        case get = "BrowserGetRequest"
        case post = "BrowserPostRequest"
    }
}
