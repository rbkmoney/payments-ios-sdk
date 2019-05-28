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

extension UIColor {

    convenience init(integralRed red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }

    convenience init(integralRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

    convenience init(integralWhite white: Int, alpha: CGFloat = 1) {
        self.init(white: CGFloat(white) / 255, alpha: alpha)
    }

    convenience init(integralWhite white: CGFloat, alpha: CGFloat = 1) {
        self.init(white: white / 255, alpha: alpha)
    }
}
