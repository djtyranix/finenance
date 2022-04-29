//
//  OnboadingDoneViewController.swift
//  finenance
//
//  Created by Michael Ricky on 29/04/22.
//

import UIKit

class OnboadingDoneViewController: UIViewController {

    @IBAction func goToHome(_ sender: Any) {
        guard let window = UIApplication
            .shared
            .connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        let mainMenu = self.storyboard?.instantiateViewController(withIdentifier: "mainmenu")
        self.view.window?.rootViewController = mainMenu
        
        // A mask of options indicating how you want to perform the animations.
        let options: UIView.AnimationOptions = .transitionCrossDissolve

        // The duration of the transition animation, measured in seconds.
        let duration: TimeInterval = 0.3

        // Creates a transition animation.
        // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
