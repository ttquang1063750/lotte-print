//
//  ViewController.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func gotoInputView(sender: UIButton) {
        let inputView = InputView(nibName:"InputView",bundle: nil)
        self.presentViewController(inputView, animated: true, completion: nil)
    }
    
    @IBAction func btnSetting(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            if(NSFoundationVersionNumber > 7.1) {
                let printPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
                printPicker.presentFromRect(CGRectMake(0, 0, 80, 80), inView: self.view, animated: true, completionHandler: {
                    (printPicker, userDidSelect, error) -> Void in
                    // Print address of printer simulator that you choose
                    if(userDidSelect){
                        DataHelper.sharedInstance.setCurrentPrinterUrl((printPicker.selectedPrinter?.URL)!)
                    }
                })
            }
        })
    }
    
    
}

