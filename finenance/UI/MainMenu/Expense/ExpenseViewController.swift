//
//  ExpenseViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class ExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemArray = [(title: String, detail: String)]()
    var expenseDatas = [Expense]()
    var totalExpenses = TotalExpenses(totalExpense: 0, fnbAmount: 0, billsAmount: 0, leisureAmount: 0, otherAmount: 0)
    let viewModel = ExpenseViewModel()
    
    @IBOutlet weak var expenseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseTable.delegate = self
        expenseTable.dataSource = self
        
        updateUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUi()
        
        setNavBarStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AddEditExpenseViewController else {
            return
        }
        
        vc.viewModel = self.viewModel
        vc.updateData = { [weak self] in
            self?.updateUi()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expenseTable.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        
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
        expenseDatas = viewModel.getExpenses()
        totalExpenses = viewModel.calculateTotalExpenses(expenses: self.expenseDatas)
        itemArray = viewModel.generateDetailTuple(totalExpenses: totalExpenses)
    }
    
    private func updateUi() {
        getData()
        expenseTable.reloadData()
    }
}
