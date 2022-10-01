//
//  ProfileEditViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ProfileEditViewController: SecureViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        showLoading()
        let text = textField.text!
        
        switch mode {
        case 0:
            UserKeyStore.sharedInstance.keyStore.set(text.fromCurrency(), forKey: "monthlyIncome")
            UserKeyStore.sharedInstance.keyStore.synchronize()
        case 1:
            UserKeyStore.sharedInstance.keyStore.set(text.fromCurrency(), forKey: "monthlySavings")
            UserKeyStore.sharedInstance.keyStore.synchronize()
        case 2:
            let fullNameArr = text.components(separatedBy: " ")
            let firstName = fullNameArr.first!
            UserKeyStore.sharedInstance.keyStore.set(firstName, forKey: "userFirstName")
            UserKeyStore.sharedInstance.keyStore.set(text, forKey: "userFullName")
            UserKeyStore.sharedInstance.keyStore.synchronize()
        default:
            navigationItem.title = ""
        }
        
        showSuccessAlert()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    var mode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarStyle()
        checkMode()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func showLoading() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.tag = 69
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    private func dismissLoading() {
        guard let viewWithTag = self.view.viewWithTag(69) else {
            return
        }
        
        viewWithTag.removeFromSuperview()
    }
    
    private func checkMode() {
        switch mode {
        case 0:
            navigationItem.title = "Set Monthly Income"
            textField.placeholder = "Your Monthly Income"
            textField.text = (UserKeyStore.sharedInstance.keyStore.object(forKey: "monthlyIncome") as? Int ?? 0).toCurrency()
            textField.keyboardType = .numberPad
        case 1:
            navigationItem.title = "Set Monthly Savings"
            textField.placeholder = "Your Monthly Savings"
            textField.text = (UserKeyStore.sharedInstance.keyStore.object(forKey: "monthlySavings") as? Int ?? 0).toCurrency()
            textField.keyboardType = .numberPad
        case 2:
            navigationItem.title = "Set User Name"
            textField.placeholder = "Your Name"
            textField.text = UserKeyStore.sharedInstance.keyStore.string(forKey: "userFullName")
            textField.returnKeyType = .done
        default:
            navigationItem.title = ""
        }
    }
    
    private func checkIfAllFieldFilled() {
        let fieldText = textField.text!
        
        if !fieldText.isEmpty {
            updateButton.isEnabled = true
        } else {
            updateButton.isEnabled = false
        }
    }
    
    private func showSuccessAlert() {
        let title = "Data Updated"
        let message = "Your data is successfully updated!"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in
            self.dismissLoading()
            self.performSegue(withIdentifier: "unwindToProfile", sender: self)
        })
        
        alert.addAction(doneAction)
        
        self.present(alert, animated: true)
    }
}
