//
//  DetailViewController.swift
//  QFind
//
//  Created by Exalture on 16/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import MessageUI
import UIKit

class DetailViewController: RootViewController,BottomProtocol,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var detailBottomBar: BottomBarView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var backImgaeView: UIImageView!
    @IBOutlet weak var detailLoadingView: LoadingView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var viewForwebView: UIView!
    
    @IBOutlet var detailWebView: UIWebView!
    var serviceProviderArrayDict: ServiceProvider?
    var informationDetails = [String : String]()
    var informationArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetUp()
        titleLabel.text = serviceProviderArrayDict?.service_provider_name
        
        setInformationData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setLocalizedVariables()
        detailBottomBar.favoriteview.backgroundColor = UIColor.white
        detailBottomBar.historyView.backgroundColor = UIColor.white
        detailBottomBar.homeView.backgroundColor = UIColor.white
        
    }
    func initialSetUp()
    {
        detailBottomBar.bottombarDelegate = self
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            titleLabel.textAlignment = .center
        }
        detailLoadingView.isHidden = true
       // detailLoadingView.showLoading()
        self.detailTableView.register(UINib(nibName: "DetailTableCell", bundle: nil), forCellReuseIdentifier: "detailCellId")
    }
    func setLocalizedVariables()
    {
       // self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            if let _img = backImgaeView.image{
                backImgaeView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.downMirrored)
                
                
            }
        }
        else{
            if let _img = backImgaeView.image {
                backImgaeView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
            }
        }
       
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func favouriteButtonPressed() {
        detailBottomBar.favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.favorite
        self.present(historyVC, animated: false, completion: nil)
    }
    func homebuttonPressed() {
       
        detailBottomBar.homeView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func historyButtonPressed() {
         detailBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.history
        self.present(historyVC, animated: false, completion: nil)
    }
    @IBAction func didTapShare(_ sender: UIButton) {
        let firstActivityItem = "Text you want"
        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        // If you want to put an image
        let image : UIImage = UIImage(named: "banner-1")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
       
        activityViewController.popoverPresentationController?.sourceView = (sender )
        
       
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    //MARK: Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informationArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailCellId", for:indexPath) as! DetailTableViewCell
         if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            if let _img = cell.forwardImageView.image {
                cell.forwardImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.downMirrored)
            }
        }
         else{
            if let _img = cell.forwardImageView.image {
                cell.forwardImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
            }
        }
        if (indexPath.row == 5)
        {
            cell.separatorView.isHidden = true
        }
        let informationDict = informationArray[indexPath.row] as! [String: String]
        cell.setInformationCellValues(informationCellDict: informationDict)
       
       // cell.setInformationCellValues(informationCellDict: informationDetails)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            return 90
        }
        else{
            return 66
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let informationDict = informationArray[indexPath.row] as! [String: String]
        if (informationDict["key"] == "service_provider_mobile_number")
        {
            let phnNumber = informationDict["value"]
          

            if let url = URL(string: "tel://\(Int(phnNumber!)!)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            
        
        }
        else if (informationDict["key"] == "service_provider_website")
        {
            let websiteUrlString = informationDict["value"]
            if let websiteUrl = URL(string: websiteUrlString!) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(websiteUrl as URL) {
                    viewForwebView.frame = self.view.frame
                    self.view.addSubview(viewForwebView)
                    let requestObj = URLRequest(url: websiteUrl)
                    
                    detailWebView.loadRequest(requestObj)
                    
                }
            }
        }
        else if (informationDict["key"] == "service_provider_location")
        {
            
                if ((serviceProviderArrayDict?.service_provider_map_location) != nil){
                    
                    let locationArray = serviceProviderArrayDict?.service_provider_map_location?.components(separatedBy: ",")
                   
                    let latitude = locationArray![0]
                    let longitude =  locationArray![1]
                    
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!)
                        }
                    } else {
                        let locationUrl = URL(string: "https://maps.google.com/?q=@\(latitude),\(longitude)")!
                        viewForwebView.frame = self.view.frame
                        self.view.addSubview(viewForwebView)
                        let requestObj = URLRequest(url: locationUrl)
                        detailWebView.loadRequest(requestObj)

                    }
                }

            
            
        }
    
    else if (informationDict["key"] == "service_provider_mail_account")
    {
        let email = informationDict["value"]
        if let url = URL(string: "mailto:\(email)") {
            if (UIApplication.shared.canOpenURL(url))
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            else{
                //let urlString = URL(string: "inbox-gmail://")
                // UIApplication.shared.openURL(urlString!)
                
                
            }
        }//
    }
         else if (informationDict["key"] == "service_provider_facebook_page")
        {
            
            let facebookUrl = URL(string: informationDict["value"]!)
            if( UIApplication.shared.canOpenURL(facebookUrl!))
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(facebookUrl!, options: [:], completionHandler: nil)
                } else {
                    
                    UIApplication.shared.openURL(facebookUrl!)
                    
                }
            }
            else{
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
               // let facebookUrlString = URL(string: "http://www.facebook.com/vidyarajan.rajan.5")
                let facebookUrlString = URL(string: informationDict["value"]!)
                let requestObj = URLRequest(url: facebookUrlString!)
                detailWebView.loadRequest(requestObj)
                
            }
        }
        else if (informationDict["key"] == "service_provider_linkdin_page")
        {
            let webURL = URL(string: informationDict["value"]!)!
            
            let appURL = URL(string: "linkedin://profile/yourName-yourLastName-yourID")!
            
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                
                 //UIApplication.shared.openURL(webURL)
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
                
                let requestObj = URLRequest(url: webURL)
                detailWebView.loadRequest(requestObj)
            }
       
        }
        else if (informationDict["key"] == "service_provider_instagram_page")
        {
            var instagramHooks = "instagram://user?username=johndoe"
            let webUrl = URL(string: "http://instagram.com/")
            var instagramUrl = URL(string: instagramHooks)
            if UIApplication.shared.canOpenURL(instagramUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(instagramUrl!)
                }
                
            } else {
                
                //UIApplication.shared.openURL(webUrl!)
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
                
                let requestObj = URLRequest(url: webUrl!)
                detailWebView.loadRequest(requestObj)
               
            }
        }
        else if (informationDict["key"] == "service_provider_twitter_page")
        {
            let screenName =  "betkowskii"
            let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
            let webURL = URL(string: "https://twitter.com/\(screenName)")!
            
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                //UIApplication.shared.openURL(webURL)
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
                
                let requestObj = URLRequest(url: webURL)
                detailWebView.loadRequest(requestObj)
            }
        }
        else if (informationDict["key"] == "service_provider_snapchat_page")
        {
            
            let appURL = URL(string: "snapchat://app")
            let webURL = URL(string: "https://www.snapchat.com/add/username")
            
            if UIApplication.shared.canOpenURL(appURL!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL!)
                }
            } else {
               // UIApplication.shared.openURL(webURL!)
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
                
                let requestObj = URLRequest(url: webURL!)
                detailWebView.loadRequest(requestObj)
            }
        }
        else if (informationDict["key"] == "service_provider_googleplus_page")
        {
            let appURL = URL(string: "gplus://plus.google.com/+WpguruTv")
            let webURL = URL(string: "http://http://plus.google.com/+WpguruTv")
            
            if UIApplication.shared.canOpenURL(appURL!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL!)
                }
            } else {
               // UIApplication.shared.openURL(webURL!)
                viewForwebView.frame = self.view.frame
                self.view.addSubview(viewForwebView)
                
                let requestObj = URLRequest(url: webURL!)
                detailWebView.loadRequest(requestObj)
            }
        }
        
        
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didTapMenu(_ sender: UIButton) {
        self.showSidebar()
    }
   func setInformationData()
   {
    
    if ((serviceProviderArrayDict?.service_provider_mobile_number) != nil){
        
        informationDetails = ["key" : "service_provider_mobile_number","value" :(serviceProviderArrayDict?.service_provider_mobile_number)! ,"imageName": "phone"]
        informationArray.add(informationDetails)
    }
    if ((serviceProviderArrayDict?.service_provider_website) != nil){
       
        informationDetails = [ "key" : "service_provider_website","value" :(serviceProviderArrayDict?.service_provider_website)!,"imageName": "website" ]
        informationArray.add(informationDetails)
    }
    if ((serviceProviderArrayDict?.service_provider_location) != nil){
       
        informationDetails = [ "key" : "service_provider_location","value" :(serviceProviderArrayDict?.service_provider_location)!,"imageName": "location"  ]
        informationArray.add(informationDetails)
    }
    if ((serviceProviderArrayDict?.service_provider_opening_time) != nil){
       
        informationDetails = [ "key" : "service_provider_opening_time","value" :(serviceProviderArrayDict?.service_provider_opening_time)!,"imageName": "time" ]
        informationArray.add(informationDetails)
    }
    if (((serviceProviderArrayDict?.service_provider_mail_account) != nil) && ((serviceProviderArrayDict?.service_provider_mail_account) != "")){
        
        informationDetails = [ "key" : "service_provider_mail_account","value"  :(serviceProviderArrayDict?.service_provider_mail_account)!,"imageName": "email" ]
         informationArray.add(informationDetails)
    }
    if (((serviceProviderArrayDict?.service_provider_facebook_page) != nil) && ((serviceProviderArrayDict?.service_provider_facebook_page) != "")){
      
        informationDetails = [ "key" : "service_provider_facebook_page","value" :(serviceProviderArrayDict?.service_provider_facebook_page)! ,"imageName": ""]
        informationArray.add(informationDetails)
    }

    if (((serviceProviderArrayDict?.service_provider_linkdin_page) != nil) && ((serviceProviderArrayDict?.service_provider_linkdin_page) != "")){
       
        informationDetails = [ "key" : "service_provider_linkdin_page", "value":(serviceProviderArrayDict?.service_provider_linkdin_page)! ,"imageName": ""]
        informationArray.add(informationDetails)
    }
    if (((serviceProviderArrayDict?.service_provider_instagram_page) != nil) && ((serviceProviderArrayDict?.service_provider_instagram_page) != "")){
        
        informationDetails = [ "key" : "service_provider_instagram_page", "value" :(serviceProviderArrayDict?.service_provider_instagram_page)!,"imageName": "" ]
        informationArray.add(informationDetails)
    }
    if (((serviceProviderArrayDict?.service_provider_twitter_page) != nil) && ((serviceProviderArrayDict?.service_provider_twitter_page) != "")){
        
        informationDetails = [ "key" : "service_provider_twitter_page", "value"  :(serviceProviderArrayDict?.service_provider_twitter_page)!,"imageName": "" ]
        informationArray.add(informationDetails)
    }
    
    if (((serviceProviderArrayDict?.service_provider_snapchat_page) != nil) && ((serviceProviderArrayDict?.service_provider_snapchat_page) != "")){
       
    informationDetails = [ "key" : "service_provider_snapchat_page", "value" :(serviceProviderArrayDict?.service_provider_snapchat_page)!,"imageName": "" ]
    informationArray.add(informationDetails)
    }
    if (((serviceProviderArrayDict?.service_provider_googleplus_page) != nil) && ((serviceProviderArrayDict?.service_provider_googleplus_page) != "")){
        
    informationDetails = [ "key" : "service_provider_googleplus_page", "value" :(serviceProviderArrayDict?.service_provider_googleplus_page)!,"imageName": "" ]
    informationArray.add(informationDetails)
    }
    
    detailTableView.reloadData()
    
    }
    @IBAction func didTapWebViewClose(_ sender: UIButton) {
        detailWebView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
        viewForwebView.removeFromSuperview()
    }
    
}
