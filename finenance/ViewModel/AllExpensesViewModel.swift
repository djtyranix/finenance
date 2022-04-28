//
//  AllExpensesViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit

class AllExpensesViewModel: NSObject {
    private let repository = FinenanceRepository.sharedInstance
    
    func getAllExpenses() -> [Expense] {
        let transactions = repository.getAllData()
        var expenses = [Expense]()
        let transactionsSorted = transactions.sorted {
            $0.date > $1.date
        }
        
        for transaction in transactionsSorted {
            expenses.append(
                Expense(
                    id: transaction.id,
                    name: transaction.name,
                    amount: transaction.amount,
                    date: transaction.date.formatToString(format: "dd/MM/YYYY"),
                    category: transaction.category,
                    categoryName: transaction.category.rawValue,
                    colorData: transaction.category.toColor()
                )
            )
        }
        
        return expenses
    }
}
