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

extension UIView {

    struct EmbedEdgeInsets {
        let top: CGFloat?
        let left: CGFloat?
        let bottom: CGFloat?
        let right: CGFloat?
    }

    func embedSubview(_ view: UIView, edgeInsets: EmbedEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)

        let constraints = [
            edgeInsets.top.map { view.topAnchor.constraint(equalTo: topAnchor, constant: $0) },
            edgeInsets.left.map { view.leftAnchor.constraint(equalTo: leftAnchor, constant: $0) },
            edgeInsets.bottom.map { view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -$0) },
            edgeInsets.right.map { view.rightAnchor.constraint(equalTo: rightAnchor, constant: -$0) }
        ]

        NSLayoutConstraint.activate(constraints.compactMap { $0 })
    }
}

extension UIView.EmbedEdgeInsets {

    init(edgeInsets: UIEdgeInsets) {
        self.top = edgeInsets.top
        self.left = edgeInsets.left
        self.bottom = edgeInsets.bottom
        self.right = edgeInsets.right
    }

    static let zero = UIView.EmbedEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
