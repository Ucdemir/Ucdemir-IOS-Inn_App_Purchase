//
//  ConnectToApple.swift
//  YHY IOS In App Billing
//
//  Created by Ucdemir on 5.09.2021.
//

import Foundation
import StoreKit


public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()
public typealias ProductBoughtCompletionHandler = ( _ productIdentifier: String? , _ isBought: Bool) -> ()

struct SKProductStatus {
    let productIdentifier : String
    let isPurchased : Bool
    
}

class ConnectToApple: NSObject,SKProductsRequestDelegate{
    
    static let shared = ConnectToApple()
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    
    var listApplicationSKU = Set<String>()
    var listProductsStatus = Set<SKPaymentTransaction>()
    
    public typealias ProductStatusCompletionHandler = (_ productsStatus: [SKProductStatus]) -> ()

   
    
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    fileprivate var productBoughtCompletionHandler: ProductBoughtCompletionHandler?

    
    fileprivate var productStatus : ProductStatusCompletionHandler?
    
    

    
    public enum CallType{
        case GetPriceProducts
        case CheckProductStatus
    }
    
    private override init() {
        
    }
    
    // MARK: - Class Functions
    func  billingSKUS( listApplicationSKU : Set<String>)-> ConnectToApple{
        
        self.listApplicationSKU = listApplicationSKU
        
        return .shared
        
    }
    
    
    func startToWork(type : CallType)-> ConnectToApple{
        
        switch type {
        case .GetPriceProducts:
            getPriceOfAllProduct()

        case.CheckProductStatus:
            
            getProductStatus()
        default:
            print(3)
        }
        
        return .shared
    }
    
  
    
    //Equivalent to Our Android Library getCachedQueryList
    func getPriceOfAllProduct(){
        productsRequest?.cancel()
    
        
        productsRequest = SKProductsRequest(productIdentifiers: listApplicationSKU)
        productsRequest!.delegate = self
        productsRequest!.start()
        
        
    }
    
    public func buyProduct(_ product: SKProduct) {
      
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func getProductStatus() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // clear for new request
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
        productsRequestCompletionHandler = nil
        productStatus = nil
    }
    
    
    public func checkIsFreshStart() -> Bool{
        
        let userDefaults = UserDefaults.standard
        
        let isFreshStart = userDefaults.object(forKey:  "isFreshStart")
        
        if isFreshStart == nil{
            userDefaults.set(true, forKey: "isFreshStart")
            
            return true
        }else{
            
            
            return false
        }
        
    
    }
    
    

    
    // MARK: - Delegate - SKProductsRequestDelegate
    // This func called after getProductStatus... its delegate function
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        let products = response.products
        
        productsRequestCompletionHandler?(true, products)
        
        clearRequestAndHandler()
        
    }
    
}




extension ConnectToApple: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        listProductsStatus.removeAll()
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                
                break
            case .failed:
                fail(transaction: transaction)
                
                
                break
            case .restored:
                
                restore(transaction: transaction)
             
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
        
        productStatus?(initializeProductsStatusArray())
        clearRequestAndHandler()
    
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
  
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    
        //item bought
        productBoughtCompletionHandler?(transaction.payment.productIdentifier, true)
        
        clearRequestAndHandler()
    
    }
    
    private func restore(transaction: SKPaymentTransaction) {
       
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        // state of product
        let state = transaction.original?.transactionState
        
        if state == SKPaymentTransactionState.purchased{
            listProductsStatus.insert(transaction)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
            
        }
        
        //fail
        productBoughtCompletionHandler?(transaction.payment.productIdentifier, false)
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
         guard let identifier = identifier else { return }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConnectToApple.IAPHelperPurchaseNotification) , object: identifier)
    }
    
    
    
    func initializeProductsStatusArray() -> [SKProductStatus] {
        
        var array = [SKProductStatus]()
        
        if !checkIsFreshStart(){
        
        a: for  row in listApplicationSKU {
            
            
             for row2 in listProductsStatus{
                
                if row == row2.original?.payment.productIdentifier{
                    
                    array.append(SKProductStatus(productIdentifier: row, isPurchased: true))
                    continue a
                    
                }
            }
            
            array.append(SKProductStatus(productIdentifier: row, isPurchased: false))
            
        }
        }else{
            
            for  row in listApplicationSKU {
                array.append(SKProductStatus(productIdentifier: row, isPurchased: true))
            }
            
        }
        
        
        return array
        
    }
    
    
}

//Below funstions is like  java listener
extension ConnectToApple{
    func pricesOfProducts(completionHandler: @escaping ProductsRequestCompletionHandler) -> ConnectToApple{
        
        productsRequestCompletionHandler = completionHandler
        
        return self
    }
    
    func statusOfProducts(completionHandler: @escaping  ProductStatusCompletionHandler){
        
        productStatus = completionHandler
        
    }
    func boughtProduct(completionHandler: @escaping ProductBoughtCompletionHandler){
        
        productBoughtCompletionHandler = completionHandler
        
    }
    
}
