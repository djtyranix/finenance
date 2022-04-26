//
//  CardView.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

@IBDesignable class CardView: UIView {

    var cornerRadius: CGFloat = 16
    var offsetWidth: CGFloat = 0
    var offsetHeight: CGFloat = 4
    var blur: CGFloat = 10
    
    var offsetShadowOpacity: Float = 1
    var shadowColor = UIColor.init(hex: "#C9C9C9FF")
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        layer.shadowPath = nil
        layer.shadowRadius = blur / 2.0
        layer.shadowOpacity = offsetShadowOpacity
    }

}
