//
//  OnboardingMonthlySavingsViewController.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class OnboardingMonthlySavingsViewController: UIViewController, UITextFieldDelegate {

    var onboardingData = Onboarding(firstName: "", fullName: "", monthlyIncome: 0, monthlySavings: 0)
    
    @IBOutlet weak var monthlySavingsField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitMonthlySavings(_ sender: UIButton) {
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSubmitButton()
    }

    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthlySavingsField.resignFirstResponder()
        
        let monthlySavings = monthlySavingsField.text?.fromCurrency() ?? 0
        onboardingData.monthlySavings = monthlySavings
        
        print("Monthly Income is: \(onboardingData.monthlyIncome)")
        print("Monthly Savings is: \(onboardingData.monthlySavings)")
        
        UserKeyStore.sharedInstance.keyStore.set(onboardingData.firstName, forKey: "userFirstName")
        UserKeyStore.sharedInstance.keyStore.set(onboardingData.fullName, forKey: "userFullName")
        UserKeyStore.sharedInstance.keyStore.set(onboardingData.monthlyIncome, forKey: "monthlyIncome")
        UserKeyStore.sharedInstance.keyStore.set(onboardingData.monthlySavings, forKey: "monthlySavings")
        UserKeyStore.sharedInstance.keyStore.set(true, forKey: "isOnboardingFinished")
        UserKeyStore.sharedInstance.keyStore.synchronize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func setUpViews() {
        monthlySavingsField.becomeFirstResponder()
        monthlySavingsField.delegate = self
        submitButton.isEnabled = false
    }
    
    private func updateSubmitButton() {
        let text = monthlySavingsField.text ?? ""
        submitButton.isEnabled = !text.isEmpty
    }

}
