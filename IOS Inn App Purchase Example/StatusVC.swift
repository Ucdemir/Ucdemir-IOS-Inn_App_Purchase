//
//  ViewController.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 4.09.2021.
//

import UIKit



let listOfApplicationSKU : Set = ["sku.bor","sku.gas","sku.noads","sku.pro","sku.sun"]

class StatusVC: UIViewController {
    
    
    
    
    
    @IBOutlet weak var lblBorChecking: UILabel!
    @IBOutlet weak var lblGasChecking: UILabel!
    @IBOutlet weak var lblNoAdsChecking: UILabel!
    @IBOutlet weak var lblProChecking: UILabel!
    @IBOutlet weak var lblSunChecking: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let x = ConnectToApple.shared.checkIsFreshStart()
        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.CheckProductStatus).statusOfProducts(){ status in
                
                
                
                for row in status{
                    
                    if row.productIdentifier == "sku.bor" {
                        
                        
                        
                        self.lblBorChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.gas" {
                        
                        self.lblGasChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.noads" {
                        self.lblNoAdsChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.pro" {
                        self.lblProChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.sun" {
                        self.lblSunChecking.text = row.isPurchased.description
                        
                        
                        
                    }
                    print("YHY : \(row.productIdentifier) : Status : \(BillingDB.shared.whatIsStatus(skuName: row.productIdentifier))")
                }
            
            }
    
        
    }
    @IBAction func actionGoToBuyProduct(_ sender: Any) {
        
        
        performSegue(withIdentifier: "goToProVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}
