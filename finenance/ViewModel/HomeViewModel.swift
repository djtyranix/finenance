//
//  HomeViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class HomeViewModel: NSObject {

    private let repository = FinenanceRepository.sharedInstance
    
    func getLatestExpenses() -> [Expense] {
        return Array(getExpenses().prefix(5))
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.value(forKey: "userFirstName") as? String ?? "User"
    }
    
    func getRemainingBudgets(monthlyExpense: Int) -> Int {
        let monthlyIncome = UserDefaults.standard.value(forKey: "monthlyIncome") as? Int ?? 0
        let monthlySavings = UserDefaults.standard.value(forKey: "monthlySavings") as? Int ?? 0
        
        return monthlyIncome - monthlySavings - monthlyExpense
    }
    
    func getMonthlyExpenses() -> Int {
        return calculateTotalExpenses(expenses: getExpenses()).totalExpense
    }
    
    func getCurrentMonthAndYear() -> String {
        let date = Date()
        return date.formatToString(format: "MMMM YYYY")
    }
    
    private func getExpenses() -> [Expense] {
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
    
    private func calculateTotalExpenses(expenses: [Expense]) -> TotalExpenses {
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
}
