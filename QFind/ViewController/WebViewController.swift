//
//  WebViewController.swift
//  QFind
//
//  Created by Exalture on 14/02/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var webViewUrl: URL? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        //let urlString = URL(string: webViewUrl!)
        let requestObj = URLRequest(url: webViewUrl!)
        self.webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    

   

}
