//
//  GvAlertView.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/3/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

open class GvAlertView: UIViewController {

    let kBackgroundTransparentcy:CGFloat = 0.7
 
    let kTopMargin:CGFloat = 50.0
    let kLeftMargin:CGFloat = 50.0
    let kMaxHeight:CGFloat = 210.0
    var kContentWidth:CGFloat = 400.0
    let kButtonHeight:CGFloat = 51.0
    let kButtonWidth:CGFloat = 125.0
    let kButtonSpace:CGFloat = 20.0
    var strongSelf:GvAlertView?
    var contentView = UIView()
    var titleImageView:UIImageView = UIImageView()
    var userAction:((_ btnIndex:Int)->Void)? = nil
    
    
    //Init View
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.main.bounds
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: kBackgroundTransparentcy)
        self.view.addSubview(contentView)
        contentView.frame = CGRect(x: (self.view.frame.width - kContentWidth) / 2.0, y: (self.view.frame.height - kMaxHeight) / 2.0, width: kContentWidth, height: kMaxHeight)
        contentView.backgroundColor = UIColor.colorFromRGB(0xFFFFFF)
        strongSelf = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc open func pressed(_ sender:UIButton){
        self.closeDialog(sender.tag)
    }
    
    func closeDialog(_ btnIndex:Int){
        userAction?(btnIndex)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.view.alpha = 0.0
            }) { (Bool) -> Void in
                self.view.removeFromSuperview()
                self.contentView.removeFromSuperview()
                self.contentView = UIView()
                //Releasing strong refrence of itself.
                self.strongSelf = nil
        }
    }
    
    func showDialog(_ titleImageName:String, isBtnCancel:Bool, bgImageName:String?, action:((_ btnIndex:Int)->Void)?){
        userAction = action
        
        //Create outer view and bring it to the top
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self.view)
        window.bringSubview(toFront: self.view)
        view.frame = window.bounds
        var y = kTopMargin
        let x = kLeftMargin
        
        if(bgImageName != nil){
            let bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
            bgImage.image = UIImage(named: bgImageName!)!
            contentView.addSubview(bgImage)
        }
        
        
        //Set title image
        let titleImage = UIImage(named: titleImageName)!
        self.titleImageView.frame = CGRect(x: x, y: y, width: kContentWidth - x*2, height: titleImage.size.height)
        self.titleImageView.image = titleImage
        contentView.addSubview(titleImageView)
        
        y += titleImage.size.height + 30.0
        
        
        //Set btn cancel
        if(isBtnCancel){
            let btnCancelImage = UIImage(named: "btn_dialog_cancel.png")!
            let btnCancel = UIButton(frame:CGRect(x: x + kButtonSpace, y: y, width: kButtonWidth, height: kButtonHeight))
            btnCancel.setBackgroundImage(btnCancelImage, for: UIControlState())
            btnCancel.tag = 1
            btnCancel.addTarget(self, action: #selector(GvAlertView.pressed(_:)), for: UIControlEvents.touchUpInside)
            self.contentView.addSubview(btnCancel)
        }
        
        //Set button ok
        let btnOk = UIButton(frame: CGRect(x: x + kButtonSpace*2 + kButtonWidth, y: y, width: kButtonWidth, height: kButtonHeight))
        btnOk.tag = 0
        btnOk.setBackgroundImage(UIImage(named: "btn_dialog_ok.png")!, for: UIControlState())
        btnOk.addTarget(self, action: #selector(GvAlertView.pressed(_:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(btnOk)
        self.animateDialog()
    }
    
    func animateDialog() {
        
        view.alpha = 0;
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.alpha = 1.0;
        })
        
        let previousTransform = self.contentView.transform
        self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.contentView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 0.0);
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.contentView.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.0);
                    }, completion: { (Bool) -> Void in
                        UIView.animate(withDuration: 0.1, animations: { () -> Void in
                            self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 0.0);
                            }, completion: { (Bool) -> Void in
                                self.contentView.transform = previousTransform
                        }) 
                }) 
        }) 
    }
}


extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
