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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPersonName.delegate = self
        // Do any additional setup after loading the view.
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
            let previewViewController = Preview(nibName:"Preview", bundle: nil)
            previewViewController.setPersonName(text)
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
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 6
    }

}
