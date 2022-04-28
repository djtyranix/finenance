//
//  ExpenseDetailViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class ExpenseDetailViewModel: NSObject {
    func generateDetailTuple(data: Expense) -> [(title: String, detail: String)] {
        var array = [(title: String, detail: String)]()
        
        array.append((title: "Name", detail: data.name))
        array.append((title: "Amount", detail: data.amount.formatToRupiah()))
        array.append((title: "Date", detail: data.date))
        array.append((title: "Category", detail: data.categoryName))
        
        return array
    }
}
