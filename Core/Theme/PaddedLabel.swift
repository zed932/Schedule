//
//  PaddedLabel.swift
//  Schedule
//

import UIKit

final class PaddedLabel: UILabel {

    var horizontalPadding: CGFloat = AppTheme.badgeHorizontalPadding {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + horizontalPadding * 2, height: size.height)
    }
}
