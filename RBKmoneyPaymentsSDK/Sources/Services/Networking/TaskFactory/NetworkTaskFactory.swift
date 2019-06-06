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

final class NetworkTaskFactory {

    // MARK: - Dependencies
    lazy var baseURL: URL = deferred()
    lazy var requestIdentifierGenerator: NetworkTaskFactoryRequestIdentifierGenerator = deferred()
    lazy var sessionHTTPHeadersProvider: NetworkTaskFactorySessionHTTPHeadersProvider = deferred()

    // MARK: - Deinit
    deinit {
        session.invalidateAndCancel()
    }

    // MARK: - Internal
    func task(for networkRequest: NetworkRequest) throws -> NetworkTask {
        let request = try urlRequest(for: networkRequest)
        let task = Task()

        let dataTask = session.dataTask(with: request) {
            task.handleTaskCompletion(data: $0, response: $1, error: $2)
        }

        task.dataTask = dataTask

        return task
    }

    // MARK: - Private
    private func urlRequest(for networkRequest: NetworkRequest) throws -> URLRequest {
        var request = URLRequest(url: url(for: networkRequest))

        request.httpMethod = networkRequest.httpMethod.rawValue.uppercased()

        networkRequest.httpHeaders.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        if let parameters = networkRequest.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)

                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError(.cannotEncodeRequest, underlyingError: error)
            }
        }

        request.setValue(requestIdentifierGenerator.generateIdentifier(), forHTTPHeaderField: "X-Request-ID")

        if let authorizationToken = networkRequest.authorizationToken {
            request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func url(for networkRequest: NetworkRequest) -> URL {
        switch networkRequest.path {
        case let .absolute(string):
            guard let url = URL(string: string) else {
                fatalError("Unable to get url from absolute path: \(string)")
            }
            return url
        case let .relative(string):
            return baseURL.appendingPathComponent(string)
        }
    }

    private lazy var session = URLSession(
        configuration: with(URLSessionConfiguration.default) {
            $0.httpAdditionalHeaders = sessionHTTPHeadersProvider.headers
        }
    )
}

private class Task: NetworkTask {

    typealias Validation = (URLResponse?) -> Error?

    var dataTask: URLSessionDataTask?
    var responseCompletionQueue: DispatchQueue?
    var responseCompletionHandler: NetworkTaskCompletion?
    var validation: Validation?

    // MARK: - Internal
    func handleTaskCompletion(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            completeTask(data: data, error: error)
        } else if let error = validation?(response) {
            completeTask(data: data, error: error)
        } else {
            completeTask(data: data, error: nil)
        }
    }

    func completeTask(data: Data?, error: Error?) {
        guard let queue = responseCompletionQueue, let handler = responseCompletionHandler else {
            return
        }
        queue.async {
            handler(data, error)
        }
    }

    // MARK: - NetworkTask
    func resume() {
        dataTask?.resume()
    }

    func cancel() {
        dataTask?.cancel()
    }

    func response(queue: DispatchQueue, completionHandler: @escaping NetworkTaskCompletion) -> Self {
        responseCompletionQueue = queue
        responseCompletionHandler = completionHandler

        return self
    }

    func validate() -> Self {
        validation = { response in
            guard let httpResponse = response as? HTTPURLResponse else {
                return NetworkError(.wrongResponseType)
            }
            guard (200 ..< 300).contains(httpResponse.statusCode) else {
                return NetworkError(.unacceptableResponseStatusCode(httpResponse.statusCode))
            }
            return nil
        }

        return self
    }
}
