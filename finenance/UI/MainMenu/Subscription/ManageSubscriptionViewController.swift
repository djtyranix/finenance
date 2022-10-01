//
//  ManageSubscriptionViewController.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit

class ManageSubscriptionViewController: UIViewController {

    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarStyle()
        lottieView.isHidden = false
        dataView.isHidden = true
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
}
