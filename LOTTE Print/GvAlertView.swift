//
//  GvAlertView.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/3/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

public class GvAlertView: UIViewController {

    let kBackgroundTransparentcy:CGFloat = 0.7
 
    let kTopMargin:CGFloat = 40.0
    let kMaxHeight:CGFloat = 200.0
    var kContentWidth:CGFloat = 400.0
    let kButtonHeight:CGFloat = 51.0
    let kButtonWidth:CGFloat = 125.0
    let kTitleHeight:CGFloat = 20.0
    var strongSelf:GvAlertView?
    var contentView = UIView()
    var titleImageView:UIImageView = UIImageView()
    var buttons:[UIButton] = []
    var userAction:((btnIndex:Int)->Void)? = nil
    
    
    //Init View
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view.frame = UIScreen.mainScreen().bounds
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: kBackgroundTransparentcy)
        self.view.addSubview(contentView)
        strongSelf = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIColor {
    class func colorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}