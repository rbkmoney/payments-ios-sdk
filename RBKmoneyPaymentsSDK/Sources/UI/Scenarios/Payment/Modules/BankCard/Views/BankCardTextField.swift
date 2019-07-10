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

import RxCocoa
import RxSwift
import UIKit

final class BankCardTextField: UITextField {

    // MARK: - Types
    enum CustomBorderStyle {
        case focused
        case valid
        case invalid
        case unknown
    }

    // MARK: - Internal
    @IBInspectable var leftViewImage: UIImage? {
        didSet {
            leftView = UIImageView(image: leftViewImage)
            leftView?.tintColor = Palette.colors.darkText
        }
    }

    @IBInspectable var isPasteEnabled: Bool = true
    @IBInspectable var isCutEnabled: Bool = true
    @IBInspectable var isDeleteEnabled: Bool = true

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Overrides
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let pasteSelector = #selector(UIResponderStandardEditActions.paste(_:))
        let cutSelector = #selector(UIResponderStandardEditActions.cut(_:))
        let deleteSelector = #selector(UIResponderStandardEditActions.delete(_:))

        switch action {
        case pasteSelector where !isPasteEnabled, cutSelector where !isCutEnabled, deleteSelector where !isDeleteEnabled:
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 12
        return rect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 12
        return rect
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.y += 1
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.y += 1
        return rect
    }

    // MARK: - Private
    private func initialize() {
        layer.cornerRadius = 3
        tintColor = Palette.colors.darkText
        textColor = Palette.colors.darkText
        backgroundColor = Palette.colors.formBackground
        font = Palette.fonts.common
        leftViewMode = .always

        applyCustomBorderStyle(.unknown)
    }

    fileprivate func applyCustomBorderStyle(_ style: CustomBorderStyle) {
        switch style {
        case .focused:
            layer.borderColor = Palette.colors.main.cgColor
            layer.borderWidth = 2
            layer.shadowColor = Palette.colors.main.cgColor
            layer.shadowRadius = 2
            layer.shadowOffset = .zero
            layer.shadowOpacity = 1
            leftView?.tintColor = Palette.colors.main
            rightViewMode = .never
        case .invalid:
            layer.borderColor = Palette.colors.wrong.cgColor
            layer.borderWidth = 1
            layer.shadowOpacity = 0
            leftView?.tintColor = Palette.colors.darkText
        case .valid:
            layer.borderColor = Palette.colors.frame.cgColor
            layer.borderWidth = 1
            layer.shadowOpacity = 0
            leftView?.tintColor = Palette.colors.darkText
        case .unknown:
            layer.borderColor = Palette.colors.frame.cgColor
            layer.borderWidth = 1
            layer.shadowOpacity = 0
            leftView?.tintColor = Palette.colors.darkText
        }
    }
}

extension Reactive where Base: BankCardTextField {

    var customBorderStyle: Binder<Base.CustomBorderStyle> {
        return Binder(base) { base, style in
            base.applyCustomBorderStyle(style)
        }
    }

    var rightViewData: Binder<(UIImage?, UITextField.ViewMode)> {
        return Binder(base) { base, tuple in
            base.rightView = UIImageView(image: tuple.0)
            base.rightViewMode = tuple.1
        }
    }
}
