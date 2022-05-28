//
//  HomeViewController.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class HomeViewController: SecureViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var expensesTable: UITableView!
    @IBOutlet weak var currentMonthAndYear: UILabel!
    @IBOutlet weak var currentRemainingBudget: UILabel!
    @IBOutlet weak var currentMonthlyExpenses: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var budgetStatusLabel: UILabel!
    @IBOutlet weak var userGreetingsLabel: UILabel!
    
    let viewModel = HomeViewModel()
    var expenseDatas = [Expense]()
    var userName: String = ""
    var monthlyExpenses = 0
    var remainingBudget = 0
    var monthAndYear = ""
    var selectedExpense = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "", colorData: ColorData(colorType: .dark, mainColor: .blue, shadeColor: .blue))
    var isAddingIncome = false
    
    @IBAction func showMoreClicked(_ sender: UIButton) {
    }
    
    @IBAction func addEditPressed(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addExpenseAction = UIAlertAction(title: "Add Expense", style: .default, handler: { _ in
            self.isAddingIncome = false
            self.performSegue(withIdentifier: "showAddEditSegue", sender: self)
        })
        
        let addIncomeAction = UIAlertAction(title: "Add Income", style: .default, handler: { _ in
            self.isAddingIncome = true
            self.performSegue(withIdentifier: "showAddEditSegue", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(addExpenseAction)
        optionMenu.addAction(addIncomeAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesTable.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpenseCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
        expensesTable.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        expensesTable.refreshControl = refreshControl
        
        refreshData()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.clear]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTable.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpensesTableViewCell
        
        let expense = expenseDatas[indexPath.row]
        
        cell.expenseNameLabel.text = expense.name
        
        if expense.category == .income {
            cell.expenseAmountLabel.text = "+ \(expense.amount.formatToRupiah())"
            cell.expenseAmountLabel.textColor = UIColor(named: "MainBlue")
        } else {
            cell.expenseAmountLabel.text = "- \(expense.amount.formatToRupiah())"
            cell.expenseAmountLabel.textColor = UIColor(named: "MainRed")
        }
        
        cell.expenseDateLabel.text = expense.date
        cell.expenseCategoryLabel.text = expense.categoryName
        cell.expenseImageView.image = expense.category.toImage()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedExpense = expenseDatas[indexPath.row]
        
        performSegue(withIdentifier: "fromHomeToDetail", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExpenseDetailViewController {
            vc.expenseData = selectedExpense
        } else if let vc = segue.destination as? AddEditExpenseViewController {
            
            if isAddingIncome {
                vc.isIncome = true
            }
            
            vc.updateData = { [weak self] in
                self?.refreshData()
            }
        }
    }
    
    private func getData() {
        expenseDatas = viewModel.getLatestExpenses()
        userName = viewModel.getUserName()
        monthlyExpenses = viewModel.getMonthlyExpenses()
        remainingBudget = viewModel.getRemainingBudgets(monthlyExpense: monthlyExpenses)
        monthAndYear = viewModel.getCurrentMonthAndYear()
    }
    
    private func updateViews() {
        userGreetingsLabel.text = "Hello, \(userName)!"
        currentMonthlyExpenses.text = monthlyExpenses.formatToRupiah()
        currentRemainingBudget.text = remainingBudget.formatToRupiah()
        
        if (Double(remainingBudget) / Double(monthlyExpenses + remainingBudget)) < 0.25 {
            statusImageView.image = UIImage(named: "budgetwarning")
            budgetStatusLabel.text = "High usage!"
        } else {
            statusImageView.image = UIImage(named: "budgethigh")
            budgetStatusLabel.text = "Good to go!"
        }
        
        currentMonthAndYear.text = monthAndYear
        expensesTable.reloadData()
    }
    
    @objc private func refreshData() {
        self.expensesTable.refreshControl?.beginRefreshing()
        self.getData()
        self.updateViews()
        self.expensesTable.refreshControl?.endRefreshing()
    }
}
