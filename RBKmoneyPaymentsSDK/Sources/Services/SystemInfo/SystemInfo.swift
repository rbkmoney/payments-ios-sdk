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

import UIKit

final class SystemInfo {

    // MARK: - Internal
    var sdkVersion: String {
        guard let value = Bundle(for: SystemInfo.self).infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("SDK Info.plist has no 'CFBundleShortVersionString' field")
            return "Unknown"
        }
        return value
    }

    var appVersion: String {
        guard let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            assertionFailure("App Info.plist has no 'CFBundleShortVersionString' field")
            return "Unknown"
        }
        return value
    }

    var appBundleVersion: String {
        guard let value = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("App Info.plist has no 'CFBundleVersion' field")
            return "Unknown"
        }
        return value
    }

    var appBundleIdentifier: String {
        guard let value = Bundle.main.bundleIdentifier else {
            assertionFailure("Unable to get bundle identifier")
            return "Unknown"
        }
        return value
    }

    var appExecutableName: String {
        guard let value = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            assertionFailure("App Info.plist has no 'CFBundleExecutable' field")
            return "Unknown"
        }
        return value
    }

    var osName: String {
        return UIDevice.current.systemName
    }

    var osVersion: String {
        return UIDevice.current.systemVersion
    }

    var identifierForVendor: UUID {
        guard let value = UIDevice.current.identifierForVendor else {
            assertionFailure("Unable to get identifier for vendor")
            return UUID()
        }
        return value
    }

    var deviceModel: String {
        return UIDevice.current.model
    }

    var deviceScreenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    var isPhoneDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    var isPadDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
