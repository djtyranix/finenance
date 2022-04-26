//
//  DummyDataGenerator.swift
//  finenance
//
//  Created by Michael Ricky on 26/04/22.
//

import Foundation

class DummyDataGenerator {
    func getLatestTransaction() -> [Transcation] {
        var array = [Transcation]()
        
        array.append(Transcation(name: "Cafe Bills",
                                 amount: 45000,
                                 date: Date(),
                                 category: .fnb,
                                 type: .expense
                                )
        )
        
        array.append(Transcation(name: "Credit Card Bills",
                                 amount: 1500000,
                                 date: Date(),
                                 category: .bills,
                                 type: .expense
                                )
        )
        
        array.append(Transcation(name: "Buying Earphone",
                                 amount: 100000,
                                 date: Date(),
                                 category: .leisure,
                                 type: .expense
                                )
        )
        
        array.append(Transcation(name: "Paying Friend",
                                 amount: 50000,
                                 date: Date(),
                                 category: .other,
                                 type: .expense
                                )
        )
        
        return array
    }
}
