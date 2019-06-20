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

final class InvoiceSummaryView: UIView {

    // MARK: - Types
    struct Model {
        let cost: String
        let details: String
    }

    // MARK: - Outlets
    @IBOutlet private var costLabel: UILabel!
    @IBOutlet private var detailsHeadingLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Internal
    func setup(with model: Model) {
        costLabel.attributedText = model.cost.attributed(with: .cost)
        detailsLabel.attributedText = model.details.attributed(with: .details)
    }

    // MARK: - Private
    private func initialize() {
        guard let view = R.nib.invoiceSummaryView(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.invoiceSummaryView)")
        }
        embedSubview(view)
        containerView = view

        detailsHeadingLabel.attributedText = R.string.localizable.order_details().attributed(with: .detailsHeading)
    }

    private lazy var containerView: UIView = deferred()
}

private extension TextAttributes {

    static let cost = TextAttributes()
        .font(.systemFont(ofSize: 30, weight: .medium))
        .textColor(Palette.colors.brightText)
        .lineBreakMode(.byTruncatingTail)
        .textAlignment(.left)

    static let detailsHeading = TextAttributes()
        .font(.systemFont(ofSize: 11, weight: .black))
        .textColor(Palette.colors.bright65Text)
        .letterSpacing(1)
        .textAlignment(.left)

    static let details = TextAttributes()
        .font(.systemFont(ofSize: 16, weight: .medium))
        .textColor(Palette.colors.brightText)
        .lineBreakMode(.byTruncatingTail)
        .textAlignment(.left)
}

extension InvoiceSummaryView {

    static func size(with model: Model, width: CGFloat) -> CGSize {
        sizingView.setup(with: model)

        return sizingView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    private static let sizingView = InvoiceSummaryView()
}
