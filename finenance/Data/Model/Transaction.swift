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
    let colorData: ColorData
}

enum TransactionCategory: String, CaseIterable {
    case fnb = "Food & Beverages"
    case bills = "Bills"
    case leisure = "Leisure"
    case other = "Other"
    case income = "Income"
}

extension TransactionCategory {
    // Returns ColorData
    public func toColor() -> ColorData {
        switch self {
        case .fnb:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainRed")!, shadeColor: UIColor(named: "MainRedShade")!)
            
        case .leisure:
            return ColorData(colorType: .light, mainColor: UIColor(named: "MainYellow")!, shadeColor: UIColor(named: "MainYellowShade")!)
            
        case .bills:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainGreen")!, shadeColor: UIColor(named: "MainGreenShade")!)
        
        case .other:
            return ColorData(colorType: .light, mainColor: .systemGray4, shadeColor: .systemGray)
            
        case .income:
            return ColorData(colorType: .dark, mainColor: UIColor(named: "MainBlue")!, shadeColor: UIColor(named: "MainBlueShade")!)
        }
    }
}
