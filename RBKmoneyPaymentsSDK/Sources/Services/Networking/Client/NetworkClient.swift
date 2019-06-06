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

final class NetworkClient {

    // MARK: - Dependencies
    lazy var taskFactory: NetworkClientTaskFactory = deferred()
    lazy var responseMapper: NetworkClientResponseMapper = deferred()

    // MARK: - Internal
    func performRequest<ResponseType: NetworkResponse>(_ request: NetworkRequest) -> Single<ResponseType> {
        return taskResult(for: request).subscribeOn(scheduler)
    }

    // MARK: - Private
    private func taskResult<ResponseType: NetworkResponse>(for request: NetworkRequest) -> Single<ResponseType> {
        return Single<ResponseType>.create { singleEvent in
            do {
                let task = try self.taskFactory.task(for: request).validate().response(queue: self.responseQueue) { data, error in
                    let mapperInput = NetworkResponseMapperInput(data: data, error: error)
                    let mappedResponse: NetworkResponseMapperOutput<ResponseType> = self.responseMapper.map(input: mapperInput)

                    switch mappedResponse {
                    case let .error(responseError):
                        singleEvent(.error(responseError))
                    case let .success(responseValue):
                        singleEvent(.success(responseValue))
                    }
                }

                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch {
                singleEvent(.error(error))

                return Disposables.create()
            }
        }
    }

    private let scheduler = SerialDispatchQueueScheduler(qos: .background)
    private let responseQueue = DispatchQueue(label: "network.client.response.queue", qos: .background, attributes: .concurrent)
}

extension NetworkClient: NetworkRequestPerformer {
}
