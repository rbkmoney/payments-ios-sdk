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

final class PaymentMethodsTableFooterView: UIView {

    // MARK: - Outlets
    @IBOutlet private var decorationImageView: UIImageView!
    @IBOutlet private var logotypesView: LogotypesView!

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
        guard let view = R.nib.paymentMethodsTableFooterView(owner: self) else {
            fatalError("Unable to instantiate view from nib \(R.nib.paymentMethodsTableFooterView)")
        }
        embedSubview(view)
        containerView = view

        decorationImageView.tintColor = Palette.colors.formBackground
    }

    private lazy var containerView: UIView = deferred()
}
