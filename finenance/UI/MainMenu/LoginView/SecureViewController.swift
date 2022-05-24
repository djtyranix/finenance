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
            if AuthenticatorManager.sharedInstance.needsAuthentication {
                print("Needs authentication")
                AuthenticatorManager.sharedInstance.loginWithBiometrics(
                    successCallback: { [weak self] in
                        print("Successfully Authenticated")
                        DispatchQueue.main.async {
                            self?.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    },
                    failedCallback: {
                        print("Failed Authentication")
                    }
                )
            }
        } else {
            self.performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
}
