//
//  YHYHud.swift
//  IOS Inn App Purchase Example
//
//  Created by Ucdemir on 6.09.2021.
//
import UIKit

class YHYHud: UIView,UIGestureRecognizerDelegate {
    
    
    var bezelText = "Loading..."
    
    
   static let shared = YHYHud()
    
    
    let bezelView = UIView()
    let indicator = UIActivityIndicatorView()
    let hudText = UILabel()
    
    //weak var superView : UIView?
    
    
    private init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    

    func initHud(rootView : UIView){
        
        //superView = rootView
      
        self.frame = CGRect(x: 0, y: 0, width: rootView.frame.width, height: rootView.frame.height)
        let bezelWidth = self.frame.width/6*2.3
        let textWidth =  bezelWidth - 4
         let bezelHeight = bezelText.height(withConstrainedWidth: textWidth, font: hudText.font)
        
        
        self.bezelView.frame = CGRect(x: ((rootView.frame.width)/2)-(bezelWidth/2), y: ((rootView.frame.height)/2 )-((rootView.frame.width)/8) , width: bezelWidth, height: bezelHeight + 70)
        
        self.indicator.frame = CGRect(x: self.bezelView.frame.width/2-13, y: bezelHeight/2 + 35 - 26, width: 26, height: 26)
        self.indicator.color = UIColor.white
       // self.indicator.backgroundColor = UIColor.black
        
       
      self.hudText.frame = CGRect(x: 0, y: bezelHeight/2 + 40, width:textWidth , height: bezelHeight )
        
        self.hudText.textColor = UIColor.white
        self.hudText.text = bezelText
        self.hudText.textAlignment = .center
        self.hudText.font = self.hudText.font.withSize(14.0)
        
        self.bezelView.addSubview(self.indicator)
        self.bezelView.addSubview(self.hudText)
        
        self.bezelView.backgroundColor = UIColor(rgb: 0x000000, alpha: 1)
        
        //self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor(rgb: 0x262626, alpha: 0.53)
        
     
        self.bezelView.layer.cornerRadius = 14
        
        self.addSubview(self.bezelView)
        self.bringSubviewToFront(bezelView)
        
       // self.backgroundColor = UIColor.clear
        
     /*   self.addSubview(indicator)
        self.bringSubviewToFront(indicator)*/
        
        rootView.addSubview(self)
        rootView.bringSubviewToFront(self)
      
        //rootView.bringSubviewToFront(self.bezelView)
        
        indicator.startAnimating()
        self.addBezelTapGesture()
    }
    
    func addBezelTapGesture(){
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.bezelViewClicked))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGesture)
        self.bezelView.isUserInteractionEnabled = true
        
    }
    
    @objc func bezelViewClicked(){
        self.removeFromSuperview()
        
        //RKDropdownAlert.title("Yükleme", message: "Veriler hâlâ yükleniyor...",backgroundColor: UIColor(rgb: 0x753A3A),textColor: UIColor.white)
    }
    
   
    func hideHud(){
         self.removeFromSuperview()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
         for view in self.subviews {
              if view.isUserInteractionEnabled, view.point(inside: self.convert(point, to: view), with: event) {
                  return true
              }
          }

          return false
    }
    
    
    
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
    convenience init(red: Int, green: Int, blue: Int, alpha : CGFloat) {
          assert(red >= 0 && red <= 255, "Invalid red component")
          assert(green >= 0 && green <= 255, "Invalid green component")
          assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
      }
    
    
   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
    convenience init(rgb: Int, alpha : CGFloat) {
          self.init(
              red: (rgb >> 16) & 0xFF,
              green: (rgb >> 8) & 0xFF,
              blue: rgb & 0xFF,
              alpha: alpha
            
          )
      }
}
extension String{
    
    
 // MARK: - Calculate Label text Height & width
        func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

            return ceil(boundingBox.height)
        }

}
