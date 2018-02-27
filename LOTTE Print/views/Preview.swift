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
    self.btnFinished.isEnabled = false
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
    card.view.frame = CGRect(x: 0, y: 0, width: 1240, height: 1754)
    card.setInfo(name: textName, index: currentIndex)
 
    if #available(iOS 9.0, *) {
        card.loadViewIfNeeded()
    } else {
        // Fallback on earlier versions
    }
    
    //Set color for text name
    let image = GradientBackground.gradientImage(lbName.bounds.size)
    lbName.textColor = UIColor(patternImage: image)
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.image = self.createUIInage(self.card.view)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Hide status bar
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  //Button back to previous
  @IBAction func btnBack(_ sender: UIButton) {
    //        setCountIndex()
    self.dismiss(animated: true, completion: nil)
  }
  
  //Button printer
  @IBAction func btnPrint(_ sender: UIButton) {
    self.printCard()
  }
  
  
  //Button finished page
  @IBAction func btnFinished(_ sender: UIButton) {
    setCountIndex()
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  //Set name for label person name
  func setPersonName(_ name:String){
    textName = name
  }
  
  func setCountIndex(){
    let i = DataHelper.sharedInstance.getIncreaseIndex()
    DataHelper.sharedInstance.setCurrentIndex(i)
  }
  
  func printCard(){
//    self.printImage({
//      (error) -> Void in
//      self.confirmDialog(error)
//    })
    
    //      self.saveImage(self.image!,callback: {
    //        (error, path) -> Void in
    //        self.confirmDialog(error)
    //      })
    
//    self.createPDFfromUIView(self.card.view, aFilename: "card.pdf") { (error, pathName) -> Void in
//      self.confirmDialog(error)
//    }
    
    UIImageWriteToSavedPhotosAlbum(self.image!, self, #selector(Preview.image(_:didFinishSavingWithError:contextInfo:)), nil)
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
    if error == nil {
      let dialog = UIAlertController(title: "保存完了", message: "カメラロールに画像を保存しました。", preferredStyle: .alert)
      dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(dialog, animated: true, completion: {
        self.btnFinished.isEnabled = true
      })
    } else {
      let dialog = UIAlertController(title: "保存エラー", message: error?.localizedDescription, preferredStyle: .alert)
      dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(dialog, animated: true, completion: nil)
    }
  }

  
  func confirmDialog(_ error:NSError?){
    if(error == nil){
      self.btnFinished.isEnabled = true
    }else{
      let dialog = UIAlertController(title: "接続エラー", message: error?.domain, preferredStyle: .alert)
      dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(dialog, animated: true, completion: nil)
    }
  }
  
}

//Print image
extension Preview{
  func printImage(_ callback:((_ error:NSError?)->Void)?) {
    if(self.image != nil){
      DispatchQueue.main.async(execute: {
        
        //Init printer inteface controller
        let printController = UIPrintInteractionController.shared
        
        //Setting printer
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = .general
        printInfo.duplex = .none
        printController.printInfo = printInfo
        printController.showsPageRange = false
        printController.printingItem = self.image
        
        // Get last url of printer
        let printerURL = DataHelper.sharedInstance.getCurrentPrinterURL()
        if(printerURL == nil){
          callback?(NSError(domain: "プリンターに接続できませんでした。設定画面よりプリンターが設定されているか確認してください。", code: 500, userInfo: nil))
        }else{
          
          let printer = UIPrinter(url: printerURL! as URL)
          // I will print without printer panel this here.
//          printController.print(to: printer, completionHandler: {
//            (printer, b, error) -> Void in
//            (callback?(error))!
//          })
            
            
            
            printController.print(to: printer, completionHandler: { (printer:UIPrintInteractionController, b:Bool,error: Error?) in
                (callback?(error! as NSError))!
            })
            
            
            
        }
      })
    }
    
  }
}


//Create PDF file from UIView
extension Preview{
  func createPDFfromUIView(_ aView:UIView, aFilename:String, callback:@escaping (_ error:NSError?, _ pathName:URL)->Void){
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
      // Creates a mutable data object for updating with binary data, like a byte array
      let pdfData = NSMutableData()
      
      // Points the pdf converter to the mutable data object and to the UIView to be converted
      UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
      UIGraphicsBeginPDFPage();
      let pdfContext = UIGraphicsGetCurrentContext();
      
      
      // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
      aView.layer.render(in: pdfContext!)
      
      // remove PDF rendering context
      UIGraphicsEndPDFContext();
      
      // Retrieves the document directories from the iOS device
      //Get the local docs directory and append your local filename.
      var url = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
      
      url = url?.appendingPathComponent(aFilename)
      
      //Lastly, write your file to the disk.
      let result = pdfData.write(to: url!, atomically: true)
      
      // instructs the mutable data object to write its context to a file on disk
      if(result){
        callback(nil, url!)
      }else{
        callback(NSError(domain: "Can not create file", code: 500, userInfo: nil), url!)
      }
    })
    
  }
}

