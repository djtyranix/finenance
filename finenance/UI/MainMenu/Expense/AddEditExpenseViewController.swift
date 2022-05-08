//
//  AddEditExpenseViewController.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class AddEditExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var viewModel = ExpenseViewModel()
    var categoryArray = [TransactionCategory]()
    var selectedCategory = TransactionCategory.other
    var selectedIndex = 3
    let datePicker = UIDatePicker()
    var selectedDate = Date()
    var isEdit = false
    var isIncome = false
    var expenseData = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "", colorData: ColorData(colorType: .dark, mainColor: .blue, shadeColor: .blue))
    var updateData: (()->())?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    @IBOutlet weak var currentNavBar: UINavigationItem!
    
    @IBAction func nameFieldChanged(_ sender: Any) {
        checkIfAllFieldFilled()
    }
    
    @IBAction func amountFieldChanged(_ sender: Any) {
        checkIfAllFieldFilled()
    }
    
    @IBAction func dateFieldPressed(_ sender: Any) {
        checkIfAllFieldFilled()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        let id = expenseData.id
        let name = nameField.text!
        let amount = Int(amountField.text!) ?? 0
        let date = selectedDate
        let category = selectedCategory
        
        let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
        
        showLoading()
        self.cancelButton.isEnabled = false
        self.addButton.isEnabled = false
        
        // CoreData Operation
        if isEdit {
            self.updateData(data: transaction)
        } else {
            self.addData(data: transaction)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCategoryArray()
        prepareTableView()
        createDatePicker()
        checkIfAddIncome()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateData?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = categoryArray[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedCategory = categoryArray[indexPath.row]
        checkIfAllFieldFilled()
        
        categoryTable.reloadData()
        print(selectedCategory.rawValue)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
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
    
    private func prepareCategoryArray() {
        categoryArray = TransactionCategory.allCases
        categoryArray.remove(at: 4) // Hiding Income
    }
    
    private func prepareForAddIncome() {
        currentNavBar.title = "Add Income"
        selectedCategory = TransactionCategory.income
        selectedIndex = 4
        categoryTable.isHidden = true
        selectCategoryLabel.isHidden = true
    }
    
    private func prepareTableView() {
        categoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    private func checkIfAllFieldFilled() {
        let nameText = nameField.text!
        let amountText = amountField.text!
        let dateText = dateField.text!
        
        if !nameText.isEmpty && !amountText.isEmpty && !dateText.isEmpty {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    private func createDatePicker() {
        // Creating ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Creating Bar Button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // Assign Toolbar
        dateField.inputAccessoryView = toolbar
        dateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    @objc private func dismissDatePicker() {
        self.selectedDate = datePicker.date
        dateField.text = datePicker.date.formatToString(format: "dd/MM/yyyy")
        self.view.endEditing(true)
        checkIfAllFieldFilled()
    }
    
    private func addData(data: Transaction) {
        let isSuccess = viewModel.saveNewTransaction(transaction: data)
        
        if isSuccess {
            // If the operation is succeeded, dismiss
            self.dismissLoading()
            self.showSuccessAlert()
        } else {
            // If the operation failed, show alert
            showErrorAlert()
        }
    }
    
    private func updateData(data: Transaction) {
        let isSuccess = viewModel.updateTransaction(transaction: data)
        
        if isSuccess {
            // If the operation is succeeded, dismiss
            self.dismissLoading()
            self.showSuccessAlert()
        } else {
            // If the operation failed, show alert
            showErrorAlert()
        }
    }
    
    private func checkIfEditing() {
        if isEdit {
            currentNavBar.title = "Edit Expense"
            addButton.title = "Update"
            
            categoryArray = TransactionCategory.allCases
            
            nameField.text = expenseData.name
            amountField.text = String(expenseData.amount)
            dateField.text = expenseData.date
            selectedDate = expenseData.date.formatToDate(format: "dd/MM/yyyy")
            selectedCategory = expenseData.category
            
            switch selectedCategory {
            case .fnb:
                selectedIndex = 0
            case .bills:
                selectedIndex = 1
            case .leisure:
                selectedIndex = 2
            case .other:
                selectedIndex = 3
            case .income:
                selectedIndex = 4
            }
        }
    }
    
    private func checkIfAddIncome() {
        if isIncome {
            prepareForAddIncome()
        } else {
            checkIfEditing()
        }
    }
    
    private func showSuccessAlert() {
        var title = ""
        let message = "You can see your transactions on the home and see the overview on the expenses and budget menu."
        
        if isEdit {
            title = "Transaction Updated"
        } else if isIncome {
            title = "Income Added"
        } else {
            title = "Expense Added"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in
            if self.isEdit {
                self.dismiss(animated: true)
                self.performSegue(withIdentifier: "unwindToAllExpenses", sender: self)
            } else {
                self.dismiss(animated: true)
            }
        })
        
        alert.addAction(doneAction)
        
        self.present(alert, animated: true)
    }
    
    private func showErrorAlert() {
        var title = ""
        let message = "An error occured. Please try again in a moment."
        
        if isEdit {
            title = "Update Error"
        } else {
            title = "Insert Error"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: {_ in
            self.dismissLoading()
            self.addButton.isEnabled = true
            self.cancelButton.isEnabled = true
        })
        
        alert.addAction(doneAction)
        
        self.present(alert, animated: true)
    }
}
