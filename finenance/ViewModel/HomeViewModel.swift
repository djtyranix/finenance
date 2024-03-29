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
        return UserKeyStore.sharedInstance.keyStore.string(forKey: "userFirstName") ?? "User"
    }
    
    func getRemainingBudgets(monthlyExpense: Int) -> Int {
        let monthlyIncome = UserKeyStore.sharedInstance.keyStore.object(forKey: "monthlyIncome") as? Int ?? 0
        let monthlySavings = UserKeyStore.sharedInstance.keyStore.object(forKey: "monthlySavings") as? Int ?? 0
        let otherIncome = getOtherIncomeAmount()
        
        return monthlyIncome + otherIncome - monthlySavings - monthlyExpense
    }
    
    func getMonthlyExpenses() -> Int {
        return calculateTotalExpenses(expenses: getExpenses()).totalExpense
    }
    
    func getCurrentMonthAndYear() -> String {
        let date = Date()
        return date.formatToString(format: "MMMM YYYY")
    }
    
    private func getExpenses() -> [Expense] {
        let transactions = repository.getAllDataOnMonth()
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
                    categoryName: transaction.category.rawValue
                )
            )
        }
        
        return expenses
    }
    
    private func getOtherIncomeAmount() -> Int {
        let transactions = repository.getDataByTypeOnMonth(category: .income)
        var otherIncome = 0
        
        for transaction in transactions {
            otherIncome += transaction.amount
        }
        
        return otherIncome
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
                
            case .income:
                totalExpenses.totalExpense += 0
            }
        }
        
        return totalExpenses
    }
}
