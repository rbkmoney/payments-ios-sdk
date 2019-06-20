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

struct TextAttributes {

    var font: UIFont?
    var textColor: UIColor?
    var paragraphStyle: NSMutableParagraphStyle?
    var letterSpacing: CGFloat?
    var underlineColor: UIColor?
    var underlineStyle: NSUnderlineStyle?
    var strikethroughColor: UIColor?
    var strikethroughStyle: NSUnderlineStyle?
    var baselineOffset: CGFloat?

    var dictionary: [NSAttributedString.Key: Any] {
        var result: [NSAttributedString.Key: Any] = [:]

        result[.font] = font
        result[.foregroundColor] = textColor
        result[.paragraphStyle] = paragraphStyle
        result[.kern] = letterSpacing
        result[.underlineColor] = underlineColor
        result[.underlineStyle] = underlineStyle?.rawValue
        result[.strikethroughColor] = strikethroughColor
        result[.strikethroughStyle] = strikethroughStyle?.rawValue
        result[.baselineOffset] = baselineOffset ?? 0

        return result
    }

    func font(_ font: UIFont) -> TextAttributes {
        var copy = self
        copy.font = font
        return copy
    }

    func textColor(_ textColor: UIColor) -> TextAttributes {
        var copy = self
        copy.textColor = textColor
        return copy
    }

    func lineHeight(_ lineHeight: CGFloat) -> TextAttributes {
        var copy = self

        if copy.paragraphStyle == nil {
            copy.paragraphStyle = NSMutableParagraphStyle()
        }

        if let spacingIncrease = copy.font.map({ lineHeight - $0.lineHeight }), spacingIncrease > 0 {
            copy.paragraphStyle?.paragraphSpacingBefore = spacingIncrease / 2
            copy.paragraphStyle?.lineSpacing = spacingIncrease
            copy.paragraphStyle?.paragraphSpacing = spacingIncrease / 2
        } else {
            copy.paragraphStyle?.minimumLineHeight = lineHeight
            copy.paragraphStyle?.maximumLineHeight = lineHeight
        }

        return copy
    }

    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> TextAttributes {
        var copy = self

        if copy.paragraphStyle == nil {
            copy.paragraphStyle = NSMutableParagraphStyle()
        }

        copy.paragraphStyle?.lineBreakMode = lineBreakMode

        return copy
    }

    func textAlignment(_ textAlignment: NSTextAlignment) -> TextAttributes {
        var copy = self

        if copy.paragraphStyle == nil {
            copy.paragraphStyle = NSMutableParagraphStyle()
        }

        copy.paragraphStyle?.alignment = textAlignment

        return copy
    }

    func letterSpacing(_ letterSpacing: CGFloat) -> TextAttributes {
        var copy = self
        copy.letterSpacing = letterSpacing
        return copy
    }

    func underlineColor(_ underlineColor: UIColor) -> TextAttributes {
        var copy = self
        copy.underlineColor = underlineColor
        return copy
    }

    func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> TextAttributes {
        var copy = self
        copy.underlineStyle = underlineStyle
        return copy
    }

    func strikethroughColor(_ strikethroughColor: UIColor) -> TextAttributes {
        var copy = self
        copy.strikethroughColor = strikethroughColor
        return copy
    }

    func strikethroughStyle(_ strikethroughStyle: NSUnderlineStyle) -> TextAttributes {
        var copy = self
        copy.strikethroughStyle = strikethroughStyle
        return copy
    }

    func baselineOffset(_ baselineOffset: CGFloat) -> TextAttributes {
        var copy = self
        copy.baselineOffset = baselineOffset
        return copy
    }
}

extension String {

    func attributed(with attributes: TextAttributes) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes.dictionary)
    }
}
