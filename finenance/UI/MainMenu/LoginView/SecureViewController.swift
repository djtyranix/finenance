//
//  SecureViewController.swift
//  finenance
//
//  Created by Michael Ricky on 20/05/22.
//

import UIKit

class SecureViewController: UIViewController {
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {        
        NotificationCenter.default.addObserver(self, selector: #selector(authorizeUser), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authorizeUser()
    }
    
    @objc func authorizeUser() {
        self.blurView()
        let isAuthEnabled = UserDefaults.standard.bool(forKey: "isBiometricsEnabled")
        let isAuthNeeded = AuthenticatorManager.sharedInstance.needsAuthentication
        
        if isAuthEnabled && isAuthNeeded {
            print("Needs authentication from \(String(describing: self.window.rootViewController))")
            AuthenticatorManager.sharedInstance.loginWithBiometrics(
                successCallback: { [weak self] in
                    print("Successfully Authenticated")
                    AuthenticatorManager.sharedInstance.needsAuthentication = false
                    
                    DispatchQueue.main.async {
                        self?.unblurView()
                        // Go To Home if needed
                        self?.goToHome()
                    }
                },
                failedCallback: { [weak self] in
                    print("Failed Authentication")
                    DispatchQueue.main.async {
                        let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
                        let loginView = mainStoryBoard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
                        self?.view.window?.rootViewController = loginView
                    }
                }
            )
        }
    }
    
    func goToHome() {}
    
    func blurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.tag = 333333
        
        window.addSubview(blurEffectView)
    }
    
    func unblurView() {
        window.viewWithTag(333333)?.removeFromSuperview()
    }
}
