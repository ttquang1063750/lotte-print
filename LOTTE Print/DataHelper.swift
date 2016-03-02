//
//  DataHelper.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/18/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation

class DataHelper {
    class var sharedInstance: DataHelper {
        struct Static {
            static var instance: DataHelper?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = DataHelper()
        }
        return Static.instance!
    }
    
    private let INDEXING = "INDEXING"
    private let PRINTER_URL = "PRINTER_URL"
    private let DATE_RESET = "DATE_RESET"
    
    
    func setCurrentPrinterUrl(url:NSURL){
        NSUserDefaults.standardUserDefaults().setURL(url, forKey: PRINTER_URL)
    }
    
    func getCurrentPrinterURL()->NSURL?{
        if(NSUserDefaults.standardUserDefaults().URLForKey(PRINTER_URL) == nil){
            return nil
        }
        return NSUserDefaults.standardUserDefaults().URLForKey(PRINTER_URL)!
    }
    
    func removeCurrentPrinterUrl(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(PRINTER_URL)
    }
    
    func setCurrentIndex(index:Int){
        NSUserDefaults.standardUserDefaults().setInteger(index, forKey: INDEXING)
    }
    
    func getCurrentIndex(defaultValue:Int = 0)->Int{
        if(NSUserDefaults.standardUserDefaults().valueForKey(INDEXING) == nil){
            return defaultValue
        }
        return NSUserDefaults.standardUserDefaults().integerForKey(INDEXING)
    }
    
    func getIncreaseIndex()->Int{
        return getCurrentIndex() + 1
    }
    
    func resetIndexToOrigin()->String{
        NSUserDefaults.standardUserDefaults().removeObjectForKey(INDEXING)
        return "001"
    }
    
    func setDateReset(dateString:String){
        NSUserDefaults.standardUserDefaults().setValue(dateString, forKey: DATE_RESET)
    }
    
    func getDateReset()->String?{
        if(NSUserDefaults.standardUserDefaults().valueForKey(DATE_RESET) == nil){
            return nil
        }
        return NSUserDefaults.standardUserDefaults().stringForKey(DATE_RESET)
    }
    
    func synchronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
