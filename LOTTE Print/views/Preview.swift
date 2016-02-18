//
//  Preview.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit
import QuartzCore

class Preview: UIViewController {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var mBtnPrint: UIButton!
    var isPrint = false
    
    var textName = ""
    let card = Card(nibName:"Card", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = textName
        // Do any additional setup after loading the view.
        card.view.frame = CGRectMake(0, 0, 465, 214)
        card.loadViewIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    @IBAction func btnBack(sender: UIButton) {
        setCountIndex()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnPrint(sender: UIButton) {
        card.setPersonName(textName)
        createPDFfromUIView(card.view, aFilename: "\(DataHelper.sharedInstance.getIncreaseIndex()).pdf"){
            pdfPath in
            self.tryPrintPdf(pdfPath){
                self.isPrint = true
            }
        }
        
    }
    
    @IBAction func btnFinished(sender: UIButton) {
        setCountIndex()
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setPersonName(name:String){
        textName = name
    }
    
    func setCountIndex(){
        if isPrint{
            let i = DataHelper.sharedInstance.getIncreaseIndex()
            DataHelper.sharedInstance.setCurrentIndex(i)
        }
    }
    
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
    
    func tryPrintPdf(url:NSURL, callback:()->Void){
        dispatch_async(dispatch_get_main_queue(), {
            let myData = NSData(contentsOfURL: url)
            if (UIPrintInteractionController.canPrintData(myData!) ) {
                let printController = UIPrintInteractionController.sharedPrintController()
                let printInfo = UIPrintInfo.printInfo()
                printController.printInfo = printInfo;
                printController.showsPageRange = true;
                printController.printingItem = myData;
                printController.presentAnimated(true, completionHandler: { (printer, b, error) -> Void in
                    callback()
                })
                
            }
        })
        
    }
    
}
