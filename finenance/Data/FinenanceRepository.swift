//
//  FinenanceRepository.swift
//  finenance
//
//  Created by Michael Ricky on 28/04/22.
//

import UIKit
import CoreData

class FinenanceRepository: NSObject {
    
    struct Static {
        static var instance: FinenanceRepository?
    }
    
    class var sharedInstance: FinenanceRepository {
        if Static.instance == nil {
            Static.instance = FinenanceRepository()
        }
        
        return Static.instance!
    }
    
    func disposeSingleton() {
        FinenanceRepository.Static.instance = nil
        print("FinenanceRepository Disposed")
    }
    
    func saveData(data: Transaction) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: managedContext)!
        
        let transaction = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Setting Data
        var currentId = UserDefaults.standard.value(forKey: "nextId") as? Int ?? 0
        let category: Int
        
        switch data.category {
        case .fnb:
            category = 0
        case .bills:
            category = 1
        case .leisure:
            category = 2
        case .other:
            category = 3
        }
        
        transaction.setValue(currentId, forKey: "id")
        transaction.setValue(data.name, forKey: "transaction_name")
        transaction.setValue(data.amount, forKey: "transaction_amount")
        transaction.setValue(category, forKey: "transaction_category")
        transaction.setValue(data.date, forKey: "transaction_date")
        
        do {
            try managedContext.save()
            currentId += 1
            UserDefaults.standard.set(currentId, forKey: "nextId")
            print("Data saved")
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getAllData() -> [Transaction] {
        var transactionFetchArray = [NSManagedObject]()
        var transactionArray = [Transaction]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [Transaction]()
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            for transactionFetch in transactionFetchArray {
                let name = transactionFetch.value(forKey: "transaction_name") as! String
                let amount = transactionFetch.value(forKey: "transaction_amount") as! Int
                let date = transactionFetch.value(forKey: "transaction_date") as! Date
                let categoryId = transactionFetch.value(forKey: "transaction_category") as! Int
                let category: TransactionCategory
                
                switch categoryId {
                case 0:
                    category = .fnb
                case 1:
                    category = .bills
                case 2:
                    category = .leisure
                case 3:
                    category = .other
                default:
                    category = .other
                }
                
                let transaction = Transaction(name: name, amount: amount, date: date, category: category)
                transactionArray.append(transaction)
            }
            
            return transactionArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [Transaction]()
        }
    }
}
