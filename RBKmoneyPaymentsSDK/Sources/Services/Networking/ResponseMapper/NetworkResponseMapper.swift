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

struct NetworkResponseMapper {

    // MARK: - Internal
    func map<ResponseType: NetworkResponse>(input: NetworkResponseMapperInput) -> NetworkResponseMapperOutput<ResponseType> {
        if let error = input.error {
            if let errorResponse = ErrorNetworkResponse(rawData: input.data) {
                return .error(NetworkError(.serverError(errorResponse.payload), underlyingError: error))
            } else {
                return .error(error)
            }
        }

        guard let response = ResponseType(rawData: input.data) else {
            return .error(NetworkError(.cannotMapResponse))
        }

        return .success(response)
    }
}
