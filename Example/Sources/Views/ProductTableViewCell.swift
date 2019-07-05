//
//  ProductTableViewCell.swift
//  Example
//

import UIKit

final class ProductTableViewCell: UITableViewCell {

    @IBOutlet private var emojiLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var actionButton: UIButton!

    struct Model {
        let emoji: String
        let title: String?
        let description: String?
        let cost: Cost
        let buttonColor: UIColor?
    }

    var action: (() -> Void)?

    func setup(with model: Model) {
        emojiLabel.text = model.emoji
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        actionButton.backgroundColor = model.buttonColor
        actionButton.setTitle(buttonTitle(for: model.cost), for: .normal)
    }

    @IBAction private func handleActionButtonTap() {
        action?()
    }

    private func buttonTitle(for cost: Cost) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        numberFormatter.currencySymbol = cost.currency.symbol

        guard let string = numberFormatter.string(from: NSDecimalNumber(decimal: cost.amount)) else {
            return "Купить"
        }

        return "Купить за \(string)"
    }
}

private extension Currency {

    var symbol: String {
        switch self {
        case .rub:
            return "₽"
        case .usd:
            return "$"
        case .eur:
            return "€"
        }
    }
}
