//
//  PopupViewController.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/2/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOk(sender: UIButton) {
        let parent = self.parentViewController as! SearchPrinterController
        parent.setResetOk()
    }
    
    @IBAction func btnCancel(sender: UIButton) {
        let parent = self.parentViewController as! SearchPrinterController
        parent.setResetCancel()
    }

}
