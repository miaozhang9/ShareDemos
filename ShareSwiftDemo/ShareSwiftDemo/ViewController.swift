//
//  ViewController.swift
//  ShareSwiftDemo
//
//  Created by Miaoz on 2018/6/7.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    var textField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        textField.center = CGPoint(x: view.center.x, y: view.center.y - 260)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.placeholder = ""
        textField.delegate = self
        textField.text = "www/index.html"//https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html
        self.view.addSubview(textField)
        
        
        let btn = UIButton(type: .system)
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.borderWidth = 1.0
        btn.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        btn.center = CGPoint(x: view.center.x, y: view.center.y - 130)
        btn.setTitle("启动贷款SDK(local)", for: .normal)
        btn.addTarget(self, action: #selector(launchClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let btn2 = UIButton(type: .system)
        btn2.layer.borderColor = UIColor.blue.cgColor
        btn2.layer.borderWidth = 1.0
        btn2.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        btn2.center = CGPoint(x: view.center.x, y: view.center.y - 130 + 100)
        btn2.setTitle("启动UIWebViewVC", for: .normal)
        btn2.addTarget(self, action: #selector(launchUIWebViewVC), for: .touchUpInside)
        self.view.addSubview(btn2)
        
        
        let btn3 = UIButton(type: .system)
        btn3.layer.borderColor = UIColor.blue.cgColor
        btn3.layer.borderWidth = 1.0
        btn3.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        btn3.center = CGPoint(x: view.center.x, y: view.center.y - 130 + 200)
        btn3.setTitle("启动WKWebViewVC", for: .normal)
        btn3.addTarget(self, action: #selector(launchWKWebViewVC), for: .touchUpInside)
        self.view.addSubview(btn3)
      
    }

    @objc func launchClick() {
        var str = "www/index.html"
        if textField.text != nil &&  !(textField.text?.isEmpty)!{
            str = textField.text!
        }
        let helper = QHLoanDoor.share().setDataInfo([:])?.setBasicDelegate(self)?.setBarColor("#d8e6ff")?.setBarTitleColor("#000000")?.setBarTitleFontSize(17)?.setBackBtnTitle("返回")?.setBackBtnTitleColor("#ff6600")?.setBackBtnImage(nil)?.setAgent("ToCred")?.setCoreWebView(QHCoreWebViewEnum.uiWebView)?.setStartPageUrl(str)?.start()!
    }
   @objc func launchUIWebViewVC() {
        var str = "www/index.html"
        if textField.text != nil &&  !(textField.text?.isEmpty)!{
            str = textField.text!
        }
        let vc = UIWebViewVC()
        vc.startUrlStr = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   @objc func launchWKWebViewVC() {
        var str = "www/index.html"
        if textField.text != nil &&  !(textField.text?.isEmpty)!{
            str = textField.text!
        }
        let vc = WKWebViewVC()
        vc.startUrlStr = str
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: QHBasicProtocol{
    func getAgentUserInfo() -> [AnyHashable : Any]! {
        return [:]
    }
    
    func openNewPage(withUrl url: String!) -> Bool {
        return true
    }
    
    func openLaunchLoginPage() {
        
    }
    
    func openNewPage(withParams params: [AnyHashable : Any]!) {
        
    }
    
    func executeH5InfoAction(_ info: [AnyHashable : Any]!) -> [AnyHashable : Any]! {
      
        self.getDataInfo(info: info as! NSDictionary)
        return [:]
    }
    
    
}

extension ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

