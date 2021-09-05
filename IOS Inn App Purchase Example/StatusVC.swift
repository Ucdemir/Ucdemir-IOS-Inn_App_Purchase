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
        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.CheckProductStatus).statusOfProducts(){ status in
        
               
                
             
                
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
