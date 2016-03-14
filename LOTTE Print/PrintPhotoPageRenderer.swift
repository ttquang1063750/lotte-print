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
    override func numberOfPages()->Int{
        return 1
    }
    
    override func drawPageAtIndex(pageIndex: Int, inRect printableRect: CGRect){
        if(self.imageToPrint != nil){
            let x:CGFloat = 57.5
            let y:CGFloat = 123.5
            let width:CGFloat = 473.5
            let height:CGFloat = 591.5
            let rect:CGRect = CGRectMake(x, y, width, height)
            self.imageToPrint.drawInRect(rect)
            print(printableRect)
            print(self.paperRect)
            print(rect)
        }
    }
    
}
