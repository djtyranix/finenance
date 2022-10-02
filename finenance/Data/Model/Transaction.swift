//
//  Transaction.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import Foundation
import UIKit

struct Transaction {
    let id: Int
    let name: String
    let amount: Int
    let date: Date
    let category: TransactionCategory
}

struct Expense {
    let id: Int
    let name: String
    let amount: Int
    let date: String
    let category: TransactionCategory
    let categoryName: String
}

enum TransactionCategory: String, CaseIterable {
    case fnb = "Food & Beverages"
    case bills = "Bills"
    case leisure = "Leisure"
    case other = "Other"
    case income = "Income"
}

extension TransactionCategory {
    public func toImage() -> UIImage {
        switch self {
        case .fnb:
            return UIImage(named: "burger")!
            
        case .leisure:
            return UIImage(named: "online-shopping")!
            
        case .bills:
            return UIImage(named: "bill")!
        
        case .other:
            return UIImage(named: "expense")!
            
        case .income:
            return UIImage(named: "wallet")!
        }
    }
}
