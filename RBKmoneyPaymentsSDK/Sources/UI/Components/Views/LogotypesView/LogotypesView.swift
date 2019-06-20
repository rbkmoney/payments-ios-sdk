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

final class LogotypesView: UIView {

    // MARK: - Outlets
    @IBOutlet private var securePaymentLabel: UILabel!
    @IBOutlet private var copyrightLabel: UILabel!
    @IBOutlet private var lockImageView: UIImageView!
    @IBOutlet private var rbkMoneyImageView: UIImageView!
    @IBOutlet private var logotypesImageView: UIImageView!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Private
    private func initialize() {
        guard let view = R.nib.logotypesView(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.logotypesView)")
        }
        embedSubview(view)
        containerView = view

        securePaymentLabel.attributedText = R.string.localizable.securite_payment().attributed(with: .securePayment)
        copyrightLabel.attributedText = R.string.localizable.copyright().attributed(with: .copyright)

        [lockImageView as UIImageView, rbkMoneyImageView, logotypesImageView].forEach {
            $0.tintColor = Palette.colors.commonLogotypes
        }
    }

    private lazy var containerView: UIView = deferred()
}

private extension TextAttributes {

    static let securePayment = TextAttributes()
        .font(.systemFont(ofSize: 11, weight: .black))
        .textColor(Palette.colors.commonLogotypes)
        .letterSpacing(1)
        .textAlignment(.left)

    static let copyright = TextAttributes()
        .font(.systemFont(ofSize: 10, weight: .regular))
        .textColor(Palette.colors.commonLogotypes)
        .textAlignment(.left)
}
