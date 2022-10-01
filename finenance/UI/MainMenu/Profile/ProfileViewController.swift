//
//  ProfileViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit
import CoreData

class ProfileViewController: SecureViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedMode = 0
    let viewModel = ProfileViewModel()
    
    let profileSettings = [
        "Set Monthly Income",
        "Set Monthly Savings",
        "Set User Name",
        "Biometrics Lock",
        "Manage Subscription"
    ]
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var biometricSwitch: UISwitch!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBAction func deleteProfile(_ sender: Any) {
        // Destructive
        let optionMenu = UIAlertController(title: "Warning!", message: "Deleting profile is PERMANENT and cannot be recovered. Are you sure you want to delete ALL data?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes, Proceed to Delete", style: .destructive, handler: { _ in
            self.showLoading()
            let isSuccess = self.viewModel.destroyDatabase()
            
            if isSuccess {
                print("Deleted Database, continuing delete Keystore")
                self.deleteAndReset()
            } else {
                print("Couldn't Delete Database")
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        setNavBarStyle()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTable.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        cell.textLabel?.text = profileSettings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMode = indexPath.row
        
        switch selectedMode {
        case 0, 1:
            performSegue(withIdentifier: "goToProfileEditCurrency", sender: self)
        case 2:
            performSegue(withIdentifier: "goToProfileEdit", sender: self)
        case 3:
            performSegue(withIdentifier: "goToBiometricsSettings", sender: self)
        case 4:
            performSegue(withIdentifier: "goToManageSubscriptions", sender: self)
        default:
            performSegue(withIdentifier: "goToProfileEdit", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProfileEditViewController {
            vc.mode = selectedMode
        }
    }
    
    private func showLoading() {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.tag = 69
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    private func dismissLoading() {
        guard let viewWithTag = self.view.viewWithTag(69) else {
            return
        }
        
        viewWithTag.removeFromSuperview()
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(named: "MainBlue")!
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    private func setUpTableView() {
        profileTable.dataSource = self
        profileTable.delegate = self
    }
    
    private func updateViews() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let name = UserKeyStore.sharedInstance.keyStore.string(forKey: "userFullName")
        profileName.text = name
        versionLabel.text = "App Version v\(appVersion!)"
    }
    
    private func deleteAndReset() {
        UserKeyStore.sharedInstance.keyStore.removeObject(forKey: "userFirstName")
        UserKeyStore.sharedInstance.keyStore.removeObject(forKey: "userFullName")
        UserKeyStore.sharedInstance.keyStore.removeObject(forKey: "monthlyIncome")
        UserKeyStore.sharedInstance.keyStore.removeObject(forKey: "monthlySavings")
        UserKeyStore.sharedInstance.keyStore.removeObject(forKey: "isOnboardingFinished")
        UserKeyStore.sharedInstance.keyStore.synchronize()
        UserDefaults.standard.removeObject(forKey: "isBiometricsEnabled")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismissLoading()
            
            guard let window = UIApplication
                .shared
                .connectedScenes
                .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
                .first(where: { $0.isKeyWindow }) else {
                return
            }
            
            let onboardingPage = self.storyboard?.instantiateViewController(withIdentifier: "onboarding")
            self.view.window?.rootViewController = onboardingPage
            
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
    }
}
