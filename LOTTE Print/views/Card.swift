//
//  Card.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class Card: UIViewController {

    @IBOutlet weak var mName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPersonName(name:String){
        self.mName.text = name
        //Set color for text name
        let image = GradientBackground.gradientImage(self.mName.bounds.size)
        self.mName.textColor = UIColor(patternImage: image)
    }
    
    class var sharedInstance: Card {
        struct Static {
            static var instance: Card?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Card(nibName:"Card", bundle: nil)
            Static.instance!.view.frame = CGRectMake(0, 0, 465, 214)
        }
        return Static.instance!
    }

}
