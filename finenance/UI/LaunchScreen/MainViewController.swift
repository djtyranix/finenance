//
//  ViewController.swift
//  finenance
//
//  Created by Michael Ricky on 25/04/22.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UserDefaults.standard.set(true, forKey: "isOnboardingFinished")
        UserDefaults.standard.set("Michael", forKey: "userName")
        UserDefaults.standard.set(10000000, forKey: "monthlyIncome")
        UserDefaults.standard.set(3000000, forKey: "monthlySavings")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isOnboardingFinished = UserDefaults.standard.value(forKey: "isOnboardingFinished") as? Bool ?? false
        
        if isOnboardingFinished {
            // Move to Home
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainmenu") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        } else {
            // Move to Onboarding
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "onboarding") as! OnboardingViewController
            self.present(vc, animated: true, completion: nil)
        }
    }


}

