//
//  OnboardingMonthlySavingsViewController.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class OnboardingMonthlySavingsViewController: UIViewController, UITextFieldDelegate {

    var onboardingData = Onboarding(firstName: "", lastName: "", monthlyIncome: 0, monthlySavings: 0)
    
    @IBOutlet weak var monthlySavingsField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitMonthlySavings(_ sender: UIButton) {
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
        monthlySavingsField.resignFirstResponder()
        
        let monthlySavings = Int(monthlySavingsField.text!) ?? 0
        onboardingData.monthlySavings = monthlySavings
        
        UserDefaults.standard.set(onboardingData.firstName, forKey: "userFirstName")
        UserDefaults.standard.set(onboardingData.lastName, forKey: "userLastName")
        UserDefaults.standard.set(onboardingData.monthlyIncome, forKey: "monthlyIncome")
        UserDefaults.standard.set(onboardingData.monthlySavings, forKey: "monthlySavings")
        UserDefaults.standard.set(true, forKey: "isOnboardingFinished")
        print("Data has been saved.")
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
