//
//  ViewController.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var lastPrinter:UIPrinter?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let v = UIView(frame: CGRectMake(180,180,200,150))
//        v.backgroundColor = UIColor(patternImage: GradientBackground.gradientImage(CGSize(width: 200, height: 150)))
//        self.view.addSubview(v)
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
        let searchPrinter = SearchPrinterController(nibName:"SearchPrinterController",bundle: nil)
        self.presentViewController(searchPrinter, animated: true, completion: nil)
    }
}

