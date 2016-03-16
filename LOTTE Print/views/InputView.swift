//
//  InputView.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 2/17/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class InputView: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var personIndex: UILabel!
  @IBOutlet weak var tfPersonName: UITextField!
  @IBOutlet weak var btnOk: UIButton!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tfPersonName.delegate = self
    self.btnOk.enabled = false
    let index = DataHelper.sharedInstance.getIncreaseIndex()
    if index < 10{
      personIndex.text = "00\(index)"
    }else{
      personIndex.text = "\(index)"
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let index = DataHelper.sharedInstance.getIncreaseIndex()
    if index < 10{
      personIndex.text = "00\(index)"
    }else{
      personIndex.text = "\(index)"
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
  
  @IBAction func goBack(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  @IBAction func submitForm(sender: UIButton) {
    if let text = tfPersonName.text where !text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty
    {
      tfPersonName.resignFirstResponder()
      let previewViewController = Preview(nibName:"Preview", bundle: nil)
      previewViewController.setPersonName(text.uppercaseFirst)
      self.presentViewController(previewViewController, animated: true, completion: nil)
    }
  }
  
  
  func textFieldDidBeginEditing(textField: UITextField){
    scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (Regex().addPattern("\\d|\\W|[\\u3040-\\u309F]").test(textField.text!)) {
      let dialog = UIAlertController(title: "接続エラー", message: "平仮名や絵文字を入力できないようにする", preferredStyle: UIAlertControllerStyle.Alert)
      dialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
      self.presentViewController(dialog, animated: true, completion: {
        self.btnOk.enabled = false
      })
    }
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    if (range.length + range.location > currentCharacterCount){
      return false
    }
    let newLength = currentCharacterCount + string.characters.count - range.length
    if(newLength > 0){
      self.btnOk.enabled = true
    }else{
      self.btnOk.enabled = false
    }
    return newLength <= 8
  }
  
}

class Regex {
  var internalExpression: NSRegularExpression?
  var pattern: String?
  
  func addPattern(pattern: String)->Regex{
    do{
      self.pattern = pattern
      self.internalExpression = try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }catch{
    }
    return self
  }
  
  func test(input: String) -> Bool {
    let matches = self.internalExpression!.matchesInString(input, options: NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, input.characters.count))
    return matches.count > 0
  }
}
