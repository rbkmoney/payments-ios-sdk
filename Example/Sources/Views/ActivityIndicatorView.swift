//
//  ActivityIndicatorView.swift
//  Example
//

import UIKit

final class ActivityIndicatorView: UIView {

    @IBOutlet private var indicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        stopAnimating()
    }

    func startAnimating() {
        indicatorView.startAnimating()
        isHidden = false
    }

    func stopAnimating() {
        indicatorView.stopAnimating()
        isHidden = true
    }
}
