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

enum NetworkRequestHTTPMethod: String {

    case get
    case post
    case put
    case patch
    case delete
}

enum NetworkRequestPath {

    case absolute(String)
    case relative(String)
}

protocol NetworkRequest {

    var httpMethod: NetworkRequestHTTPMethod { get }

    var path: NetworkRequestPath { get }

    // Request-specific headers
    var httpHeaders: [String: String] { get }

    var parameters: [String: Any]? { get }

    var authorizationToken: String? { get }
}

extension NetworkRequest {

    var httpHeaders: [String: String] {
        return [:]
    }
}
