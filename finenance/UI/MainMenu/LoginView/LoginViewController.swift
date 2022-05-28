//
//  LoginViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/05/22.
//

import UIKit

class LoginViewController: SecureViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        super.window = self.window
    }
    
    override func goToHome() {
        let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
        let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "mainmenu") as! AnimTabBarController
        self.view.window?.rootViewController = homePage
    }
}
