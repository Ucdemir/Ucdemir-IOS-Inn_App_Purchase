//
//  BillingDB.swift
//  YHY IOS In App Billing
//
//  Created by Ucdemir on 8.09.2021.
//
import Foundation
import SQLite



class BillingDB{
    
    // MARK: - Properties
    private var db: Connection?
    static let shared = BillingDB()
    
    // MARK: - Table Pro
    let tablePRO = Table("TablePro")
    let tbPROId = Expression<Int64>("ProId")
    let tbIsBought = Expression<Bool>("isBought")
    let tbProductName = Expression<String>("ProProductName")
    
    
    
    // MARK: - DB Functions
    private init(){
        do {
            // Get database path
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                // Connect to database
                
                print("here is current path : \(path)")
                db = try Connection("\(path)/db.sqlite3")
                
                
                try db?.run(tablePRO.create(ifNotExists: true) { table in
                    
                    table.column(tbPROId, primaryKey: .autoincrement)
                    table.column(tbIsBought)
                    table.column(tbProductName)
                    
                })
                
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Pro DB
    func whatIsStatus(skuName : String )-> Bool{
        var result = false
        
        do{
            
            let sql = "Select isBought from TablePro where ProProductName = '\(skuName)'"
            for row in try db!.prepare(sql) {
               
                 result = (row[0] as! Int64).boolValue
                
            
                print(2)
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        return result
        // return true
    }
    
    
    
    func updateStatus(productId : String,status : Bool){
        
        let filteredDB = tablePRO.filter(tbProductName == productId)
        do {
            
            try db?.run(filteredDB.update(tbIsBought <- status))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    //--- Yeni yazilanlar
    /*func getCountOfSKU(productName : String)-> Int64{
        var result = false
        var count : Int64 = 0
        do{
            
            let sql = "Select count(*) from TablePro where ProProductName = \(productName)"
            for row in try db!.prepare(sql) {
                count = row[0] as! Int64
            }
            
            
            
            
            
        } catch {
            print(error.localizedDescription)
        }
        
        return count
    }*/
    
    
    func insertSkuToPro(productName : String){
        do {
            
            try db?.run(tablePRO.insert(or: .replace, tbIsBought <- false, tbProductName <- productName))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func checkProductIsOnSqliteIfNotInsertIt(skuName : String ){

        var count : Int64 = 0
        do{
            
            let sql = "Select count(*) from TablePro where ProProductName = '\(skuName)'"
            for row in try db!.prepare(sql) {
                count = row[0] as! Int64
                
                if (count < 1){
                    
                    insertSkuToPro(productName: skuName)
                    
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func checkAllSkuIsOnDB(skus:  Set<String>){
        
    
        for row in skus{
            checkProductIsOnSqliteIfNotInsertIt(skuName: row)
        }
        
        
    }
    
    
}
extension Int64 {
    var boolValue: Bool {
        return (self as NSNumber).boolValue
    }
}
