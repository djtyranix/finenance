//
//  ExpenseViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class ExpenseViewModel: NSObject {
    
    private let repository = FinenanceRepository.sharedInstance
    
    func getExpenses() -> [Expense] {
        let transactions = repository.getAllDataOnMonth()
        var expenses = [Expense]()
        
        for transaction in transactions {
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
    
    func calculateTotalExpenses(expenses: [Expense]) -> TotalExpenses {
        var totalExpenses = TotalExpenses(totalExpense: 0, fnbAmount: 0, billsAmount: 0, leisureAmount: 0, otherAmount: 0)
        
        for expense in expenses {
            switch expense.category {
            case .fnb:
                totalExpenses.fnbAmount += expense.amount
                totalExpenses.totalExpense += expense.amount
            
            case .bills:
                totalExpenses.billsAmount += expense.amount
                totalExpenses.totalExpense += expense.amount
                
            case .leisure:
                totalExpenses.leisureAmount += expense.amount
                totalExpenses.totalExpense += expense.amount
                
            case .other:
                totalExpenses.otherAmount += expense.amount
                totalExpenses.totalExpense += expense.amount
                
            case .income:
                totalExpenses.totalExpense += 0
            }
        }
        
        return totalExpenses
    }
    
    func generateDetailTuple(totalExpenses: TotalExpenses) -> [(title: String, detail: String)] {
        var array = [(title: String, detail: String)]()
        
        array.append(("Total Expenses", totalExpenses.totalExpense.toCurrency()))
        array.append((TransactionCategory.fnb.rawValue, totalExpenses.fnbAmount.toCurrency()))
        array.append((TransactionCategory.bills.rawValue, totalExpenses.billsAmount.toCurrency()))
        array.append((TransactionCategory.leisure.rawValue, totalExpenses.leisureAmount.toCurrency()))
        array.append((TransactionCategory.other.rawValue, totalExpenses.otherAmount.toCurrency()))
        
        return array
    }
    
    func saveNewTransaction(transaction: Transaction) -> Bool {
        return repository.saveData(data: transaction)
    }
    
    func updateTransaction(transaction: Transaction) -> Bool {
        return repository.updateData(id: transaction.id, data: transaction)
    }
}
