//
//  DataHelper.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/18/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import Foundation

class DataHelper {
    private static var __once: () = {
            var instance = DataHelper()
        }()
    class var sharedInstance: DataHelper {
        struct Static {
            static var instance: DataHelper? = DataHelper()
            static var token: Int = 0
        }
        _ = DataHelper.__once
        return Static.instance!
    }
    
    fileprivate let INDEXING = "INDEXING"
    fileprivate let PRINTER_URL = "PRINTER_URL"
    fileprivate let DATE_RESET = "DATE_RESET"
    
    
    func setCurrentPrinterUrl(_ url:URL){
        UserDefaults.standard.set(url, forKey: PRINTER_URL)
    }
    
    func getCurrentPrinterURL()->URL?{
        if(UserDefaults.standard.url(forKey: PRINTER_URL) == nil){
            return nil
        }
        return UserDefaults.standard.url(forKey: PRINTER_URL)!
    }
    
    func removeCurrentPrinterUrl(){
        UserDefaults.standard.removeObject(forKey: PRINTER_URL)
    }
    
    func setCurrentIndex(_ index:Int){
        UserDefaults.standard.set(index, forKey: INDEXING)
    }
    
    func getCurrentIndex(_ defaultValue:Int = 0)->Int{
        if(UserDefaults.standard.value(forKey: INDEXING) == nil){
            return defaultValue
        }
        return UserDefaults.standard.integer(forKey: INDEXING)
    }
    
    func getIncreaseIndex()->Int{
        return getCurrentIndex() + 1
    }
    
    func resetIndexToOrigin()->String{
        UserDefaults.standard.removeObject(forKey: INDEXING)
        return "001"
    }
    
    func setDateReset(_ dateString:String){
        UserDefaults.standard.setValue(dateString, forKey: DATE_RESET)
    }
    
    func getDateReset()->String?{
        if(UserDefaults.standard.value(forKey: DATE_RESET) == nil){
            return nil
        }
        return UserDefaults.standard.string(forKey: DATE_RESET)
    }
    
    func synchronize(){
        UserDefaults.standard.synchronize()
    }
}
