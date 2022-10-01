//
//  FilledButton.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit

class FilledButton: UIButton {
    
    let cornerRadius: CGFloat = 10
    let edgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
    let titleColor: UIColor = .white
    let bgColor: UIColor = UIColor(named: "MainBlue") ?? .black

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = cornerRadius
        contentEdgeInsets = edgeInsets
        setTitleColor(titleColor, for: .normal)
        layer.backgroundColor = bgColor.cgColor
        titleLabel?.font = .systemFont(ofSize: 16)
    }
}
