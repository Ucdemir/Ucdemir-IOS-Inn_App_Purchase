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
