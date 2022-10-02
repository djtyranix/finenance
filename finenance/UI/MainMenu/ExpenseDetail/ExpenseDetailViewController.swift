//
//  ExpenseDetailViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ExpenseDetailViewController: SecureViewController, UITableViewDelegate, UITableViewDataSource {

    var itemArray = [(title: String, detail: String)]()
    var expenseData = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "")
    let viewModel = ExpenseDetailViewModel()
    
    @IBOutlet weak var detailTable: UITableView!
    
    @IBAction func deletePressed(_ sender: UIButton) {
        showDeleteActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
        getData()
        updateView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.detailTextLabel?.text = itemArray[indexPath.row].detail
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AddEditExpenseViewController else {
            return
        }
        
        vc.isEdit = true
        vc.expenseData = expenseData
    }
    
    private func setUpTableView() {
        detailTable.dataSource = self
        detailTable.delegate = self
    }
    
    private func getData() {
        itemArray = viewModel.generateDetailTuple(data: expenseData)
    }
    
    private func updateView() {
        detailTable.reloadData()
    }
    
    private func showDeleteActionSheet() {
        // Destructive
        let optionMenu = UIAlertController(title: "Warning!", message: "Deleting transaction is PERMANENT and cannot be recovered. Are you sure you want to delete transaction data?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Yes, Proceed to Delete", style: .destructive, handler: { _ in
            let isSuccess = self.viewModel.deleteTransaction(id: self.expenseData.id)
            
            if isSuccess {
                print("Transaction Deleted")
                self.showSuccessAlert()
            } else {
                print("Couldn't Delete Transaction")
                self.showErrorAlert()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
    }
    
    private func showSuccessAlert() {
        let title = "Transaction Deleted"
        let message = "Selected transaction has been successfully deleted."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "unwindToPreviousScreen", sender: self)
        })
        
        alert.addAction(doneAction)
        
        self.present(alert, animated: true)
    }
    
    private func showErrorAlert() {
        let title = "Delete Error"
        let message = "An error occured. Please try again in a moment."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default)
        
        alert.addAction(doneAction)
        
        self.present(alert, animated: true)
    }
}
