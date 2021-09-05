//
//  BuyProductsVC.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 5.09.2021.
//

import UIKit
import StoreKit

class BuyProductsVC: UIViewController {
    
    
    
    @IBOutlet weak var btnBor: UIButton!
    @IBOutlet weak var btnGas: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnPro: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.GetPriceProducts).pricesOfProducts(){ success , products in
        
                
                
                for p in products! {
                    if p.productIdentifier == "sku.bor" {
                        //self.product = p
                        
                        self.btnBor.setTitle(self.setPriceText(product: p), for: .normal)
                        
                        //self.setPriceOfLicense(price: p.price.floatValue)
                        //self.isReady = true
                        
                    }else if  p.productIdentifier == "sku.gas" {
                        self.btnGas.setTitle(self.setPriceText(product: p), for: .normal)
                        
                    }else if  p.productIdentifier == "sku.noads" {
                        self.btnNoAds.setTitle(self.setPriceText(product: p), for: .normal)

                    }else if  p.productIdentifier == "sku.pro" {
                        self.btnNoAds.setTitle(self.setPriceText(product: p), for: .normal)

                    }else if  p.productIdentifier == "sku.sun" {
                        self.btnSun.setTitle(self.setPriceText(product: p), for: .normal)

                        
                    }
                    
                    //YHYHud.shared.hideHud()
                    //print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                    //print(2)
                }
                
            }
        
    }
    

  
    @IBAction func ActionGoToLibraryPage(_ sender: Any) {
        
        guard let url = URL(string: "https://github.com/Ucdemir/Ucdemir-IOS-Inn_App_Purchase") else { return }
        UIApplication.shared.open(url)
        
    }
    
    
    
    @IBAction func actionBuyBor(_ sender: Any) {
        
    }
    
    
    @IBAction func actionBuyGas(_ sender: Any) {
        
    }
    
    
    @IBAction func actionBuyNoAds(_ sender: Any) {
        
        
    }
    
    @IBAction func actionBuyPro(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func actionBuySun(_ sender: Any) {
        
        
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        
        navigationController?.popToViewController(ofClass: BuyProductsVC.self)
    }
    
    func setPriceText(product : SKProduct )-> String {
        let numberFormatter = NumberFormatter()
             numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
             numberFormatter.numberStyle = .currency
             //numberFormatter.locale = self.product.priceLocale
        let formattedPrice: String? = numberFormatter.string(from: (product.price))
             
        
        return formattedPrice!
        //self.btnPro.setTitle("SATIN AL\n(\(formattedPrice!))", for: .normal)
    }
    
}
