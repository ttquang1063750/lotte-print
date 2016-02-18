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
}
