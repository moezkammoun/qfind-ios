//
//  WebViewController.swift
//  QFind
//
//  Created by Exalture on 14/02/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var webViewLoader: LoadingView!
    @IBOutlet weak var titleLabel: UILabel!
    var webViewUrl: URL? = nil
    var titleString: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = titleString?.uppercased()
        let requestObj = URLRequest(url: webViewUrl!)
        self.webView.loadRequest(requestObj)
       webView.delegate = self
        webViewLoader.isHidden = false
        webViewLoader.showLoading()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
       
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webViewLoader.stopLoading()
        webViewLoader.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewLoader.isHidden = false
        webViewLoader.stopLoading()
        webViewLoader.showNoDataView()
        
    }
   

}
