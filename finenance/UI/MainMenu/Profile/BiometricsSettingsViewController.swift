//
//  BiometricsSettingsViewController.swift
//  finenance
//
//  Created by Michael Ricky on 24/05/22.
//

import UIKit

class BiometricsSettingsViewController: SecureViewController {

    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var lockIntervalSlider: UISlider!
    @IBOutlet weak var lockValueLabel: UILabel!
    @IBOutlet weak var lockIntervalHeaderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarStyle()
        checkIfBiometricEnabled()
        checkLockInterval()
    }
    
    @IBAction func lockIntervalChanged(_ sender: UISlider) {
        let intSliderValue = Int(sender.value)
        sender.value = Float(intSliderValue)
        
        if intSliderValue == 0 {
            lockValueLabel.text = "Lock immediately"
        } else if intSliderValue == 1 {
            lockValueLabel.text = "Lock after \(intSliderValue) minute"
        } else {
            lockValueLabel.text = "Lock after \(intSliderValue) minutes"
        }
        
        UserDefaults.standard.set(intSliderValue * 60, forKey: "lockInterval")
    }
    
    @IBAction func biometricSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            let isPermissionAuthorized = AuthenticatorManager.sharedInstance.checkIfBiometricsHasPermission()
            
            if isPermissionAuthorized {
                AuthenticatorManager.sharedInstance.loginWithBiometrics(
                    successCallback: {
                        UserDefaults.standard.set(true, forKey: "isBiometricsEnabled")
                        DispatchQueue.main.async {
                            sender.setOn(true, animated: true)
                            self.checkIfBiometricEnabled()
                        }
                    },
                    failedCallback: {
                        UserDefaults.standard.set(false, forKey: "isBiometricsEnabled")
                        DispatchQueue.main.async {
                            sender.setOn(false, animated: true)
                            self.checkIfBiometricEnabled()
                        }
                    }
                )
            } else {
                print("Failed isPermissionAuthorized")
                DispatchQueue.main.async {
                    sender.setOn(false, animated: true)
                    self.checkIfBiometricEnabled()
                }
            }
        } else {
            // Switch turned off
            let disableBiometricsAlert = UIAlertController(title: "Disable Biometrics", message: "Are you sure you want to disable biometrics lock?", preferredStyle: .alert)
            
            let disableAction = UIAlertAction(title: "Disable", style: .destructive, handler: {_ in
                UserDefaults.standard.set(false, forKey: "isBiometricsEnabled")
                UserDefaults.standard.removeObject(forKey: "lockInterval")
                sender.setOn(false, animated: true)
                self.checkIfBiometricEnabled()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                sender.setOn(true, animated: true)
                self.checkIfBiometricEnabled()
            })
            
            disableBiometricsAlert.addAction(disableAction)
            disableBiometricsAlert.addAction(cancelAction)
            
            self.present(disableBiometricsAlert, animated: true, completion: nil)
        }
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func checkIfBiometricEnabled() {
        let isBiometricEnabled = UserDefaults.standard.bool(forKey: "isBiometricsEnabled")

        biometricSwitch.isOn = isBiometricEnabled
        
        if isBiometricEnabled {
            showLockInterval(state: true)
        } else {
            showLockInterval(state: false)
        }
    }
    
    private func checkLockInterval() {
        let lockInterval = (UserDefaults.standard.value(forKey: "lockInterval") as? Int ?? 0) / 60
        lockIntervalSlider.value = Float(lockInterval)
        
        if lockInterval == 0 {
            lockValueLabel.text = "Lock immediately"
        } else if lockInterval == 1 {
            lockValueLabel.text = "Lock after \(lockInterval) minute"
        } else {
            lockValueLabel.text = "Lock after \(lockInterval) minutes"
        }
    }
    
    private func showLockInterval(state: Bool) {
        if !state {
            UIView.animate(withDuration: 0.2, animations: {
                self.lockIntervalHeaderLabel.alpha = 0
                self.lockIntervalSlider.alpha = 0
                self.lockValueLabel.alpha = 0
            }) {finished in
                self.lockIntervalHeaderLabel.isHidden = finished
                self.lockIntervalSlider.isHidden = finished
                self.lockValueLabel.isHidden = finished
            }
        } else {
            self.lockIntervalHeaderLabel.isHidden = false
            self.lockIntervalSlider.isHidden = false
            self.lockValueLabel.isHidden = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lockIntervalHeaderLabel.alpha = 1
                self.lockIntervalSlider.alpha = 1
                self.lockValueLabel.alpha = 1
            })
        }
    }
}
