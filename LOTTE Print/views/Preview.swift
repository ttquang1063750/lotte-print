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
    var isPrint = false
    var textName = ""
    var card:Card!
    var pdfPath:NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = textName
        // Do any additional setup after loading the view.
        card = Card(nibName:"Card", bundle: nil)
        card.view.frame = CGRectMake(0, 0, 465, 214)
        card.setPersonName(textName)
        card.loadViewIfNeeded()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createPDFfromUIView(card.view, aFilename: "card.pdf"){
            pdfPath in
            self.pdfPath = pdfPath
        }
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
        if isPrint{
            let i = DataHelper.sharedInstance.getIncreaseIndex()
            DataHelper.sharedInstance.setCurrentIndex(i)
        }
    }
    
    func printCard(){
        self.printWithoutPanel(self.pdfPath, callback: {
            (error) -> Void in
            self.confirm(error)
        })
    }
    
    
    func confirm(error:NSError?){
        if(error == nil){
            self.isPrint = true
        }else{
            let dialog = UIAlertController(title: "Connect Printer Error", message: "Do you want to search printer again", preferredStyle: UIAlertControllerStyle.Alert)
            dialog.addAction(UIAlertAction(title: "Search", style: UIAlertActionStyle.Default, handler: {
                (action)->Void in
                self.searchPrinter({
                  self.printCard()  
                })
            }))
            dialog.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(dialog, animated: true, completion: nil)
        }
    }
    
    func printerPickerControllerParentViewController(printerPickerController: UIPrinterPickerController) -> UIViewController? {
        return self
    }
}


//Create PDF file from UIView
extension Preview{
    func createPDFfromUIView(aView:UIView, aFilename:String, callback:(pathName:NSURL)->Void){
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
            pdfData.writeToURL(url!, atomically: true)
            
            // instructs the mutable data object to write its context to a file on disk
            callback(pathName: url!)
        })
        
    }
}

//Search printer
extension Preview{
    func searchPrinter(callback:()->Void) {
        dispatch_async(dispatch_get_main_queue(), {
            if(NSFoundationVersionNumber > 7.1) {
                if(DataHelper.sharedInstance.getCurrentPrinterURL() != nil){
                    self.lastPrinter = UIPrinter(URL: DataHelper.sharedInstance.getCurrentPrinterURL()!)
                }else{
                    self.lastPrinter = UIPrinter(URL: NSURL(string: "ipps://quang.local.:8632/printers/test")!)
                }
                
                self.lastPrinter?.contactPrinter({ (isAvailable) -> Void in
                    let printPicker = UIPrinterPickerController(initiallySelectedPrinter: self.lastPrinter)
                    printPicker.delegate = self
                    printPicker.presentFromRect(CGRectMake(0, 0, 80, 80), inView: self.view, animated: true, completionHandler: {
                        (printPicker, userDidSelect, error) -> Void in
                        // Print address of printer simulator that you choose
                        if(userDidSelect){
                            DataHelper.sharedInstance.setCurrentPrinterUrl(printPicker.selectedPrinter!.URL)
                            callback()
                        }
                    })
                })
            }
        })
    }
}


//Print file without show print option
extension Preview{
    func printWithoutPanel(dataUrl:NSURL, callback:(error:NSError?)->Void) {
        dispatch_async(dispatch_get_main_queue(), {
            let myData = NSData(contentsOfURL: dataUrl)
            if (UIPrintInteractionController.canPrintData(myData!) ) {
                let printController = UIPrintInteractionController.sharedPrintController()
                let printInfo = UIPrintInfo.printInfo()
                printInfo.outputType = UIPrintInfoOutputType.Photo
                printController.printInfo = printInfo;
                printController.showsPageRange = false;
                printController.printingItem = myData;
                
                // Create printer information
                let printerURL = DataHelper.sharedInstance.getCurrentPrinterURL()
                if(printerURL == nil){
                    callback(error: NSError(domain: "no data", code: 500, userInfo: nil))
                }else{
                    
                    let printer = UIPrinter(URL: printerURL!)
                    // I will print without printer panel this here.
                    printController.printToPrinter(printer, completionHandler: {
                        (printer, b, error) -> Void in
                        callback(error: error)
                    })
                }
            }
        })
        
    }
}

//Print file with show print option
extension Preview{
    func printPdfFilePanel(url:NSURL, callback:()->Void){
        dispatch_async(dispatch_get_main_queue(), {
            let myData = NSData(contentsOfURL: url)
            if (UIPrintInteractionController.canPrintData(myData!) ) {
                let printController = UIPrintInteractionController.sharedPrintController()
                let printInfo = UIPrintInfo.printInfo()
                printInfo.outputType = UIPrintInfoOutputType.Photo
                printController.printInfo = printInfo;
                printController.showsPageRange = false;
                printController.printingItem = myData;
                printController.presentAnimated(true, completionHandler: { (printer, b, error) -> Void in
                    callback()
                })
                
            }
        })
    }
}
