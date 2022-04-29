//
//  BorderCardView.swift
//  finenance
//
//  Created by Michael Ricky on 29/04/22.
//

import UIKit

@IBDesignable class BorderCardView: UIView {

    var cornerRadius: CGFloat = 16
    var borderSize: CGFloat = 1
    var borderColor: UIColor = .systemGray3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderSize
        layer.borderColor = borderColor.cgColor
    }
}
