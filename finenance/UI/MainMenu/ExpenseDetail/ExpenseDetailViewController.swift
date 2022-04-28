//
//  ExpenseDetailViewController.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ExpenseDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var itemArray = [(title: String, detail: String)]()
    var expenseData = Expense(id: 0, name: "", amount: 0, date: "", category: .other, categoryName: "", colorData: ColorData(colorType: .dark, mainColor: .blue, shadeColor: .blue))
    let viewModel = ExpenseDetailViewModel()
    
    @IBOutlet weak var detailTable: UITableView!
    
    @IBAction func editExpense(_ sender: Any) {
        
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
}