//Create PDF file from UIView
extension Preview{
  func createUIInage(_ view:UIView)->UIImage{
    //Convert UIView to UIImage
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}

//Create PDF file from UIView
extension Preview{
  func createPhotofromUIView(_ view:UIView, aFilename:String, callback:(_ error:NSError?, _ pathName:URL)->Void){
    
    //Convert UIView to UIImage
    let image = createUIInage(view)
    
    
    //Create image path to document folder
    var url = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
    url = url?.appendingPathComponent(aFilename)
    
    let pathExtention = url!.pathExtension
    var result = false
    
    //Lastly, write your file to the disk.
    if(pathExtention == "png"){
      let pngImageData = UIImagePNGRepresentation(image)
      result = (try? pngImageData!.write(to: url!, options: [.atomic])) != nil
    }else{
      let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
      result = (try? jpgImageData!.write(to: url!, options: [.atomic])) != nil
    }
    
    //Check status file writed and set callback
    if(result){
      callback(nil, url!)
    }else{
      callback(NSError(domain: "Can not create image file", code: 500, userInfo: nil), url!)
    }
  }
}

//Save image file
extension Preview{
  func saveImage(_ image:UIImage, callback:(_ error:NSError?, _ pathName:URL)->Void){
    //Create image path to document folder
    let url = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
    let urlJpg = url?.appendingPathComponent("card.jpg")
    let urlPng = url?.appendingPathComponent("card.png")
    
    
    let pngImageData = UIImagePNGRepresentation(image)
    try? pngImageData!.write(to: urlPng!, options: [.atomic])
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
    try? jpgImageData!.write(to: urlJpg!, options: [.atomic])
    
    //Check status file writed and set callback
    callback(NSError(domain: "Created Image", code: 500, userInfo: nil), url!)
  }
}

//Print file from url
extension Preview{
  func printWithoutPanel(_ dataUrl:URL, callback:((_ error:NSError?)->Void)?) {
    DispatchQueue.main.async(execute: {
      let myData = try? Data(contentsOf: dataUrl)
      if (UIPrintInteractionController.canPrint(myData!) ) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo.printInfo()
        printInfo.outputType = UIPrintInfoOutputType.general
        printController.printInfo = printInfo
        printController.showsPageRange = false
        printController.printingItem = myData
        
        // Create printer information
        let printerURL = DataHelper.sharedInstance.getCurrentPrinterURL()
        if(printerURL == nil){
          callback?(NSError(domain: "The printer url not found. Please go to setting to reconnect printer again", code: 500, userInfo: nil))
        }else{
          
          let printer = UIPrinter(url: printerURL! as URL)
          // I will print without printer panel this here.
//          printController.print(to: printer, completionHandler: {
//            (printer, b, error) -> Void in
//            (callback?(error))!
//          })
            
            printController.print(to: printer, completionHandler: { (p:UIPrintInteractionController, b:Bool, error:Error?) in
            (callback?(error! as NSError))!
           })
        }
      }
    })
    
  }
}
