//
//  DummyDataGenerator.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import Foundation

class DummyDataGenerator {
    func getLatestTransaction() -> [Transaction] {
        var array = [Transaction]()
        
        array.append(Transaction(name: "Cafe Bills",
                                 amount: 45000,
                                 date: Date(),
                                 category: .fnb
                                )
        )
        
        array.append(Transaction(name: "Credit Card Bills",
                                 amount: 1500000,
                                 date: Date(),
                                 category: .bills
                                )
        )
        
        array.append(Transaction(name: "Buying Earphone",
                                 amount: 100000,
                                 date: Date(),
                                 category: .leisure
                                )
        )
        
        array.append(Transaction(name: "Paying Friend",
                                 amount: 50000,
                                 date: Date(),
                                 category: .other
                                )
        )
        
        return array
    }
}
