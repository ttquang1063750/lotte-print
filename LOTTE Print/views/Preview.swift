//
//  Preview.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
import QuartzCore

class Preview: UIViewController, UIPrinterPickerControllerDelegate {
  
  @IBOutlet weak var lbName: UILabel!
  @IBOutlet weak var mBtnPrint: UIButton!
  @IBOutlet weak var btnFinished: UIButton!
  
  var lastPrinter:UIPrinter?
  var textName = ""
  var card:Card!
  var image:UIImage?
  override func viewDidLoad() {
    super.viewDidLoad()
    lbName.text = textName
    self.btnFinished.enabled = false
    
    //Get indext
    let index = DataHelper.sharedInstance.getIncreaseIndex()
    var currentIndex = ""
    if index < 10{
      currentIndex = "00\(index)"
    }else{
      if(index < 100){
        currentIndex = "0\(index)"
      }else{
        currentIndex = "\(index)"
      }
    }
    //Create view print
    card = Card(nibName:"Card", bundle: nil)
//    card.view.frame = CGRectMake(0, 0, 595, 842)
    card.view.frame = CGRectMake(0, 0, 1240, 1754)
    card.setInfo(name: textName, index: currentIndex)
    card.loadViewIfNeeded()
    
    //Set color for text name
    let image = GradientBackground.gradientImage(lbName.bounds.size)
    lbName.textColor = UIColor(patternImage: image)
  }
  
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.image = self.createUIInage(self.card.view)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Hide status bar
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  //Button back to previous
  @IBAction func btnBack(sender: UIButton) {
    //        setCountIndex()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //Button printer
  @IBAction func btnPrint(sender: UIButton) {
    self.printCard()
  }
  
  
  //Button finished page
  @IBAction func btnFinished(sender: UIButton) {
    setCountIndex()
    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //Set name for label person name
  func setPersonName(name:String){
    textName = name
  }
  
  func setCountIndex(){
    let i = DataHelper.sharedInstance.getIncreaseIndex()
    DataHelper.sharedInstance.setCurrentIndex(i)
  }
  
  func printCard(){
    self.printImage({
      (error) -> Void in
      self.confirmDialog(error)
    })
    
    //      self.saveImage(self.image!,callback: {
    //        (error, path) -> Void in
    //        self.confirmDialog(error)
    //      })
  }
  
  
  func confirmDialog(error:NSError?){
    if(error == nil){
      self.btnFinished.enabled = true
    }else{
      let dialog = UIAlertController(title: "接続エラー", message: error?.domain, preferredStyle: UIAlertControllerStyle.Alert)
      dialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
      self.presentViewController(dialog, animated: true, completion: nil)
    }
  }
  
}

//Print image
extension Preview{
  func printImage(callback:((error:NSError?)->Void)?) {
    if(self.image != nil){
      dispatch_async(dispatch_get_main_queue(), {
        
        //Init printer inteface controller
        let printController = UIPrintInteractionController.sharedPrintController()
        
        //Setting printer
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .General
        printInfo.duplex = .None
        printController.printInfo = printInfo
        printController.showsPageRange = false
        printController.printingItem = self.image
        
        // Get last url of printer
        let printerURL = DataHelper.sharedInstance.getCurrentPrinterURL()
        if(printerURL == nil){
          callback?(error: NSError(domain: "プリンターに接続できませんでした。設定画面よりプリンターが設定されているか確認してください。", code: 500, userInfo: nil))
        }else{
          
          let printer = UIPrinter(URL: printerURL!)
          // I will print without printer panel this here.
          printController.printToPrinter(printer, completionHandler: {
            (printer, b, error) -> Void in
            callback?(error: error)
          })
        }
      })
    }
    
  }
}


//Create PDF file from UIView
extension Preview{
  func createPDFfromUIView(aView:UIView, aFilename:String, callback:(error:NSError?, pathName:NSURL)->Void){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
      // Creates a mutable data object for updating with binary data, like a byte array
      let pdfData = NSMutableData()
      
      // Points the pdf converter to the mutable data object and to the UIView to be converted
      UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
      UIGraphicsBeginPDFPage();
      let pdfContext = UIGraphicsGetCurrentContext();
      
      
      // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
      aView.layer.renderInContext(pdfContext!)
      
      // remove PDF rendering context
      UIGraphicsEndPDFContext();
      
      // Retrieves the document directories from the iOS device
      //Get the local docs directory and append your local filename.
      var url = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last
      
      url = url?.URLByAppendingPathComponent(aFilename)
      
      //Lastly, write your file to the disk.
      let result = pdfData.writeToURL(url!, atomically: true)
      
      // instructs the mutable data object to write its context to a file on disk
      if(result){
        callback(error:nil, pathName: url!)
      }else{
        callback(error:NSError(domain: "Can not create file", code: 500, userInfo: nil), pathName:url!)
      }
    })
    
  }
}

