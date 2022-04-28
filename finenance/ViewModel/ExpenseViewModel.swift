//
//  ExpenseViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class ExpenseViewModel: NSObject {
    
//    private var dummyData = DummyDataGenerator()
    private let repository = FinenanceRepository()
    
    func getExpenses() -> [Expense] {
        let transactions = repository.getAllData()
        var expenses = [Expense]()
        
        for transaction in transactions {
            expenses.append(
                Expense(
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
                totalExpenses.leisureAmount += expense.amount
                totalExpenses.totalExpense += expense.amount
            }
        }
        
        return totalExpenses
    }
    
    func generateDetailTuple(totalExpenses: TotalExpenses) -> [(title: String, detail: String)] {
        var array = [(title: String, detail: String)]()
        
        array.append(("Total Expenses", totalExpenses.totalExpense.formatToRupiah()))
        array.append((TransactionCategory.fnb.rawValue, totalExpenses.fnbAmount.formatToRupiah()))
        array.append((TransactionCategory.bills.rawValue, totalExpenses.billsAmount.formatToRupiah()))
        array.append((TransactionCategory.leisure.rawValue, totalExpenses.leisureAmount.formatToRupiah()))
        array.append((TransactionCategory.other.rawValue, totalExpenses.otherAmount.formatToRupiah()))
        
        return array
    }
    
    func saveNewTransaction(transaction: Transaction) -> Bool {
        return repository.saveData(data: transaction)
    }
}
