//
//  ViewController.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 4.09.2021.
//

import UIKit



let listOfApplicationSKU : Set = ["sku.bor","sku.gas","sku.noads","sku.pro","sku.sun"]

class StatusVC: UIViewController {
    
    
    
    
    //Consumable
    @IBOutlet weak var lblAChecking: UILabel!
    @IBOutlet weak var lblBChecking: UILabel!
    @IBOutlet weak var lblCChecking: UILabel!
    @IBOutlet weak var lblDChecking: UILabel!
   
    
    //NON - Consumable
    @IBOutlet weak var lblEChecking: UILabel!
    @IBOutlet weak var lblFChecking: UILabel!
    @IBOutlet weak var lblGChecking: UILabel!
    @IBOutlet weak var lblHChecking: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let x = ConnectToApple.shared.checkIsFreshStart()
        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.CheckProductStatus).statusOfProducts(){ status in
                
                
                
                for row in status{
                    
                    if row.productIdentifier == "sku.A" {
                        
                        
                        
                        self.lblAChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.B" {
                        
                        self.lblBChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.C" {
                        self.lblCChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.D" {
                        self.lblDChecking.text = row.isPurchased.description
                        
                        
                    }else if  row.productIdentifier == "sku.E" {
                        self.lblEChecking.text = row.isPurchased.description
                        
                        
                        
                    }else if  row.productIdentifier == "sku.F" {
                        self.lblFChecking.text = row.isPurchased.description
                        
                        
                        
                    }else if  row.productIdentifier == "sku.G" {
                        self.lblGChecking.text = row.isPurchased.description
                        
                        
                        
                    }else if  row.productIdentifier == "sku.H" {
                        self.lblHChecking.text = row.isPurchased.description
                        
                        
                        
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
