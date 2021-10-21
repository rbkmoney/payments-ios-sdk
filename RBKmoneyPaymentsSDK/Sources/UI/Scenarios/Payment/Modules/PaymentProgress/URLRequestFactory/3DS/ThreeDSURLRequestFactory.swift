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

final class ThreeDSURLRequestFactory {

    // MARK: - Dependencies
    lazy var terminationURL: URL = deferred()

    // MARK: - Internal
    func urlRequest(for browserRequest: BrowserRequestDTO) -> URLRequest? {
        let escapedTerminationURI = terminationURLString.escaped

        switch browserRequest {
        case let .get(data):
            let urlString = Self.substitute(terminationURI: escapedTerminationURI, in: data.uriTemplate)

            guard let url = URL(string: urlString) else {
                return nil
            }

            var urlRequest = URLRequest(url: url, timeoutInterval: 15)
            urlRequest.httpMethod = "GET"

            return urlRequest

        case let .post(data):
            let urlString = Self.substitute(terminationURI: escapedTerminationURI, in: data.uriTemplate)

            guard let url = URL(string: urlString) else {
                return nil
            }

            let parameters = data.form.map {
                ($0.key, Self.substitute(terminationURI: escapedTerminationURI, in: $0.template))
            }

            let queryString = Self.queryString(for: parameters)

            var urlRequest = URLRequest(url: url, timeoutInterval: 15)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = queryString.data(using: .utf8)
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

            return urlRequest
        }
    }

    var terminationURLString: String {
        return terminationURL.absoluteString
    }

    // MARK: - Private
    private static func substitute(terminationURI: String, in template: String) -> String {
        return template
            .replacingOccurrences(of: "{?termination_uri}", with: "?termination_uri=\(terminationURI)")
            .replacingOccurrences(of: "{&termination_uri}", with: "&termination_uri=\(terminationURI)")
            .replacingOccurrences(of: "{termination_uri}", with: "termination_uri=\(terminationURI)")
    }

    private static func queryString(for parameters: [(String, String)]) -> String {
        return parameters.map({ "\($0.0.escaped)=\($0.1.escaped)" }).joined(separator: "&")
    }
}

private extension String {

    var escaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? self
    }
}

private extension CharacterSet {

    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return allowed
    }()
}
