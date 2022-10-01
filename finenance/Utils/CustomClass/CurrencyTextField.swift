//
//  CurrencyTextField.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit

class CurrencyTextField: UITextField {
    
    private var enteredNumbers = ""
    private var didBackspace = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    func setEnteredNumber(number: Int = 0) {
        enteredNumbers = String(number)
    }
    
    override func deleteBackward() {
        if enteredNumbers != "" {
            if self.text != nil && self.text != "", let currentNumber = self.text?.fromCurrency() {
                if enteredNumbers != String(currentNumber) {
                    enteredNumbers = String(currentNumber)
                }
            }
            enteredNumbers = String(enteredNumbers.dropLast())
            // Call super so that the .editingChanged event gets fired, but we need to handle it differently, so we set the `didBackspace` flag first
            didBackspace = true
            super.deleteBackward()
        }
    }
    
    @objc func editingChanged() {
        defer {
            didBackspace = false
            text = Int(enteredNumbers)?.toCurrency()
            print("Entered Number is \(enteredNumbers)")
        }
        
        guard didBackspace == false else { return }
        
        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            enteredNumbers.append(lastEnteredCharacter)
        }
    }
}
