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
        print("Buying \(product.productIdentifier)...")
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
    

    
    // MARK: - Delegate - SKProductsRequestDelegate
    // this func called after getProductStatus... its delegate function
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        let products = response.products
        //print("Loaded list of products...")
        
        productsRequestCompletionHandler?(true, products)
        
        clearRequestAndHandler()
        
        /*for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
            print(2)
         }*/
        
    }
    
 
    
    // clear for new request
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
    
}




extension ConnectToApple: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                
                break
            case .failed:
                fail(transaction: transaction)
                
                
                break
            case .restored:
                listProductsStatus.removeAll()
                restore(transaction: transaction)
                productStatus!(initializeProductsStatusArray())
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
        
   
   
    
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
        //guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
     
        
        //01.09.2021 alttakını cek et
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
        if transaction.payment.productIdentifier == "yaz_kosesi_pro" {
            let msg = ["Msg": "Lisans yüklendi!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showToastMsg"), object: nil, userInfo: msg)
        }else if transaction.payment.productIdentifier == "test" {
            let msg = ["Msg": "Lisans yüklendi!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showToastMsg"), object: nil, userInfo: msg)
        }
    }
    
    private func restore(transaction: SKPaymentTransaction) {
       
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        // state of product
        let state = transaction.original?.transactionState
        
        if state == SKPaymentTransactionState.purchased{
            listProductsStatus.insert(transaction)
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        /*if productIdentifier == "yaz_kosesi_pro" {
            let msg = ["Msg": "Lisans yüklendi!"]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showToastMsg"), object: nil, userInfo: msg)
        }*/
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
            
        }
        let msg = ["Msg": "İşlem gerçekleştirilemedi!"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showToastMsg"), object: nil, userInfo: msg)
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    //Bu kısmı iki yer kullanıyor cek et
    private func deliverPurchaseNotificationFor(identifier: String?) {
         guard let identifier = identifier else { return }
        
        //purchasedProductIdentifiers.insert(identifier)
        //UserDefaults.standard.set(true, forKey: identifier)
         //UserDefaults.standard.synchronize()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConnectToApple.IAPHelperPurchaseNotification) , object: identifier)
    }
    
    
    
    func initializeProductsStatusArray() -> [SKProductStatus] {
        
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
        
        
        return array
        
    }
    
    
}


extension ConnectToApple{
    func pricesOfProducts(completionHandler: @escaping ProductsRequestCompletionHandler){
        
        productsRequestCompletionHandler = completionHandler
    }
    
    func statusOfProducts(completionHandler: @escaping  ProductStatusCompletionHandler){
        
        productStatus = completionHandler
        
    }
    
    
    
}
