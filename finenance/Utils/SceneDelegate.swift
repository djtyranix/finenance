//
//  SceneDelegate.swift
//  finenance
//
//  Created by Michael Ricky on 25/04/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        UserKeyStore.sharedInstance.keyStore.synchronize()
        print("UserKeyStore Synchronized")
        let isOnboardingFinished = UserKeyStore.sharedInstance.keyStore.bool(forKey: "isOnboardingFinished")
        let isAppTerminated = UserDefaults.standard.value(forKey: "isTerminated") as? Bool ?? false
        
        if isOnboardingFinished {
            if isAppTerminated {
                let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
                let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "loginView") as! LoginViewController
                self.window?.rootViewController = homePage
                UserDefaults.standard.removeObject(forKey: "isTerminated")
            } else {
                let mainStoryBoard = UIStoryboard(name: "MainMenu", bundle: nil)
                let homePage = mainStoryBoard.instantiateViewController(withIdentifier: "mainmenu") as! AnimTabBarController
                self.window?.rootViewController = homePage
            }
        } else {
            let onboardingStoryBoard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboarding = onboardingStoryBoard.instantiateViewController(withIdentifier: "onboarding")
            self.window?.rootViewController = onboarding
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        AuthenticatorManager.sharedInstance.disposeSingleton()
        FinenanceRepository.sharedInstance.disposeSingleton()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        self.window?.viewWithTag(221122)?.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window!.frame
        blurEffectView.tag = 221122
        
        self.window?.addSubview(blurEffectView)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        UserKeyStore.sharedInstance.keyStore.synchronize()
        print("UserKeyStore Synchronized")
        let backgroundEnteredDate = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "backgroundEntered"))
        let calendar = Calendar.current
        
        // Calculating time differences
        let backgroundEnteredTime = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: backgroundEnteredDate)
        let currentTime = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date())
        let differenceInSeconds = calendar.dateComponents([.second], from: backgroundEnteredTime, to: currentTime).second!
        
        // Getting User Key (in seconds)
        let userSetDifference = UserDefaults.standard.value(forKey: "lockInterval") as? Int ?? 0
        
        if differenceInSeconds >= userSetDifference {
            AuthenticatorManager.sharedInstance.needsAuthentication = true
        } else {
            AuthenticatorManager.sharedInstance.needsAuthentication = false
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        UserKeyStore.sharedInstance.keyStore.synchronize()
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "backgroundEntered")
    }
}

