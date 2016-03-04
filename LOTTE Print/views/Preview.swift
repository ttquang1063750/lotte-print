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
    
    var lastPrinter:UIPrinter?
    var textName = ""
    var card:Card!
    var pdfPath:NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = textName
        
        //Create view print
        card = Card(nibName:"Card", bundle: nil)
        card.view.frame = CGRectMake(0, 0, 465, 214)
        card.setPersonName(textName)
        card.loadViewIfNeeded()
        
        //Set color for text name
        let image = GradientBackground.gradientImage(lbName.bounds.size)
        lbName.textColor = UIColor(patternImage: image)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    }
    
    
    func confirmDialog(error:NSError?){
        if(error == nil){
            setCountIndex()
        }else{
            let dialog = UIAlertController(title: "Error", message: error?.domain, preferredStyle: UIAlertControllerStyle.Alert)
            dialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(dialog, animated: true, completion: nil)
        }
    }
    
}

//Print image
extension Preview{
    func printImage(callback:((error:NSError?)->Void)?) {
        dispatch_async(dispatch_get_main_queue(), {
            
            //Convert UIView to UIImage
            UIGraphicsBeginImageContextWithOptions(self.card.view.bounds.size, self.card.view.opaque, 0.0)
            self.card.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //Init printer inteface controller
            let printController = UIPrintInteractionController.sharedPrintController()
            
            //Setting printer
            let printInfo = UIPrintInfo.printInfo()
            printInfo.outputType = UIPrintInfoOutputType.General
            printController.printInfo = printInfo
            printController.showsPageRange = false
            printController.printingItem = nil
            if(image.size.width > image.size.height){
                printInfo.orientation = UIPrintInfoOrientation.Landscape
            }
            
            
            //Render view image in page setup
            let pageRenderer = PrintPhotoPageRenderer()
            pageRenderer.imageToPrint = image
            printController.printPageRenderer = pageRenderer
            
            
            // Get last url of printer
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
        })
        
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
    func createPhotofromUIView(view:UIView, aFilename:String, callback:(error:NSError?, pathName:NSURL)->Void){
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Retrieves the document directories from the iOS device
        //Get the local docs directory and append your local filename.
        var url = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last
        
        url = url?.URLByAppendingPathComponent(aFilename)
        
        //Lastly, write your file to the disk.
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = jpgImageData!.writeToURL(url!, atomically: true)
        // instructs the mutable data object to write its context to a file on disk
        if(result){
            callback(error:nil, pathName: url!)
        }else{
            callback(error:NSError(domain: "Can not create image file", code: 500, userInfo: nil), pathName:url!)
        }
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
