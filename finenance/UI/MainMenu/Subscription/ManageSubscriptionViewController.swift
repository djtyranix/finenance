//
//  ManageSubscriptionViewController.swift
//  finenance
//
//  Created by Michael Ricky on 01/10/22.
//

import UIKit

class ManageSubscriptionViewController: UIViewController {

    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var dataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBarStyle()
        setLoading(state: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setLoading(state: false)
        }
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setLoading(state: Bool, isNotEmpty: Bool = false) {
        if state {
            // Loading
            loadingIcon.isHidden = false
            lottieView.isHidden = true
            dataView.isHidden = true
        } else {
            // Stopped Loading
            if isNotEmpty {
                lottieView.isHidden = true
                dataView.isHidden = false
            } else {
                lottieView.isHidden = false
                dataView.isHidden = true
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.loadingIcon.alpha = 0
            }) { (finished) in
                self.loadingIcon.isHidden = finished
            }
        }
    }
}
