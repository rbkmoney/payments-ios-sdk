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

struct NetworkError: Error {

    enum Code {
        case cannotEncodeRequestBody
        case cannotMapResponse
        case serverError(ServerErrorDTO)
        case unacceptableResponseStatusCode(Int)
        case wrongResponseType
    }

    let code: Code
    let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}

extension NetworkError {

    var isServerError: Bool {
        switch code {
        case .serverError:
            return true
        default:
            return false
        }
    }
}
