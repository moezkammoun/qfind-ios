//
//  RootViewController.swift
//  QFind
//
//  Created by Exalture on 19/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import UIKit

class RootViewController: UIViewController {

    var sidebarView: SidebarView!
    var blackScreen: UIView!
    var webViewController = WebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setSidebar()
    }
    func setSidebar()
    {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en")
            {
                sidebarView = SidebarView(frame: CGRect(x: self.view.frame.width, y: 20, width: 0,
                                                        height: self.view.frame.height))
            }
            else{
                sidebarView = SidebarView(frame: CGRect(x: 0, y: 20, width: 0,
                                                        height: self.view.frame.height))
            }
        sidebarView.delegate = self
        sidebarView.layer.zPosition = 100
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(sidebarView)
        
        blackScreen = UIView(frame: self.view.bounds)
        blackScreen.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden = true
        self.view.addSubview(blackScreen)
        blackScreen.layer.zPosition = 99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        if ((LocalizationLanguage.currentAppleLanguage()) == "en")
        {
            UIView.animate(withDuration: 0.3) {
                self.sidebarView.frame = CGRect(x: self.view.frame.width, y: 20, width: 0,
                                                height: self.sidebarView.frame.height)
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
                self.sidebarView.frame = CGRect(x: 0, y: 20, width: 0,
                                                height: self.sidebarView.frame.height)
            }
        }
    }
    

    func showSidebar() {
        self.blackScreen.isHidden = false
        let widthValue = UIScreen.main.bounds.width
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en")
            {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.sidebarView.frame =
                        CGRect(x: self.view.frame.width-(widthValue * 0.62), y: 20, width:(widthValue * 0.62),
                               height: self.sidebarView.frame.height)
                }) { (complete) in
                    self.blackScreen.frame =
                        CGRect(x: 0, y: 20,
                               width: self.view.frame.width-self.sidebarView.frame.width,
                               height: self.view.bounds.height + 100)
                }
            }
            else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sidebarView.frame =
                        CGRect(x: 0, y: 20, width: (widthValue * 0.62),
                               height: self.sidebarView.frame.height)
                }) { (complete) in
                    self.blackScreen.frame =
                        CGRect(x: self.sidebarView.frame.width, y: 20,
                               width: self.view.frame.width -
                                self.sidebarView.frame.width,
                               height: self.view.bounds.height + 100)
                }
            }
        }
        else{
            if ((LocalizationLanguage.currentAppleLanguage()) == "en")
            {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.sidebarView.frame =
                        CGRect(x: self.view.frame.width-(widthValue * 0.6), y: 20, width: (widthValue * 0.6),
                               height: self.sidebarView.frame.height)
                }) { (complete) in
                    self.blackScreen.frame =
                        CGRect(x: 0, y: 20,
                               width: self.view.frame.width -
                                self.sidebarView.frame.width,
                               height: self.view.bounds.height + 100)
                }
            }
            else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.sidebarView.frame =
                        CGRect(x: 0, y: 20, width: (widthValue * 0.6),
                               height: self.sidebarView.frame.height)
                }) { (complete) in
                    self.blackScreen.frame =
                        CGRect(x: self.sidebarView.frame.width, y: 20,
                               width: self.view.frame.width -
                                self.sidebarView.frame.width,
                               height: self.view.bounds.height + 100)
                }
            }
       
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RootViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        if ((LocalizationLanguage.currentAppleLanguage()) == "en")
        {
            UIView.animate(withDuration: 0.3) {
                self.sidebarView.frame =
                    CGRect(x: self.view.frame.width, y: 20, width: 0,
                           height: self.sidebarView.frame.height)
            }
        }
        else{
            UIView.animate(withDuration: 0.3) {
                self.sidebarView.frame =
                    CGRect(x: 0, y: 20, width: 0,
                           height: self.sidebarView.frame.height)
            }
        }
        
        switch row {
        case .menu:
            break
        case .aboutus:
            let aboutUrlString: String?
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
               
                aboutUrlString = Config.baseURL+"static-pages/1/1"
            }
            else {
                aboutUrlString = Config.baseURL+"static-pages/1/2"
            }
            if let aboutUrl = URL(string: aboutUrlString!) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(aboutUrl as URL) {
                    
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = aboutUrl
                    
                    webViewVc.titleString = NSLocalizedString("About us", comment: "About us Label in the webview page")
                    self.present(webViewVc, animated: false, completion: nil)
                    
                }
            }
           
        case .howToBecomeQfinder:
            let qfindUrlString: String?
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
               qfindUrlString = Config.baseURL+"static-pages/2/1"
            }
            else {
               qfindUrlString = Config.baseURL+"static-pages/2/2"
            }
            if let qfindertUrl = URL(string: qfindUrlString!) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(qfindertUrl as URL) {
                    
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = qfindertUrl
                    webViewVc.titleString = NSLocalizedString("How to become qfinder", comment: "How to become qfinder Label in the webview page")
                    
                    self.present(webViewVc, animated: false, completion: nil)
                    
                }
            }
            
        case .termsAndConditions:
            var termsUrlString: String?
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                termsUrlString = Config.baseURL+"static-pages/3/1"
            }
            else {
                termsUrlString = Config.baseURL+"static-pages/3/2"
            }
            if let termsAndConditionUrl = URL(string: termsUrlString!) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(termsAndConditionUrl as URL) {
                    
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = termsAndConditionUrl
                    webViewVc.titleString = NSLocalizedString("Terms & conditions", comment: "Terms & conditions Label in the webview page")
                    self.present(webViewVc, animated: false, completion: nil)
                    
                }
            }
            
        case .contactUs:
            var contactUrlString: String?
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                contactUrlString = Config.baseURL+"static-pages/4/1"
            }
            else {
                contactUrlString = Config.baseURL+"static-pages/4/2"
            }
            if let contactUrl = URL(string: contactUrlString! ) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(contactUrl as URL) {
                    
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = contactUrl
                    webViewVc.titleString = NSLocalizedString("Contact us", comment: "Contact us Label in the webview page")
                    self.present(webViewVc, animated: false, completion: nil)
                    
                }
            }
           
        case .settings:
            let settingsVc = self.storyboard?.instantiateViewController(withIdentifier: "settingsId")
            self.present(settingsVc!, animated: false, completion: nil)
        case .none:
            break
        }
    }


}


