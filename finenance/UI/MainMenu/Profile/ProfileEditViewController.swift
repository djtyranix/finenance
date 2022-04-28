//
//  ProfileEditViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        showLoading()
        let text = textField.text!
        
        switch mode {
        case 0:
            UserDefaults.standard.set(Int(text), forKey: "monthlyIncome")
        case 1:
            UserDefaults.standard.set(Int(text), forKey: "monthlySavings")
        case 2:
            let fullNameArr = text.components(separatedBy: " ")
            let firstName = fullNameArr.first!
            UserDefaults.standard.set(firstName, forKey: "userFirstName")
            UserDefaults.standard.set(text, forKey: "userFullName")
        default:
            navigationItem.title = ""
        }
        
        dismissLoading()
        performSegue(withIdentifier: "unwindToProfile", sender: self)
    }
    
    var mode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarStyle()
        checkMode()
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
            textField.text = String(UserDefaults.standard.value(forKey: "monthlyIncome") as! Int)
        case 1:
            navigationItem.title = "Set Monthly Savings"
            textField.placeholder = "Your Monthly Savings"
            textField.text = String(UserDefaults.standard.value(forKey: "monthlySavings") as! Int)
        case 2:
            navigationItem.title = "Set User Name"
            textField.placeholder = "Your Name"
            textField.text = UserDefaults.standard.value(forKey: "userFullName") as? String
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
}
