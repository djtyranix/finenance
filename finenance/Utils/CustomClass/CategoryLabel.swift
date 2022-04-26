//
//  CategoryLabel.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

@IBDesignable class CategoryLabel: UIView {
    var borderWidth: CGFloat = 1
    var borderColor = UIColor.systemGray
    
    override func layoutSubviews() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
