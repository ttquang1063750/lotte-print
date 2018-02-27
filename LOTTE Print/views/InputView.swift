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
  @IBOutlet weak var imgInputView: UIImageView!
  @IBOutlet weak var lbHolder: UILabel!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tfPersonName.delegate = self
    self.btnOk.isEnabled = false
    let index = DataHelper.sharedInstance.getIncreaseIndex()
    if index < 10{
      personIndex.text = "00\(index)"
    }else{
      personIndex.text = "\(index)"
    }
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(InputView.hideKeyBoard))
    imgInputView.addGestureRecognizer(tap)
    imgInputView.isUserInteractionEnabled = true
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let index = DataHelper.sharedInstance.getIncreaseIndex()
    if index < 10{
      personIndex.text = "00\(index)"
    }else{
      if index < 100{
        personIndex.text = "0\(index)"
      }else{
        personIndex.text = "\(index)"
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //Hide status bar
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  func hideKeyBoard(){
    tfPersonName.resignFirstResponder()
  }
  
  @IBAction func goBack(_ sender: UIButton) {
    hideKeyBoard()
    self.dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func submitForm(_ sender: UIButton) {
     hideKeyBoard()
    if let text = tfPersonName.text, !text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    {
      let previewViewController = Preview(nibName:"Preview", bundle: nil)
      previewViewController.setPersonName(text.uppercaseFirst)
      self.present(previewViewController, animated: true, completion: nil)
    }
  }
  
  
  func textFieldDidBeginEditing(_ textField: UITextField){
    scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

    if (isInValid(textField.text!)) {
      let dialog = UIAlertController(title: "入力エラー", message: "半角英数字で入力してください", preferredStyle: UIAlertControllerStyle.alert)
      dialog.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
      self.present(dialog, animated: true, completion: {
        self.btnOk.isEnabled = false
      })
    }else{
      self.btnOk.isEnabled = true
      textField.text! = textField.text!.uppercaseFirst
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if (isInValid(string)&&string != "") {
      return false
    }
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    if (range.length + range.location > currentCharacterCount){
      return false
    }
    let newLength = currentCharacterCount + string.characters.count - range.length
    if(newLength > 0){
      textField.text! = textField.text!.uppercaseFirst
      self.lbHolder.isHidden = true
       self.btnOk.isEnabled = true
    }else{
      self.btnOk.isEnabled = false
      self.lbHolder.isHidden = false
    }
    return newLength <= 8
  }
  
  func isInValid(_ text:String)->Bool{
//    let characterSet = NSCharacterSet(charactersInString: "年月日時分×÷-=♪☆%¥〒~・…○()/☻？！+")
//    if let _ = text.rangeOfCharacterFromSet(characterSet, options: .CaseInsensitiveSearch, range: nil) {
//      return true
//    }
//    return Regex().addPattern("[\\u3040-\\u309F]|[\\u3000-\\u303F]|[\\u2605-\\u2606]|[\\u2190-\\u2195]|[\\uFF5F-\\uFF9F]|\\u203B|\\FFEE").test(text)
    return !Regex().addPattern("[a-zA-Z0-9]").test(text)
  }
}

class Regex {
  var internalExpression: NSRegularExpression?
  var pattern: String?
  
  func addPattern(_ pattern: String)->Regex{
    do{
      self.pattern = pattern
      self.internalExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }catch{
    }
    return self
  }
  
  func test(_ input: String) -> Bool {
    let matches = self.internalExpression!.matches(in: input, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, input.characters.count))
    return matches.count > 0
  }
}
