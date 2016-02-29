//
//  DataHelper.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/18/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation
import UIKit

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
    private let PRINTER = "PRINTER"
    private let PRINTER_URL = "PRINTER_URL"
    
    
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
    
    func synchronize(){
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setPrinter(obj:UIPrinter){
//        NSKeyedArchiver.archiveRootObject(obj, toFile: fileInDocumentsDirectory(PRINTER))
        let data = NSKeyedArchiver.archivedDataWithRootObject(obj)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "DATA")
    }
    
    func getPrinter()->UIPrinter?{
//        guard let printer = NSKeyedUnarchiver.unarchiveObjectWithFile(fileInDocumentsDirectory(PRINTER)) as? [UIPrinter] else { return nil }
//        return printer[0]
        
        if(NSUserDefaults.standardUserDefaults().valueForKey("DATA") == nil){
            return nil
        }
        let data = NSUserDefaults.standardUserDefaults().objectForKey("DATA") as! NSData
       return  NSKeyedUnarchiver.unarchiveObjectWithData(data) as? UIPrinter
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsDirectory().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    func getDocumentsDirectory() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
}
