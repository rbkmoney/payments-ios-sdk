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

final class NetworkSessionHTTPHeaders {

    // MARK: - Dependencies
    lazy var systemInfoProvider: NetworkSessionHTTPHeadersSystemInfoProvider = deferred()

    // MARK: - Internal
    var headers: [String: String] {
        let acceptEncoding = "gzip;q=1.0, compress;q=0.5"

        let acceptLanguage = Locale.preferredLanguages
            .prefix(6)
            .enumerated()
            .map { index, languageCode in
                let quality = 1.0 - (Double(index) * 0.1)
                return "\(languageCode);q=\(quality)"
            }
            .joined(separator: ", ")

        let appNameVersion = "\(systemInfoProvider.appExecutableName)/\(systemInfoProvider.appVersion)"
        let appBundleIdentifierVersion = "(\(systemInfoProvider.appBundleIdentifier); build:\(systemInfoProvider.appBundleVersion))"
        let osNameVersion = "\(systemInfoProvider.osName)/\(systemInfoProvider.osVersion)"
        let deviceModel = "(\(systemInfoProvider.deviceModel))"
        let sdkNameVersion = "RBKmoneyPaymentsSDK/\(systemInfoProvider.sdkVersion)"

        let userAgent = [appNameVersion, appBundleIdentifierVersion, sdkNameVersion, osNameVersion, deviceModel].joined(separator: " ")

        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
    }
}
