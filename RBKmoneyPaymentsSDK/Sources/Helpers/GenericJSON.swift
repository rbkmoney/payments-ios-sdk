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

enum GenericJSON: Codable {

    struct Key: CodingKey, Hashable {
        let stringValue: String

        init(_ string: String) {
            stringValue = string
        }

        init?(stringValue: String) {
            self.init(stringValue)
        }

        init?(intValue: Int) {
            return nil
        }

        var intValue: Int? {
            return nil
        }
    }

    case string(String)
    case number(NSNumber)
    case object([Key: GenericJSON])
    case array([GenericJSON])
    case bool(Bool)
    case null

    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
        } else if let number = try? decoder.singleValueContainer().decode(Int64.self) {
            self = .number(NSNumber(value: number))
        } else if let number = try? decoder.singleValueContainer().decode(Double.self) {
            self = .number(NSNumber(value: number))
        } else if let object = try? decoder.container(keyedBy: Key.self) {
            let result = try object.allKeys.reduce(into: [:] as [Key: GenericJSON]) {
                $0[$1] = try object.decode(GenericJSON.self, forKey: $1)
            }
            self = .object(result)
        } else if var array = try? decoder.unkeyedContainer() {
            let result = try (0 ..< (array.count ?? 0)).map { _ in
                try array.decode(GenericJSON.self)
            }
            self = .array(result)
        } else if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
        } else if let isNull = try? decoder.singleValueContainer().decodeNil(), isNull {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Unknown JSON type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case let .string(string):
            try string.encode(to: encoder)
        case let .number(number):
            if let number = Int64(number.stringValue) {
                try number.encode(to: encoder)
            } else if let number = Double(number.stringValue) {
                try number.encode(to: encoder)
            } else {
                var container = encoder.singleValueContainer()
                try container.encodeNil()
            }
        case let .bool(bool):
            try bool.encode(to: encoder)
        case let .object(object):
            var container = encoder.container(keyedBy: Key.self)
            try object.forEach {
                try container.encode($0.value, forKey: $0.key)
            }
        case let .array(array):
            var container = encoder.unkeyedContainer()
            try array.forEach {
                try container.encode($0)
            }
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
