//
//  HomeViewModel.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import UIKit

class HomeViewModel: NSObject {
    
    var dummyData = DummyDataGenerator()
    
    func getLatestExpenses() -> [Expense] {
        let transactions = dummyData.getLatestTransaction()
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
    
    func getUserName() -> String {
        return UserDefaults.standard.value(forKey: "userName") as? String ?? "User"
    }
}
