//
//  Printer.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/2/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation
import UIKit

class Printer:NSObject {
    private var name:String
    private var url:NSURL
    
    //Init with object printer
    init(printer:UIPrinter){
        self.name = printer.displayName
        self.url = printer.URL
    }
    
    
    //Init with params name and url
    init(printerName:String, printerUrl:NSURL) {
        self.name = printerName
        self.url = printerUrl
    }
    
    func setPrinterName(printerName:String){
        self.name = printerName
    }
    
    func getPrinterName()->String{
        return self.name
    }
    
    func setPrinterUrl(printerUrl:NSURL){
        self.url = printerUrl
    }
    
    func getPrinterUrl()->NSURL{
        return self.url
    }
    
    func isEqualUrl(printerUrl:NSURL)->Bool{
        return printerUrl.absoluteString == self.url.absoluteString
    }
}
