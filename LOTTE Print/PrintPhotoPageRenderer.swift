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
            self.imageToPrint.drawInRect(self.paperRect)
        }
    }
    
    
}
