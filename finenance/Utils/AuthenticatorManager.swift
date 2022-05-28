//
//  AuthenticatorManager.swift
//  finenance
//
//  Created by Michael Ricky on 20/05/22.
//

import UIKit
import LocalAuthentication

class AuthenticatorManager: NSObject {
    
    struct Static {
        static var instance: AuthenticatorManager?
    }
    
    class var sharedInstance: AuthenticatorManager {
        if Static.instance == nil {
            Static.instance = AuthenticatorManager()
        }
        
        return Static.instance!
    }
    
    func disposeSingleton() {
        AuthenticatorManager.Static.instance = nil
        print("AuthenticatorManager Disposed")
    }
    
    var needsAuthentication = true
    
    func checkIfBiometricsHasPermission() -> Bool {
        var error: NSError?
        
        let context = LAContext()
        
        let isGranted = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        
        if isGranted {
            return true
        } else if let laError = error {
            self.showLAError(laError: laError)
            return false
        } else {
            return false
        }
    }
    
    func loginWithBiometrics(successCallback: @escaping (() -> Void), failedCallback: @escaping (() -> Void)) {
        let reason = "Log in with Biometrics"
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: reason) { success, error in
            if success {
                successCallback()
            } else {
                failedCallback()
            }
        }
    }
    
    func showLAError(laError: Error) -> Void {
        
        var message = ""
        
        switch laError {
            
        case LAError.appCancel:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel:
            message = "The user did cancel"
            
        case LAError.userFallback:
            message = "The user chose to use the fallback"
            
        default:
            switch laError {
            case LAError.biometryNotAvailable:
                message = "Biometry is not available"
                
            case LAError.biometryNotEnrolled:
                message = "Authentication could not start, because biometry has no enrolled identities"
                
            case LAError.biometryLockout:
                message = "Biometry is locked. Use passcode."

            default:
                message = "Did not find error code on LAError object"
            }
            
            message = "Did not find error code on LAError object"
        }
        
        //return message
        print("LAError message - \(message)")
        
    }
}
