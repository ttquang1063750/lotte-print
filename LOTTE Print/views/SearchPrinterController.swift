//
//  SearchPrinterController.swift
//  LOTTE Print
//
//  Created by GUMI-QUANG on 3/2/16.
//  Copyright © 2016 GUMI-QUANG. All rights reserved.
//

import UIKit

class SearchPrinterController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPrinterPickerControllerDelegate {

    @IBOutlet weak var lbPrinterName: UILabel!
    @IBOutlet weak var tbListPrinter: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lbIndex: UILabel!
    @IBOutlet weak var lbDateReset: UILabel!
    @IBOutlet weak var btnReSearchPrinter: UIButton!
    
    var lastUrl = DataHelper.sharedInstance.getCurrentPrinterURL()
    var dataPrinter = [Printer]()
    var isAppeared = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbListPrinter.registerNib(UINib(nibName: "PrinterCell", bundle: nil), forCellReuseIdentifier: "PrinterCell")
        self.tbListPrinter.separatorStyle = UITableViewCellSeparatorStyle.None
        self.lbPrinterName.text = "未設定"
        
        var index = DataHelper.sharedInstance.getCurrentIndex()
        if index < 10{
            index = index == 0 ? 1 : index
            self.lbIndex.text = "00\(index)"
        }else{
            self.lbIndex.text = "\(index)"
        }
    
        
        //Get current date reseted
        let dateString = DataHelper.sharedInstance.getDateReset()
        if(dateString != nil){
            self.setDateReset(dateString!)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Only call one time if view loaded
        if(!isAppeared){
            self.getPrinter()
            isAppeared = true
//            Custom vertical scroll bar
//            for v in self.tbListPrinter.subviews{
//                if(v.isKindOfClass(UIImageView)){
//                    let imageView = v as! UIImageView
//                    imageView.image = UIImage(named: "vertical_scroll_bar.png")
//                }
//            }
        }
    }
    
    func getPrinter() {
        dispatch_async(dispatch_get_main_queue(), {
            print("===cal getPrinter===")
            self.dataPrinter.removeAll()
            self.tbListPrinter.reloadData()
            self.indicator.startAnimating()
            self.btnReSearchPrinter.hidden = true
            let printPickerController = UIPrinterPickerController(initiallySelectedPrinter: nil)
            print(printPickerController)
            printPickerController.delegate = self
            printPickerController.presentFromRect(CGRectMake(0, 0, 2048, 2048), inView: self.view, animated: true, completionHandler: nil)
        })
    }
    
    
    func printerPickerController(printerPickerController: UIPrinterPickerController, shouldShowPrinter printer: UIPrinter) -> Bool {
        let printer = Printer(printer: printer)
        if(self.lastUrl != nil && printer.isEqualUrl(self.lastUrl!)){
            self.lbPrinterName.text = printer.getPrinterName()
        }
        self.dataPrinter.append(printer)
        print("==Printer Item:\(printer)==")
        return true
    }
    
    func printerPickerControllerDidPresent(printerPickerController: UIPrinterPickerController) {
        printerPickerController.dismissAnimated(false)
        self.indicator.stopAnimating()
        self.btnReSearchPrinter.hidden = false
        self.tbListPrinter.reloadData()
        print("==Printer count: \(self.dataPrinter.count)")
    }
    
    @IBAction func btnClose(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnReset(sender: UIButton) {
        GvAlertView().showDialog("title_confirm_reset.png", isBtnCancel: true, bgImageName:"bg_dialog.png") {
            (btnIndex) -> Void in
            
            //btnIndex 0: ok, 1: cancel
            if(btnIndex == 0){
                self.setResetOk()
            }
        }
    }
    
    func setResetOk(){
        self.lbIndex.text = DataHelper.sharedInstance.resetIndexToOrigin()
        
        let date = NSDate()
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        self.setDateReset(dateString)
    }
    
    
    func setDateReset(dateString:String){
        self.lbDateReset.hidden = false
        self.lbDateReset.text = "（前回リセット日時：\(dateString)）"
        DataHelper.sharedInstance.setDateReset(dateString)
    }
    
    
    @IBAction func reSearchPrinter(sender: UIButton) {
        self.getPrinter()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataPrinter.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PrinterCell", forIndexPath: indexPath) as! PrinterCell
        let printer = self.dataPrinter[indexPath.row]
        cell.lbPrinterName.text = printer.getPrinterName()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let printer = self.dataPrinter[indexPath.row]
        DataHelper.sharedInstance.setCurrentPrinterUrl(printer.getPrinterUrl())
        self.lastUrl = printer.getPrinterUrl()
        if(self.lastUrl != nil && printer.isEqualUrl(self.lastUrl!)){
            self.lbPrinterName.text = printer.getPrinterName()
        }
    }

}
