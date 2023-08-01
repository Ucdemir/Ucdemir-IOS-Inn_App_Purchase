//
//  ConnectToApple.swift
//  YHY IOS In App Billing
//
//  Created by Ucdemir on 5.09.2021.
//

import Foundation
import StoreKit

var isFreshStart = false
var firstProductsReturnTrue = false

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()
public typealias ProductBoughtCompletionHandler = ( _ productIdentifier: String? , _ isBought: Bool) -> ()
public typealias ProductStatusCompletionHandler = (_ productsStatus: [SKProductStatus]) -> ()

public struct SKProductStatus {
    public  let productIdentifier : String
    public let isPurchased : Bool
    
}

public class ConnectToApple: NSObject,SKProductsRequestDelegate {
    
    public static let shared = ConnectToApple()
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    
  private  var listApplicationSKU = Set<String>()
    private var listProductsStatus = Set<SKPaymentTransaction>()
    
    
    
    
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
    /*
        This function pass skus to library
     */
   public func  billingSKUS( listApplicationSKU : Set<String>)-> ConnectToApple{
        
       self.listApplicationSKU = listApplicationSKU
        
       /* Below one no need like Android
        
       if checkIsFreshStart() == true{
           
       }*/
       
       BillingDB.shared.checkAllSkuIsOnDB(skus: listApplicationSKU)
        
        return .shared
        
    }
    
    
    public func startToWork(type : CallType)-> ConnectToApple{
        
        switch type {
        case .GetPriceProducts:
            getPriceOfAllProduct()
            
        case.CheckProductStatus:
            
            getProductStatus()
      
        }
        
        return .shared
    }
    
    
    
    /*Equivalent to Our Android Library getCachedQueryList
     ios -> library -> func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler)
     */
    private func getPriceOfAllProduct(){
        productsRequest?.cancel()
        
        
        productsRequest = SKProductsRequest(productIdentifiers: listApplicationSKU)
        productsRequest!.delegate = self
        productsRequest!.start()
        
        
    }
    
    public func buyProduct(_ product: SKProduct) {
        
       // let payment = SKPayment(product: product)
        //SKPaymentQueue.default().add(payment)
        
        
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
            //self.isFreshStart = true
            
            userDefaults.set(true, forKey: "isFreshStart")
            
            return true
        }else{
            
           // self.isFreshStart = false
            return false
        }
        
        
    }
    
    /*
     This function checks whether products bought or not  and it update DB
     */
    private func initializeProductsStatusArray() -> [SKProductStatus] {
        
        var array = [SKProductStatus]()
        
        a: for  row in listApplicationSKU {
            
            
            for row2 in listProductsStatus{
                
                if row == row2.original?.payment.productIdentifier{
                    
                    array.append(SKProductStatus(productIdentifier: row, isPurchased: true))
                    continue a
                    
                }
            }
            
            array.append(SKProductStatus(productIdentifier: row, isPurchased: false))
            
        }
        
        
        for row in array{
            BillingDB.shared.updateStatus(productId: row.productIdentifier,status:row.isPurchased)
        }
        
        return array
        
    }
    
    
    internal func quitApp(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
    /*
     Android mentalite ile aynı olacak... ilave parametre eklenip user seçilebilir olacak
     Ya güncellencek yada silincek
      Suan silinmiş durumda 01-08-2023*/
   /*private  func initProductsAtFreshStart()-> [SKProductStatus]{
        var array = [SKProductStatus]()
        
        for  row in listApplicationSKU {
            array.append(SKProductStatus(productIdentifier: row, isPurchased: true))
            BillingDB.shared.updateStatus(productId: row,status:true)
            
        }
        
        
        return array
    }*/

    
    
    
    
    
    // MARK: - Delegate - SKProductsRequestDelegate
    /* This func called after getProductStatus... its delegate function
     This function return products price -> came from -> getPriceOfAllProduct() - above
     */
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        let products = response.products
        
        productsRequestCompletionHandler?(true, products)
        
        clearRequestAndHandler()
        
    }
    
}



// MARK: - Delegate SKPaymentTransactionObserver
extension ConnectToApple: SKPaymentTransactionObserver {
    
    /*
     This delegate used for return product bought status. in Main VC ->
     .startToWork(type: ConnectToApple.CallType.CheckProductStatus).statusOfProducts()
     
     SKPaymentQueue.default().restoreCompletedTransactions this call  below
     
     
     https://stackoverflow.com/questions/5628710/restorecompletedtransactions-broken
     Products Consumable cannot be restored.
     Products Non-Consumable can be restored.
     Check if your products are type Non-Consumable.
     
     -- Consumables are not to be restored, just as you were reasoning in your original question. --
     */
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        //Below commented for isFreshStart
        /*if !isFreshStart{
            
            
            if queue.transactions.count == 0{
                var array = [SKProductStatus]()
                
                for  row in listApplicationSKU {
                    array.append(SKProductStatus(productIdentifier: row, isPurchased: false))
                    BillingDB.shared.updateStatus(productId: row,status:false)
                }
                productStatus?(array)
            }
        }*/
        
        /*
         New one
         */
        if queue.transactions.count == 0{
            let h = ""
            let g = ""
        }else {
            let h = ""
            let g = ""
        }

        
        
        productStatus?(initializeProductsStatusArray())
        let aa = 1
    }
    
    
    /* This is delegate function for SKPaymentTransactionObserver
     it complate and restore order  or it fail
     */
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
                
            default:
                break
            }
        }
        productStatus?(initializeProductsStatusArray())
        /*
         below Updated for isFreshStart
        if !isFreshStart{
            productStatus?(initializeProductsStatusArray())
        }*/
        
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
        
        //guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        // state of product
        let state = transaction.original?.transactionState
        
        if state == SKPaymentTransactionState.purchased{
            listProductsStatus.insert(transaction)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
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
    
    
    
    
}
// MARK: - Our Listener
//Below funstions is like  java listener
extension ConnectToApple{
    public func pricesOfProducts(completionHandler: @escaping ProductsRequestCompletionHandler) -> ConnectToApple{
        
        productsRequestCompletionHandler = completionHandler
        
        return self
    }
    
    public func statusOfProducts(completionHandler: @escaping  ProductStatusCompletionHandler){
        
        productStatus = completionHandler
      
        let test = ""
        
        
        //UPDATE - Below will be checked - 01.08.2023 commentlendi
        /*if checkIsFreshStart(){
            productStatus?(initProductsAtFreshStart())
        }*/
        
        
    }
    public func boughtProduct(completionHandler: @escaping ProductBoughtCompletionHandler){
        
        productBoughtCompletionHandler = completionHandler
        
    }
    
 
    
}
public func shouldFirstProductsReturnTrue(shouldFirstProductsReturnTrue : Bool)-> ConnectToApple{
    
    firstProductsReturnTrue = shouldFirstProductsReturnTrue
    return ConnectToApple.shared
}
