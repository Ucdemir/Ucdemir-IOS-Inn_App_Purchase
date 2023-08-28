# IOS-Inn_App_Purchase
**Yeşil Hilal Yazilim : As your service, Develop Future**
**Only Non-Consumable Products Supported **

* Subscription  will be supported future!
* Library use Sqlite for your products, You don’t need implementation to check status of your products.
* Library checks your products status on every time application starts. You can see.

# Read Carefully : 
* At fresh installation of your app, every products return as true (success) for better user experience. After the re-launch of your application, you will get real status of your app products.

### RootViewController:
Create 'Set' String which is product identifiers
* example
 ```Swift
          let listOfApplicationSKU : Set = ["sku.bor","sku.gas","sku.noads","sku.pro","sku.sun"]
```
Call ConnectToApple with Enum parameter CallType.CheckProductStatus in your RootViewController. This method returns your products statuses.

```Swift

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
    
```
**Note: "ConnectToApple.CallType" function have below enum parameters***
```Swift


 public enum CallType{
        case GetPriceProducts
        case CheckProductStatus
    }

```

**Use  CheckProductStatus in your RootVC**

**Use GetPriceProducts in buying ViewController**


**You can check product status with below functions: 

```Swift
BillingDB.shared.whatIsStatus(skuName: productIdentifier)
```


Use this for getting prices of your products.
```Swift
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
            
```
