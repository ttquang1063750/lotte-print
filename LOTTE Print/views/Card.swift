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
  @IBOutlet weak var lbIndex: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setInfo(name:String, index:String){
    self.mName.text = name
    self.lbIndex.text = index
    //Set color for text name
    let image = GradientBackground.gradientImage(self.mName.bounds.size)
    self.mName.textColor = UIColor(patternImage: image)
  }
}
