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
    fileprivate var name:String
    fileprivate var url:URL
    
    //Init with object printer
    init(printer:UIPrinter){
        self.name = printer.displayName
        self.url = printer.url
    }
    
    
    //Init with params name and url
    init(printerName:String, printerUrl:URL) {
        self.name = printerName
        self.url = printerUrl
    }
    
    func setPrinterName(_ printerName:String){
        self.name = printerName
    }
    
    func getPrinterName()->String{
        return self.name
    }
    
    func setPrinterUrl(_ printerUrl:URL){
        self.url = printerUrl
    }
    
    func getPrinterUrl()->URL{
        return self.url
    }
    
    func isEqualUrl(_ printerUrl:URL)->Bool{
        return printerUrl.absoluteString == self.url.absoluteString
    }
}
