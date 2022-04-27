//
//  AddEditExpenseViewController.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class AddEditExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryArray = [TransactionCategory]()
    var selectedCategory = TransactionCategory.other
    var selectedIndex = 3
    let datePicker = UIDatePicker()

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCategoryArray()
        prepareTableView()
        createDatePicker()
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
        
        categoryTable.reloadData()
        print(selectedCategory.rawValue)
    }
    
    private func prepareCategoryArray() {
        categoryArray = TransactionCategory.allCases
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
        dateField.text = datePicker.date.formatToString(format: "dd/MM/YYYY")
        self.view.endEditing(true)
    }
}
