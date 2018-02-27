//
//  PrintPhotoPageRenderer.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/3/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
class PrintPhotoPageRenderer: UIPrintPageRenderer {
    var imageToPrint:UIImage!
    override var numberOfPages:Int{
        return 1
    }
    
    override func drawPage(at pageIndex: Int, in printableRect: CGRect){
        if(self.imageToPrint != nil){
            let x:CGFloat = 57.5
            let y:CGFloat = 123.5
            let width:CGFloat = 473.5
            let height:CGFloat = 591.5
            let rect:CGRect = CGRect(x: x, y: y, width: width, height: height)
            self.imageToPrint.draw(in: rect)
            print(printableRect)
            print(self.paperRect)
            print(rect)
        }
    }
    
}
