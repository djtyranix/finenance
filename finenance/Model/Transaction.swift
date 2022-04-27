//
//  Transaction.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import Foundation
import UIKit

struct Transcation {
    let name: String
    let amount: Int
    let date: Date
    let category: TransactionCategory
    let type: TransactionType
}

struct Expense {
    let name: String
    let amount: Int
    let date: String
    let category: TransactionCategory
    let categoryName: String
    let colorData: ColorData
}

enum TransactionCategory: String {
    case fnb = "Food & Beverages"
    case bills = "Bills"
    case income = "Monthly Income"
    case gift = "Gift"
    case leisure = "Leisure"
    case other = "Other"
}

enum TransactionType {
    case expense, income
}

extension TransactionCategory {
    // Returns ColorData
    public func toColor() -> ColorData {
        switch self {
        case .fnb:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainRed")!, shadeColor: UIColor(named: "MainRedShade")!)
            
        case .income, .gift, .leisure:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainBlue")!, shadeColor: UIColor(named: "MainBlueShade")!)
            
        case .bills:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainGreen")!, shadeColor: UIColor(named: "MainGreenShade")!)
        
        case .other:
            return ColorData(colorType: .light, mainColor: .systemGray4, shadeColor: .systemGray)
        }
    }
}
