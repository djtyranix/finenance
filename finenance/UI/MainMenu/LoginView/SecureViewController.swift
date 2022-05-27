//
//  SecureViewController.swift
//  finenance
//
//  Created by Michael Ricky on 20/05/22.
//

import UIKit

class SecureViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        let isAuthEnabled = UserDefaults.standard.bool(forKey: "isBiometricsEnabled")
        
        if isAuthEnabled {
            print("Needs authentication")
            AuthenticatorManager.sharedInstance.loginWithBiometrics(
                successCallback: { [weak self] in
                    print("Successfully Authenticated")
                    DispatchQueue.main.async {
                        let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
                        let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "mainmenu") as! AnimTabBarController
                        self?.view.window?.rootViewController = homePage
                    }
                },
                failedCallback: {
                    print("Failed Authentication")
                }
            )
        } else {
            let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
            let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "mainmenu") as! AnimTabBarController
            self.view.window?.rootViewController = homePage
        }
    }
}
