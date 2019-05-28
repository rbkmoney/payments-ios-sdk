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

@discardableResult
func with<T>(_ object: T, do action: (T) -> Void) -> T {
    action(object)
    return object
}

func apply<T, R>(_ object: T, transform: (T) -> R) -> R {
    return transform(object)
}

func deferred<T>(file: StaticString = #file, line: UInt = #line) -> T {
    fatalError("Value isn't set before first use", file: file, line: line)
}

func abstractMethod(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Function \(String(describing: function)) must be overridden", file: file, line: line)
}

func notImplemented(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Function \(String(describing: function)) is not implemented yet", file: file, line: line)
}
