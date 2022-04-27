//
//  HomeViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var expensesTable: UITableView!
    @IBOutlet weak var currentMonthAndYear: UILabel!
    @IBOutlet weak var currentRemainingBudget: UILabel!
    @IBOutlet weak var currentMonthlyExpenses: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var budgetStatusLabel: UILabel!
    @IBOutlet weak var userGreetingsLabel: UILabel!
    
    @IBAction func showMoreClicked(_ sender: UIButton) {
    }
    
    let viewModel = HomeViewModel()
    var expenseDatas = [Expense]()
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesTable.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "Cell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
        expensesTable.separatorStyle = .none
        
        getData()
        updateViews()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTable.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpenseTableViewCell
        
        let expense = expenseDatas[indexPath.row]
        let colorData = expense.colorData
        
        cell.categoryOuter.layer.cornerRadius = 8
        cell.expenseNameLabel.text = expense.name
        cell.expenseAmountLabel.text = expense.amount.formatToRupiah()
        cell.expenseDateLabel.text = expense.date
        cell.expenseCategoryLabel.text = expense.categoryName
        cell.expenseImageView.image = UIImage(systemName: "cart.fill")
        cell.selectionStyle = .none
        
        cell.categoryOuter.borderColor = colorData.shadeColor
        cell.categoryOuter.backgroundColor = colorData.mainColor
        cell.expenseImageView.tintColor = UIColor(named: "MainRed")
        
        if colorData.colorType == .dark {
            cell.expenseCategoryLabel.textColor = .white
        }
        
        return cell
    }
    
    private func getData() {
        expenseDatas = viewModel.getLatestExpenses()
        userName = viewModel.getUserName()
    }
    
    private func updateViews() {
        userGreetingsLabel.text = "Hello, \(userName)!"
    }
}
