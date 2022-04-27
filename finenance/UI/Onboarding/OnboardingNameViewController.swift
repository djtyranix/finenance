//
//  OnboardingViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class OnboardingNameViewController: UIViewController, UITextFieldDelegate {
    
    var name = ""
    var fullNameArr = [String]()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitDefaultButton: UIButton!
    
    @IBAction func submitName(_ sender: UIButton) {
    }
    
    @IBAction func submitDefaultName(_ sender: UIButton) {
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        updateSubmitButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? OnboardingMonthlyIncomeViewController else {
            return
        }
        
        nameField.resignFirstResponder()
        
        if segue.identifier == "personalized" {
            name = nameField.text!
        } else {
            name = "User"
        }
        
        fullNameArr = name.components(separatedBy: " ")
        
        let firstName = fullNameArr.first!
        var lastName = ""
        
        if fullNameArr.count > 1 {
            lastName = fullNameArr.last!
        }
        
        let onboardingData = Onboarding(firstName: firstName, lastName: lastName, monthlyIncome: 0, monthlySavings: 0)
        vc.onboardingData = onboardingData
    }
    
    private func setUpViews() {
        nameField.becomeFirstResponder()
        nameField.delegate = self
        submitButton.isEnabled = false
    }
    
    private func updateSubmitButton() {
        let text = nameField.text ?? ""
        submitButton.isEnabled = !text.isEmpty
        submitDefaultButton.isEnabled = !submitButton.isEnabled
    }
}
