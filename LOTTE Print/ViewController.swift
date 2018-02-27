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
    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func gotoInputView(_ sender: UIButton) {
        let inputView = InputView(nibName:"InputView",bundle: nil)
        self.present(inputView, animated: true, completion: nil)
    }
    
    @IBAction func btnSetting(_ sender: UIButton) {
        let searchPrinter = SearchPrinterController(nibName:"SearchPrinterController",bundle: nil)
        self.present(searchPrinter, animated: true, completion: nil)
    }
}

