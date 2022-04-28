//
//  AllExpensesViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class AllExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let viewModel = AllExpensesViewModel()
    var expenseDatas = [Expense]()
    var selectedExpense = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "", colorData: ColorData(colorType: .dark, mainColor: .blue, shadeColor: .blue))
    
    @IBOutlet weak var expensesTable: UITableView!
    
    @IBAction func addExpense(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
        getData()
        updateViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expensesTable.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as! ExpensesTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        selectedExpense = expenseDatas[indexPath.row]
        
        performSegue(withIdentifier: "fromAllToDetail", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExpenseDetailViewController {
            vc.expenseData = selectedExpense
        }
    }
    
    private func setUpTableView() {
        expensesTable.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpenseCell")
        expensesTable.delegate = self
        expensesTable.dataSource = self
        expensesTable.separatorStyle = .none
    }
    
    private func getData() {
        expenseDatas = viewModel.getAllExpenses()
    }
    
    private func updateViews() {
        expensesTable.reloadData()
    }

}
