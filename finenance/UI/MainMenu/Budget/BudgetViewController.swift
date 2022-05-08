//
//  BudgetViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemArray = [(title: String, detail: String)]()
    var totalBudget = TotalBudget(totalBudget: 0, totalSavings: 0, monthlyIncome: 0, totalExpenses: 0, remainingBudget: 0, otherIncome: 0)
    let viewModel = BudgetViewModel()
    
    @IBOutlet weak var incomeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeTable.delegate = self
        incomeTable.dataSource = self
        
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBarStyle()
        getData()
        updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AddEditExpenseViewController else {
            return
        }
        
        vc.isIncome = true
        
        vc.updateData = { [weak self] in
            self?.getData()
            self?.updateView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = incomeTable.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.detailTextLabel?.text = itemArray[indexPath.row].detail
        
        return cell
    }
    
    private func setNavBarStyle() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(named: "MainBlue")!
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    private func getData() {
        totalBudget = viewModel.getTotalBudget()
        itemArray = viewModel.generateDetailTuple(totalBudget: totalBudget)
    }
    
    private func updateView() {
        incomeTable.reloadData()
    }
}
