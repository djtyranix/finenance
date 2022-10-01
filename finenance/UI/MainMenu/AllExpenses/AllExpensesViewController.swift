//
//  AllExpensesViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class AllExpensesViewController: SecureViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    let viewModel = AllExpensesViewModel()
    let searchController = UISearchController()
    var expenseDatas = [Expense]()
    var selectedExpense = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "", colorData: ColorData(colorType: .dark, mainColor: .blue, shadeColor: .blue))
    var filteredDatas = [Expense]()
    var isAddingIncome = false
    
    @IBOutlet weak var expensesTable: UITableView!
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addExpenseAction = UIAlertAction(title: "Add Expense", style: .default, handler: { _ in
            self.isAddingIncome = false
            self.performSegue(withIdentifier: "goToAddExpense", sender: self)
        })
        
        let addIncomeAction = UIAlertAction(title: "Add Income", style: .default, handler: { _ in
            self.isAddingIncome = true
            self.performSegue(withIdentifier: "goToAddExpense", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(addExpenseAction)
        optionMenu.addAction(addIncomeAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSearchController()
        setUpTableView()
        getData()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        updateViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return filteredDatas.count
        }
        
        return expenseDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTable.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpensesTableViewCell
        
        let expense: Expense
        
        if searchController.isActive {
            expense = filteredDatas[indexPath.row]
        } else {
            expense = expenseDatas[indexPath.row]
        }

        cell.expenseNameLabel.text = expense.name
        
        if expense.category == .income {
            cell.expenseAmountLabel.text = "+ \(expense.amount.toCurrency())"
            cell.expenseAmountLabel.textColor = UIColor(named: "MainBlue")
        } else {
            cell.expenseAmountLabel.text = "- \(expense.amount.toCurrency())"
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
        
        if searchController.isActive {
            selectedExpense = filteredDatas[indexPath.row]
        } else {
            selectedExpense = expenseDatas[indexPath.row]
        }
        
        performSegue(withIdentifier: "fromAllToDetail", sender: cell)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: selectedScopeButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExpenseDetailViewController {
            vc.expenseData = selectedExpense
        } else if let vc = segue.destination as? AddEditExpenseViewController {
            if isAddingIncome {
                vc.isIncome = true
            }
            
            vc.updateData = { [weak self] in
                self?.getData()
                self?.updateViews()
            }
        }
    }
    
    private func setUpTableView() {
        expensesTable.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpenseCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
        expensesTable.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        expensesTable.refreshControl = refreshControl
    }
    
    private func getData() {
        expenseDatas = viewModel.getAllExpenses()
    }
    
    private func updateViews() {
        expensesTable.reloadData()
    }
    
    @objc private func refreshData() {
        self.expensesTable.refreshControl?.beginRefreshing()
        self.getData()
        self.updateViews()
        self.expensesTable.refreshControl?.endRefreshing()
    }
    
    private func initSearchController() {
        searchController.loadView()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = [
            "All",
            "F&B",
            TransactionCategory.bills.rawValue,
            TransactionCategory.leisure.rawValue,
            TransactionCategory.income.rawValue,
            TransactionCategory.other.rawValue            
        ]
        searchController.searchBar.delegate = self
    }

    private func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All") {
        filteredDatas = expenseDatas.filter { expense in
            let scopeName: String
            if scopeButton == "F&B" {
                scopeName = TransactionCategory.fnb.rawValue
            } else {
                scopeName = scopeButton
            }
            
            let scopeMatch = (scopeButton == "All" || expense.categoryName == scopeName)
            
            if searchController.searchBar.text != "" {
                let searchTextMatch = expense.name.lowercased().contains(searchText.lowercased())
                
                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        
        self.refreshData()
    }
}
