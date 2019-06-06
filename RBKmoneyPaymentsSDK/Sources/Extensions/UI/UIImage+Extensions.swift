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

extension UIImage {

    static func draw(size: CGSize, scale: CGFloat = UIScreen.main.scale, opaque: Bool = false, closure: (CGContext) -> Void) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            assertionFailure("Failed to get image context")
            return UIImage()
        }

        closure(context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure("Failed to get image from context")
            return UIImage()
        }

        return image
    }

    struct ImageFromColorOptions {
        var size: CGSize
        var resizableCapInsets: UIEdgeInsets?
    }

    static func color(_ color: UIColor, options: ImageFromColorOptions = .default) -> UIImage {
        var image = draw(size: options.size) { context in
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: options.size))
        }

        image = image.withRenderingMode(.alwaysOriginal)

        if let capInsets = options.resizableCapInsets {
            image = image.resizableImage(withCapInsets: capInsets, resizingMode: .tile)
        }

        return image
    }
}

extension UIImage.ImageFromColorOptions {

    static let `default` = UIImage.ImageFromColorOptions(
        size: CGSize(width: 1, height: 1),
        resizableCapInsets: nil
    )

    static let resizable = UIImage.ImageFromColorOptions(
        size: CGSize(width: 3, height: 3),
        resizableCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    )
}
