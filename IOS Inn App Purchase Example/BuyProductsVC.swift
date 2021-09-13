//
//  BuyProductsVC.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 5.09.2021.
//

import UIKit
import StoreKit
import RKDropdownAlert

class BuyProductsVC: UIViewController {
    
    
    
    @IBOutlet weak var btnBor: UIButton!
    @IBOutlet weak var btnGas: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnPro: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    
    
    var buyProductDic: [String: SKProduct] = [:]
    
    var isReady = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        YHYHud.shared.initHud(rootView: self.view)

        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.GetPriceProducts).pricesOfProducts(completionHandler: { success , products in
        
                for p in products! {
                    if p.productIdentifier == "sku.bor" {
                        //self.product = p
                        
                        self.btnBor.setTitle(self.setPriceText(product: p), for: .normal)
                        
                        //self.setPriceOfLicense(price: p.price.floatValue)
                      
                        
                    }else if  p.productIdentifier == "sku.gas" {
                        self.btnGas.setTitle(self.setPriceText(product: p), for: .normal)
                        
                    }else if  p.productIdentifier == "sku.noads" {
                        self.btnNoAds.setTitle(self.setPriceText(product: p), for: .normal)

                    }else if  p.productIdentifier == "sku.pro" {
                        self.btnPro.setTitle(self.setPriceText(product: p), for: .normal)

                    }else if  p.productIdentifier == "sku.sun" {
                        self.btnSun.setTitle(self.setPriceText(product: p), for: .normal)

                        
                    }
                    
                    self.isReady = true
                    self.buyProductDic[p.productIdentifier] = p
                    
                    //YHYHud.shared.hideHud()
                    //print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                    //print(2)
                }
                YHYHud.shared.hideHud()
            }
            ).boughtProduct(){  productIdentifier, isBought in
                
                if isBought{
                    self.showToastMsg(title : "Success",message: "License Loaded... Re-Open App")
                    ConnectToApple.shared.quitApp()
                    
                }else{
                    self.showToastMsg(title: "Fail..", message: "")
                }
                
               
            }
        
    }
    

  
    @IBAction func ActionGoToLibraryPage(_ sender: Any) {
        
        guard let url = URL(string: "https://github.com/Ucdemir/Ucdemir-IOS-Inn_App_Purchase") else { return }
        UIApplication.shared.open(url)
        
    }
    
    
    
    @IBAction func actionBuyBor(_ sender: Any) {
        
        ConnectToApple.shared.buyProduct(buyProductDic["sku.bor"]! )
        
    }
    
    
    @IBAction func actionBuyGas(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.gas"]!)
    }
    
    
    @IBAction func actionBuyNoAds(_ sender: Any) {
        
        ConnectToApple.shared.buyProduct(buyProductDic["sku.noads"]!)
    }
    
    @IBAction func actionBuyPro(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.pro"]!)
        
    }
    
    
    
    @IBAction func actionBuySun(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.sun"]!)
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
    
    func showToastMsg(title : String, message : String) {
        
        
        RKDropdownAlert.show()
        RKDropdownAlert.title(title, message: message,backgroundColor: UIColor(rgb: 0x753A3A),
                              textColor: UIColor.white)
        
        
       print("YHY Bilgilendirme \(message)")
        
    }
    
}
