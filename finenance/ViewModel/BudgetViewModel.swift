//
//  BudgetViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 27/04/22.
//

import UIKit

class BudgetViewModel: NSObject {
    
    var repository = FinenanceRepository.sharedInstance

    func getTotalBudget() -> TotalBudget {
        let monthlyIncome = UserDefaults.standard.value(forKey: "monthlyIncome") as? Int ?? 0
        let monthlySavings = UserDefaults.standard.value(forKey: "monthlySavings") as? Int ?? 0
        let totalExpenses = calculateTotalExpenses(expenses: getExpenses()).totalExpense
        
        let totalBudget = TotalBudget(
            totalBudget: monthlyIncome - monthlySavings,
            totalSavings: monthlySavings,
            monthlyIncome: monthlyIncome,
            totalExpenses: totalExpenses,
            remainingBudget: monthlyIncome - monthlySavings - totalExpenses
        )
        
        return totalBudget
    }
    
    func generateDetailTuple(totalBudget: TotalBudget) -> [(title: String, detail: String)] {
        var array = [(title: String, detail: String)]()
        
        array.append(("Total Budget", totalBudget.totalBudget.formatToRupiah()))
        array.append(("Total Savings", totalBudget.totalSavings.formatToRupiah()))
        array.append(("Monthly Income", totalBudget.monthlyIncome.formatToRupiah()))
        array.append(("Total Expenses", totalBudget.totalExpenses.formatToRupiah()))
        array.append(("Remaining Budget", totalBudget.remainingBudget.formatToRupiah()))
        
        return array
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