//Create PDF file from UIView
extension Preview{
  func createUIInage(view:UIView)->UIImage{
    //Convert UIView to UIImage
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}

//Create PDF file from UIView
extension Preview{
  func createPhotofromUIView(view:UIView, aFilename:String, callback:(error:NSError?, pathName:NSURL)->Void){
    
    //Convert UIView to UIImage
    let image = createUIInage(view)
    
    
    //Create image path to document folder
    var url = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last
    url = url?.URLByAppendingPathComponent(aFilename)
    
    let pathExtention = url!.pathExtension
    var result = false
    
    //Lastly, write your file to the disk.
    if(pathExtention == "png"){
      let pngImageData = UIImagePNGRepresentation(image)
      result = pngImageData!.writeToURL(url!, atomically: true)
    }else{
      let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
      result = jpgImageData!.writeToURL(url!, atomically: true)
    }
    
    //Check status file writed and set callback
    if(result){
      callback(error:nil, pathName: url!)
    }else{
      callback(error:NSError(domain: "Can not create image file", code: 500, userInfo: nil), pathName:url!)
    }
  }
}

//Save image file
extension Preview{
  func saveImage(image:UIImage, callback:(error:NSError?, pathName:NSURL)->Void){
    //Create image path to document folder
    let url = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last
    let urlJpg = url?.URLByAppendingPathComponent("card.jpg")
    let urlPng = url?.URLByAppendingPathComponent("card.png")
    
    
    let pngImageData = UIImagePNGRepresentation(image)
    pngImageData!.writeToURL(urlPng!, atomically: true)
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
    jpgImageData!.writeToURL(urlJpg!, atomically: true)
    
    //Check status file writed and set callback
    callback(error:NSError(domain: "Created Image", code: 500, userInfo: nil), pathName:url!)
  }
}

//Print file from url
extension Preview{
  func printWithoutPanel(dataUrl:NSURL, callback:((error:NSError?)->Void)?) {
    dispatch_async(dispatch_get_main_queue(), {
      let myData = NSData(contentsOfURL: dataUrl)
      if (UIPrintInteractionController.canPrintData(myData!) ) {
        let printController = UIPrintInteractionController.sharedPrintController()
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = UIPrintInfoOutputType.General
        printController.printInfo = printInfo
        printController.showsPageRange = false
        printController.printingItem = myData
        
        // Create printer information
        let printerURL = DataHelper.sharedInstance.getCurrentPrinterURL()
        if(printerURL == nil){
          callback?(error: NSError(domain: "The printer url not found. Please go to setting to reconnect printer again", code: 500, userInfo: nil))
        }else{
          
          let printer = UIPrinter(URL: printerURL!)
          // I will print without printer panel this here.
          printController.printToPrinter(printer, completionHandler: {
            (printer, b, error) -> Void in
            callback?(error: error)
          })
        }
      }
    })
    
  }
}
