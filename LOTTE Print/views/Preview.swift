//
//  Preview.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class Preview: UIViewController {

    @IBOutlet weak var mBtnPrint: UIButton!
    @IBOutlet weak var mViewCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func btnPrint(sender: UIButton) {
    }
    
    @IBAction func btnFinished(sender: UIButton) {
    }

}
