//
//  LottieViewController.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit
import Lottie

class LottieViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
    }
}
