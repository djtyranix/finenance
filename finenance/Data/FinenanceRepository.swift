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
    
     private func getManagedContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObjectContext()
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.automaticallyMergesChangesFromParent = true
        
        return managedContext
    }
    
    func saveData(data: Transaction) -> Bool {
        
        let managedContext = self.getManagedContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "TransactionEntity", in: managedContext)!
        
        let transaction = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Setting Data
        let latestData = self.getLatestData()
        let currentId = latestData.id
        let nextId = currentId + 1
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
        case .income:
            category = 4
        }
        
        transaction.setValue(nextId, forKey: "id")
        transaction.setValue(data.name, forKey: "transaction_name")
        transaction.setValue(data.amount, forKey: "transaction_amount")
        transaction.setValue(category, forKey: "transaction_category")
        transaction.setValue(data.date, forKey: "transaction_date")
        
        do {
            try managedContext.save()
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
        
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            for transactionFetch in transactionFetchArray {
                let id = transactionFetch.value(forKey: "id") as! Int
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
                case 4:
                    category = .income
                default:
                    category = .other
                }
                
                let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
                transactionArray.append(transaction)
            }
            
            return transactionArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [Transaction]()
        }
    }
    
    func getLatestData() -> Transaction {
        var transactionFetchArray = [NSManagedObject]()
        
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            let transactionFetch = transactionFetchArray.first!
            
            let id = transactionFetch.value(forKey: "id") as! Int
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
            case 4:
                category = .income
            default:
                category = .other
            }
            
            let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
            return transaction
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return Transaction(id: 0, name: "Error", amount: 0, date: Date(), category: .other)
        }
    }
    
    func getAllDataOnMonth() -> [Transaction] {
        var transactionFetchArray = [NSManagedObject]()
        var transactionArray = [Transaction]()
        
        let predicate = NSPredicate(format: "transaction_date >= %@ && transaction_date <= %@", Date().startOfMonth as CVarArg, Date().endOfMonth as CVarArg)
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.predicate = predicate
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            for transactionFetch in transactionFetchArray {
                let id = transactionFetch.value(forKey: "id") as! Int
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
                case 4:
                    category = .income
                default:
                    category = .other
                }
                
                let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
                transactionArray.append(transaction)
            }
            
            return transactionArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [Transaction]()
        }
    }
    
    func getDataById(id: Int) -> Transaction {
        var transactionFetchArray = [NSManagedObject]()
        
        let predicate = NSPredicate(format: "id = %@", id as Int)
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.predicate = predicate
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            let transactionFetch = transactionFetchArray.first!
            
            let id = transactionFetch.value(forKey: "id") as! Int
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
            case 4:
                category = .income
            default:
                category = .other
            }
            
            let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
            
            return transaction
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return Transaction(id: 0, name: "Error", amount: 0, date: Date(), category: .other)
        }
    }
    
    func getDataByTypeOnMonth(category: TransactionCategory) -> [Transaction] {
        var transactionFetchArray = [NSManagedObject]()
        var transactionArray = [Transaction]()
        let categoryInt: Int
        
        switch category {
        case .fnb:
            categoryInt = 0
        case .bills:
            categoryInt = 1
        case .leisure:
            categoryInt = 2
        case .other:
            categoryInt = 3
        case .income:
            categoryInt = 4
        }
        
        let predicate = NSPredicate(format: "transaction_date >= %@ && transaction_date <= %@ && transaction_category = %i", Date().startOfMonth as CVarArg, Date().endOfMonth as CVarArg, categoryInt)
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.predicate = predicate
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            for transactionFetch in transactionFetchArray {
                let id = transactionFetch.value(forKey: "id") as! Int
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
                case 4:
                    category = .income
                default:
                    category = .other
                }
                
                let transaction = Transaction(id: id, name: name, amount: amount, date: date, category: category)
                transactionArray.append(transaction)
            }
            
            return transactionArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [Transaction]()
        }
    }
    
    func updateData(id: Int, data: Transaction) -> Bool {
        var transactionFetchArray = [NSManagedObject]()
        
        let predicate = NSPredicate(format: "id = %i", id)
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.predicate = predicate
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            if transactionFetchArray.isEmpty {
                print("Fetch Array Empty Error")
                return false
            } else {
                let transaction = transactionFetchArray.first!
                
                // Setting Data
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
                case .income:
                    category = 4
                }
                
                transaction.setValue(data.name, forKey: "transaction_name")
                transaction.setValue(data.amount, forKey: "transaction_amount")
                transaction.setValue(category, forKey: "transaction_category")
                transaction.setValue(data.date, forKey: "transaction_date")
                
                try managedContext.save()
                
                print("Data updated")
                return true
            }
            
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteData(id: Int) -> Bool {
        var transactionFetchArray = [NSManagedObject]()
        
        let predicate = NSPredicate(format: "id = %i", id)
        let managedContext = self.getManagedContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionEntity")
        fetchRequest.predicate = predicate
        
        do {
            transactionFetchArray = try managedContext.fetch(fetchRequest)
            
            if transactionFetchArray.isEmpty {
                print("Fetch Array Empty Error")
                return false
            } else {
                let transaction = transactionFetchArray.first!
                
                managedContext.delete(transaction)
                try managedContext.save()
                
                print("Data deleted")
                return true
            }
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func destroyDatabase() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = self.getManagedContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TransactionEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDelegate.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
            return true
        } catch let error as NSError {
            print("Could not destroy database. \(error), \(error.userInfo)")
            return false
        }
    }
}
