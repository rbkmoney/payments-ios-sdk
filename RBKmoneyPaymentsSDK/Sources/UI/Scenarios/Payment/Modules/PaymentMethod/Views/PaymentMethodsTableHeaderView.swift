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

final class PaymentMethodsTableHeaderView: UIView {

    // MARK: - Types
    typealias Model = InvoiceSummaryView.Model

    // MARK: - Outlets
    @IBOutlet private var decorationImageView: UIImageView!
    @IBOutlet private var invoiceSummaryView: InvoiceSummaryView!
    @IBOutlet private var titleLabel: UILabel!

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
        invoiceSummaryView.setup(with: model)
    }

    // MARK: - Private
    private func initialize() {
        guard let view = R.nib.paymentMethodsTableHeaderView(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.paymentMethodsTableHeaderView)")
        }
        embedSubview(view)
        containerView = view

        decorationImageView.tintColor = Palette.colors.formBackground
        titleLabel.attributedText = R.string.localizable.payment_method_header_title().attributed(with: .title)
    }

    private lazy var containerView: UIView = deferred()
}

private extension TextAttributes {

    static let title = TextAttributes()
        .font(Palette.fonts.common)
        .textColor(Palette.colors.darkText)
        .textAlignment(.left)
}

extension PaymentMethodsTableHeaderView {

    static func size(with model: Model, width: CGFloat) -> CGSize {
        sizingView.setup(with: model)

        return sizingView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    private static let sizingView = PaymentMethodsTableHeaderView()
}
