//
//  OnboardingMonthlyIncomeViewController.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class OnboardingMonthlyIncomeViewController: UIViewController, UITextFieldDelegate {
    
    var onboardingData = Onboarding(firstName: "", lastName: "", monthlyIncome: 0, monthlySavings: 0)
    
    @IBOutlet weak var monthlyIncomeField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitMonthlyIncome(_ sender: UIButton) {
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSubmitButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? OnboardingMonthlySavingsViewController else {
            return
        }
        monthlyIncomeField.resignFirstResponder()
        
        let monthlyIncome = Int(monthlyIncomeField.text!) ?? 0
        
        onboardingData.monthlyIncome = monthlyIncome
        vc.onboardingData = onboardingData
    }
    
    private func setUpViews() {
        monthlyIncomeField.becomeFirstResponder()
        monthlyIncomeField.delegate = self
        submitButton.isEnabled = false
    }
    
    private func updateSubmitButton() {
        let text = monthlyIncomeField.text ?? ""
        submitButton.isEnabled = !text.isEmpty
    }
}
