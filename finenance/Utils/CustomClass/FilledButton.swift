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
    
    private var disabledBackgroundColor: UIColor?
    private var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = cornerRadius
        contentEdgeInsets = edgeInsets
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        disabledBackgroundColor = .darkGray.withAlphaComponent(0.4)
        defaultBackgroundColor = bgColor
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
            }
            else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
}
