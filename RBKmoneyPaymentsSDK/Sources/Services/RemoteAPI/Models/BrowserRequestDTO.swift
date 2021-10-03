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

    case get(Get)
    case post(Post)
}

extension BrowserRequestDTO {

    struct Get: Codable {
        let uriTemplate: String
    }

    struct Post: Codable {

        struct FormItem: Codable {
            let key: String
            let template: String
        }

        let uriTemplate: String
        let form: [FormItem]
    }
}

extension BrowserRequestDTO: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(RequestType.self, forKey: .type)
        let singleValueContainer = try decoder.singleValueContainer()

        switch type {
        case .get:
            self = .get(try singleValueContainer.decode(Get.self))
        case .post:
            self = .post(try singleValueContainer.decode(Post.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestType, forKey: .type)

        switch self {
        case let .get(get):
            try get.encode(to: encoder)
        case let .post(post):
            try post.encode(to: encoder)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type = "requestType"
    }

    private enum RequestType: String, Codable {
        case get = "BrowserGetRequest"
        case post = "BrowserPostRequest"
    }

    private var requestType: RequestType {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
