//
//  Common.swift
//  jpKenzai
//
//  Created by Thinh Nguyen on 10/27/14.
//  Copyright (c) 2014 GumiViet. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension String {
    
    ///Convert String to double
    func integerValue() -> Int {
        return (self as NSString).integerValue
    }
    
    ///Convert String to Datetime
    func dateTimeValue() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone=TimeZone(identifier: "GMT")
        let date = dateFormatter.date(from: (self as NSString) as String)
        return date!
    }
    
    ///Convert String to float
    func floatValue() -> Float {
        return (self as NSString).floatValue
    }
    
    ///Convert String to double
    func doubleValue() -> Double {
        return (self as NSString).doubleValue
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst()).lowercased()
    }
}

extension Date {
    
    ///Convert String to double with custom format
    func toString(dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone=TimeZone(identifier: "GMT")
        return  dateFormatter.string(from: self)
    }
    
    ///Convert String to double with the default format
    func toString() -> String {
        return  toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    func getDayOfWeek()->Int {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = self
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        return weekDay!
    }
}

final class GvAsyncTask<Params, Result>{
    
    fileprivate var onPreExecute:(()->Void)?
    
    fileprivate var onPostExecute:((_ result:Result) -> Void)?
    
    fileprivate var doInBackground:((_ params:[Params]) -> Result)!
    
    init(doInBackground:@escaping ((_ params:[Params]) -> Result), onPreExecute:(()->Void)? = nil, onPostExecute:((_ result:Result) -> Void)? = nil){
        self.onPreExecute = onPreExecute
        self.onPostExecute = onPostExecute
        self.doInBackground = doInBackground
    }
    
    func execute(_ params:Params...){
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            if(self.onPreExecute != nil ){
                self.onPreExecute!()
            }
            
//            let results:Result = self.doInBackground(params: params)
            
            
            let results:Result = self.doInBackground(params)
        
            
            DispatchQueue.main.async{
                
                if(self.onPostExecute != nil){
                    self.onPostExecute!(results)
                }
            }
        })
    }
}

extension Dictionary {
    
    ///Just update the value for the key only if the value is not null
    mutating func updateValueNotNull(_ value: Value?, forKey key: Key){
        if(value != nil){
            self.updateValue(value!, forKey: key)
        }
    }
    
    func integerForKey(_ forKey: Key) -> Int?{
        var value = self[forKey] as? Int
        if(value == nil){
            value = (self[forKey] as? String)?.integerValue()
        }
        return value
    }
    
    func boolForKey(_ forKey: Key) -> Bool{
        return self[forKey] as! Bool
    }
    
    func stringForKey(_ forKey: Key) -> String{
        return self[forKey] as! String
    }
    
    func dateForKey(_ forKey: Key) -> Date{
        var value = self[forKey] as? Date
        
        if(value == nil){
            let interval:Double? = (self[forKey] as? Double)
            if(interval != nil){
                value = Date(timeIntervalSince1970: interval!)
            }
            
            let stringValue:String? = (self[forKey] as? String)
            
            if(stringValue != nil){
                value = stringValue?.dateTimeValue()
            }
        }
        return value!
    }
}

extension UIAlertController {
    // LeHien: Create a waiting dialog with title, message and Activity indicator
    class func createWaitingDialog(_ title:String?,message:String)->UIAlertController{
        let waitingDialog=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicatorView.frame = CGRect(x: 120, y: 60, width: 30, height: 30)
        indicatorView.color = UIColor.gray
        waitingDialog.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        return waitingDialog
    }
    // END
    
}
extension Array
{
    func shuffled() -> [Element] {
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            if i != j{
                list.swapAt(i, j)
            }
        }
        return list
    }
}
extension Array{
    func indexOf(_ t:Element,isMatch:((Element) -> Bool))->Int{
        for (idx, element) in self.enumerated() {
            if isMatch(element) {
                return idx
            }
        }
        return -1
    }
}

