//
//  BuyProductsVC.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 5.09.2021.
//

import UIKit
import StoreKit
import RKDropdownAlert
//import RKDropdownAlert


class BuyProductsVC: UIViewController {
    
    
    //Consumable
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    @IBOutlet weak var btnD: UIButton!
    

    //NON - Consumable
    @IBOutlet weak var btnE: UIButton!
    @IBOutlet weak var btnF: UIButton!
    @IBOutlet weak var btnG: UIButton!
    @IBOutlet weak var btnH: UIButton!

    
    var buyProductDic: [String: SKProduct] = [:]
    
    var isReady = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        YHYHud.shared.initHud(rootView: self.view)

        
        ConnectToApple.shared.billingSKUS(listApplicationSKU: listOfApplicationSKU)
            .startToWork(type: ConnectToApple.CallType.GetPriceProducts).pricesOfProducts(completionHandler: { success , products in
        
           
                
                    
                    for p in products! {
                        
                            
                            if p.productIdentifier == "sku.A" {
                                //self.product = p
                                
                                
                                self.btnA.setTitle(self.setPriceText(product: p), for: .normal)
                                
                                //self.setPriceOfLicense(price: p.price.floatValue)
                                
                                
                            }else if  p.productIdentifier == "sku.B" {
                                self.btnB.setTitle(self.setPriceText(product: p), for: .normal)
                                
                            }else if  p.productIdentifier == "sku.C" {
                                self.btnC.setTitle(self.setPriceText(product: p), for: .normal)
                                
                            }else if  p.productIdentifier == "sku.D" {
                                self.btnD.setTitle(self.setPriceText(product: p), for: .normal)
                                
                            }else if  p.productIdentifier == "sku.E" {
                                self.btnE.setTitle(self.setPriceText(product: p), for: .normal)
                                
                                
                            }else if  p.productIdentifier == "sku.F" {
                                self.btnF.setTitle(self.setPriceText(product: p), for: .normal)
                                
                                
                            }else if  p.productIdentifier == "sku.G" {
                                self.btnG.setTitle(self.setPriceText(product: p), for: .normal)
                                
                                
                            }else if  p.productIdentifier == "sku.H" {
                                self.btnH.setTitle(self.setPriceText(product: p), for: .normal)
                                
                                
                            }
                            
                        
                    YHYHud.shared.hideHud()
                    self.buyProductDic[p.productIdentifier] = p
                    
                   
                }
                
            }
            ).shouldRestartApp(shouldRestartApp: false).boughtProduct(){  productIdentifier, isBought in
                
                if isBought{
                    self.showToastMsg(title : "Success",message: "License Loaded... Re-Open App")
                    //ConnectToApple.shared.quitApp()
                    
                }else{
                    self.showToastMsg(title: "Fail..", message: "Purchase failed")
                }
                
               
            }
        
    }
     
  
    @IBAction func ActionGoToLibraryPage(_ sender: Any) {
        
        guard let url = URL(string: "https://github.com/Ucdemir/Ucdemir-IOS-Inn_App_Purchase") else { return }
        UIApplication.shared.open(url)
        
    }
    
    
    
    @IBAction func actionBuyA(_ sender: Any) {
        
        

        
        ConnectToApple.shared.buyProduct(buyProductDic["sku.A"]! )
        
    }
    
    
    @IBAction func actionBuyB(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.B"]!)
    }
    
    
    @IBAction func actionBuyC(_ sender: Any) {
        
        ConnectToApple.shared.buyProduct(buyProductDic["sku.C"]!)
    }
    
    @IBAction func actionBuyD(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.D"]!)
        
    }
    
    
    @IBAction func actionBuyE(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.E"]!)
    }
    @IBAction func actionBuyF(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.F"]!)
        
    }
    @IBAction func actionBuyG(_ sender: Any) {
        ConnectToApple.shared.buyProduct(buyProductDic["sku.G"]!)
    }
    
    @IBAction func actionBuyH(_ sender: Any) {
       ConnectToApple.shared.buyProduct(buyProductDic["sku.H"]!)
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
