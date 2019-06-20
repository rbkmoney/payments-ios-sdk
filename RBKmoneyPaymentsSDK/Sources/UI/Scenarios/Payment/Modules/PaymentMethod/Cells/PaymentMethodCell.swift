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

final class PaymentMethodCell: UITableViewCell {

    // MARK: - Types
    enum Style {
        case `default`
        case black
        case highlighted
    }

    struct Model {
        let icon: UIImage?
        let title: String?
        let subtitle: String?
        let style: Style
    }

    // MARK: - Outlets
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var labelsStackView: UIStackView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var formView: UIView!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        formView.backgroundColor = Palette.colors.formBackground
        containerView.borderWidth = 1
        containerView.cornerRadius = 3
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        applyStyle(highlighted ? .highlighted : style)
    }

    // MARK: - Internal
    func setup(with model: Model) {
        iconImageView.image = model.icon
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle

        let isTitleEmpty = model.title?.isEmpty ?? true
        let isSubtitleEmpty = model.subtitle?.isEmpty ?? true

        labelsStackView.isHidden = isTitleEmpty && isSubtitleEmpty
        titleLabel.isHidden = isTitleEmpty
        subtitleLabel.isHidden = isSubtitleEmpty
        iconImageView.isHidden = model.icon == nil

        style = model.style

        applyStyle(isHighlighted ? .highlighted : style)
    }

    // MARK: - Private
    private func applyStyle(_ style: Style) {
        switch style {
        case .default:
            containerView.backgroundColor = .clear
            containerView.borderColor = Palette.colors.frame
            iconImageView.tintColor = Palette.colors.main
            titleLabel.attributedText = titleLabel.text?.attributed(with: .titleDefault)
            subtitleLabel.attributedText = subtitleLabel.text?.attributed(with: .subtitleDefault)
        case .black:
            containerView.backgroundColor = .clear
            containerView.borderColor = Palette.colors.frame
            iconImageView.tintColor = .black
            titleLabel.attributedText = titleLabel.text?.attributed(with: .titleBlack)
            subtitleLabel.attributedText = subtitleLabel.text?.attributed(with: .subtitleBlack)
        case .highlighted:
            containerView.backgroundColor = Palette.colors.selectionBackground
            containerView.borderColor = Palette.colors.selectionBackground
            iconImageView.tintColor = Palette.colors.selectionForeground
            titleLabel.attributedText = titleLabel.text?.attributed(with: .titleHighlighted)
            subtitleLabel.attributedText = subtitleLabel.text?.attributed(with: .subtitleHighlighted)
        }
    }

    private var style: Style = .default
}

private extension TextAttributes {

    static let title = TextAttributes()
        .font(.systemFont(ofSize: 11, weight: .black))
        .letterSpacing(1)
        .lineHeight(20)
        .lineBreakMode(.byTruncatingTail)
        .textAlignment(.left)

    static let subtitle = TextAttributes()
        .font(UIFont.systemFont(ofSize: 11, weight: .regular).italic)
        .lineHeight(13)
        .lineBreakMode(.byTruncatingTail)
        .textAlignment(.left)

    static let titleDefault = title
        .textColor(Palette.colors.main)

    static let titleBlack = title
        .textColor(.black)

    static let titleHighlighted = title
        .textColor(Palette.colors.selectionForeground)

    static let subtitleDefault = subtitle
        .textColor(Palette.colors.subtitleText)

    static let subtitleBlack = subtitle
        .textColor(.black)

    static let subtitleHighlighted = subtitle
        .textColor(Palette.colors.selectionForeground)
}
