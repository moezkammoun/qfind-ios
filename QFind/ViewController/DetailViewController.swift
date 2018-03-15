 //
//  DetailViewController.swift
//  QFind
//
//  Created by Exalture on 16/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import CoreData
import MessageUI
import UIKit

class DetailViewController: RootViewController,BottomProtocol,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var detailBottomBar: BottomBarView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var backImgaeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var serviceProviderArrayDict: ServiceProvider?
    var informationDetails = [String : String]()
    var informationArray = NSMutableArray()
    var fromFavorite: Bool? = false
    var fromHistory: Bool? = false
    var fromSearch: Bool? = false
    var favoriteDeleted : Bool? = false
    var favoriteDictinary = NSMutableDictionary()
    var historyDict: HistoryEntity?
    let networkReachability = NetworkReachabilityManager()
    @IBOutlet weak var bottombarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottombarInitialSetup()
        if(fromHistory == true){
            setHistoryInformationData()
            fetchHistoryInfo(idValue: Int((historyDict?.id)!))
        }
         else if(fromFavorite == false){
            fetchHistoryInfo(idValue: (serviceProviderArrayDict?.id)!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setLocalizedVariables()
        detailBottomBar.favoriteview.backgroundColor = UIColor.white
        detailBottomBar.historyView.backgroundColor = UIColor.white
        detailBottomBar.homeView.backgroundColor = UIColor.white
        initialSetUp()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
         setFontForInformationPage()
    }
    func initialSetUp()
    {
        detailBottomBar.bottombarDelegate = self
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            titleLabel.textAlignment = .center
        }
        self.detailTableView.register(UINib(nibName: "DetailTableCell", bundle: nil), forCellReuseIdentifier: "detailCellId")
        if (fromFavorite == true){
            informationArray = NSMutableArray()
            setFavoriteInformationData()
            fetchHistoryInfo(idValue: favoriteDictinary.value(forKey: "id") as! Int)
        }
        else if (fromHistory == false){
            informationArray = NSMutableArray()
            setInformationData()
        }
        else{
            let fetchData = checkAddedToFavorites(serviceId: Int((historyDict?.id)!), entityNameString: "FavoriteEntity")
            if (fetchData.count == 0){
                favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
            }
            else{
                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
            }
        }
    }
    func bottombarInitialSetup() {
        if UIDevice().userInterfaceIdiom == .phone {
            if (UIScreen.main.nativeBounds.height == 2436) {
                bottomBarBottomConstraint.isActive = true
                bottombarHeight.constant = 60
                bottomBarBottomConstraint.constant = 0
            }
            else{
                bottombarHeight.isActive = false
            }
        }
        else{
            bottombarHeight.isActive = false
        }
    }
    func setLocalizedVariables(){
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
        if  (networkReachability?.isReachable)! {
            let firstActivityItem = "Text you want"
            let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = (sender )
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
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
        else {
            self.view.hideAllToasts()
            let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
            self.view.makeToast(checkInternet)
        }
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
        else {
            if let _img = cell.forwardImageView.image {
                cell.forwardImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
            }
        }
        if (indexPath.row == (informationArray.count)-1) {
            cell.separatorView.isHidden = true
        }
        else {
            cell.separatorView.isHidden = false
        }
        let informationDict = informationArray[indexPath.row] as! [String: String]
        cell.setInformationCellValues(informationCellDict: informationDict)
        if (informationDict["key"] == "service_provider_opening_time") {
            cell.selectionStyle = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return 90
        } else{
            return 66
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let informationDict = informationArray[indexPath.row] as! [String: String]
        if (informationDict["key"] == "service_provider_mobile_number") {
            let phnNumber = informationDict["value"]
            if let url = URL(string: "tel://\(Int(phnNumber!)!)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else if (informationDict["key"] == "service_provider_website") {
            if  (networkReachability?.isReachable)! {
                let websiteUrlString = informationDict["value"]
                if let websiteUrl = URL(string: websiteUrlString!) {
                    if UIApplication.shared.canOpenURL(websiteUrl as URL) {
                        let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                        webViewVc.webViewUrl = websiteUrl
                       //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                         webViewVc.titleString = "QFind"
                        self.present(webViewVc, animated: false, completion: nil)
                    }
                }
            }
            else {
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_address")
        {
             if  (networkReachability?.isReachable)! {
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
                        let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                        webViewVc.webViewUrl = locationUrl
                        //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                        webViewVc.titleString = "QFind"
                        self.present(webViewVc, animated: false, completion: nil)
                    }
                }
            }
             else {
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_mail_account")
        {
            if  (networkReachability?.isReachable)! {
                
                guard let email = informationDict["value"] else{
                    return
                }
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
                    }
                }
            }
            else {
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_facebook_page")
        {
             if  (networkReachability?.isReachable)!{
                guard let urlString = informationDict["value"] else{
                    return
                }
               // let urlString = "355356557838717"
                 let appURL = URL(string: "fb://profile/\(urlString)")
                //355356557838717
                if (appURL != nil) {
                if( UIApplication.shared.canOpenURL(appURL!))
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL!)
                    }
                }
                else{
                    let facebookUrlString = URL(string: "http://www.facebook.com/\(urlString)")
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = facebookUrlString
                    //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                    webViewVc.titleString = "QFind"
                    self.present(webViewVc, animated: false, completion: nil)
                }
                }
            }
             else{
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_instagram_page")
        {
            if  (networkReachability?.isReachable)! {
            guard let userName = informationDict["value"] else{
                return
            }
            // let userName = "cinemawoodofficial"
            //let instagramHooks = "instagram://user?screen_name=\(screenName)"
            let instagramHooks = "instagram://user?username=\(userName)"
            let webUrl = URL(string: "http://instagram.com/\(userName)")
            let instagramUrl = URL(string: instagramHooks)
            if UIApplication.shared.canOpenURL(instagramUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(instagramUrl!)
                }
            } else {
                let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                webViewVc.webViewUrl = webUrl
                //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                webViewVc.titleString = "QFind"
                self.present(webViewVc, animated: false, completion: nil)
            }
            }
            else{
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_twitter_page")
        {
            if  (networkReachability?.isReachable)! {
                guard let screenName = informationDict["value"] else{
                    return
                }
                //let screenName = "ShashiTharoor"
                let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
                let webURL = URL(string: "https://twitter.com/\(screenName)")!
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                } else {
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = webURL
                    //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                    webViewVc.titleString = "QFind"
                    self.present(webViewVc, animated: false, completion: nil)
                }
        }
        else{
            self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
        }
        }
        else if (informationDict["key"] == "service_provider_snapchat_page")
        {
             if  (networkReachability?.isReachable)! {
                guard let userName = informationDict["value"] else{
                    return
                }
               // let userName = "vidyanakul"
                let appURL = URL(string: "snapchat://add/\(userName)")
                let webURL = URL(string: "https://www.snapchat.com/add/\(userName)")
                
                if UIApplication.shared.canOpenURL(appURL!) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL!)
                    }
                } else {
                    let webViewVc:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewId") as! WebViewController
                    webViewVc.webViewUrl = webURL
                    //webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                    webViewVc.titleString = "QFind"
                    self.present(webViewVc, animated: false, completion: nil)
                }
        }
        else{
            self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
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
        let fetchData = checkAddedToFavorites(serviceId: (serviceProviderArrayDict?.id)!, entityNameString: "FavoriteEntity")
        if (fetchData.count == 0){
            favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
        }
        else{
            favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
        }
        if ((serviceProviderArrayDict?.service_provider_mobile_number) != nil){
            
            informationDetails = ["key" : "service_provider_mobile_number","value" :(serviceProviderArrayDict?.service_provider_mobile_number)! ,"imageName": "phone"]
            informationArray.add(informationDetails)
        }
        if ((serviceProviderArrayDict?.service_provider_website) != nil){
            informationDetails = [ "key" : "service_provider_website","value" :(serviceProviderArrayDict?.service_provider_website)!,"imageName": "website" ]
            informationArray.add(informationDetails)
        }
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
             titleLabel.text = serviceProviderArrayDict?.service_provider_name
             locationLabel.text = serviceProviderArrayDict?.service_provider_location
            if ((serviceProviderArrayDict?.service_provider_address) != nil){
                
                informationDetails = [ "key" : "service_provider_address","value" :(serviceProviderArrayDict?.service_provider_address)!,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        else{
             titleLabel.text = serviceProviderArrayDict?.service_provider_name_arabic
             locationLabel.text = serviceProviderArrayDict?.service_provider_location_arabic
            if ((serviceProviderArrayDict?.service_provider_address_arabic) != nil){
                
                informationDetails = [ "key" : "service_provider_address","value" :(serviceProviderArrayDict?.service_provider_address_arabic)!,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        if ((serviceProviderArrayDict?.service_provider_opening_time) != nil){
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                setOpeningTimeToArray(opTimeString: (serviceProviderArrayDict?.service_provider_opening_time)!!, opTitleString: (serviceProviderArrayDict?.service_provider_opening_title)!, clTimeString: (serviceProviderArrayDict?.service_provider_closing_time)!, clTitleString: (serviceProviderArrayDict?.service_provider_closing_title)!)
            }
            else {
                setOpeningTimeToArray(opTimeString: (serviceProviderArrayDict?.service_provider_opening_time_arabic)!, opTitleString: (serviceProviderArrayDict?.service_provider_opening_title_arabic)!, clTimeString: (serviceProviderArrayDict?.service_provider_closing_time_arabic)!!, clTitleString: (serviceProviderArrayDict?.service_provider_closing_title_arabic)!)
            }
        }
        if (((serviceProviderArrayDict?.service_provider_mail_account) != nil) && ((serviceProviderArrayDict?.service_provider_mail_account) != "")){
            
            informationDetails = [ "key" : "service_provider_mail_account","value"  :(serviceProviderArrayDict?.service_provider_mail_account)!,"imageName": "email" ]
            informationArray.add(informationDetails)
        }
        if (((serviceProviderArrayDict?.service_provider_facebook_page) != nil) && ((serviceProviderArrayDict?.service_provider_facebook_page) != "")){
            
            informationDetails = [ "key" : "service_provider_facebook_page","value" :(serviceProviderArrayDict?.service_provider_facebook_page)! ,"imageName": "facebook"]
            informationArray.add(informationDetails)
        }
        if (((serviceProviderArrayDict?.service_provider_instagram_page) != nil) && ((serviceProviderArrayDict?.service_provider_instagram_page) != "")){
            
            informationDetails = [ "key" : "service_provider_instagram_page", "value" :(serviceProviderArrayDict?.service_provider_instagram_page)!,"imageName": "instagram" ]
            informationArray.add(informationDetails)
        }
        if (((serviceProviderArrayDict?.service_provider_twitter_page) != nil) && ((serviceProviderArrayDict?.service_provider_twitter_page) != "")){
            
            informationDetails = [ "key" : "service_provider_twitter_page", "value"  :(serviceProviderArrayDict?.service_provider_twitter_page)!,"imageName": "twitter" ]
            informationArray.add(informationDetails)
        }
        if (((serviceProviderArrayDict?.service_provider_snapchat_page) != nil) && ((serviceProviderArrayDict?.service_provider_snapchat_page) != "")){
            
            informationDetails = [ "key" : "service_provider_snapchat_page", "value" :(serviceProviderArrayDict?.service_provider_snapchat_page)!,"imageName": "snapchat" ]
            informationArray.add(informationDetails)
        }
        detailTableView.reloadData()
    }
    func setFavoriteInformationData()
    {
        let fetchData = checkAddedToFavorites(serviceId: favoriteDictinary.value(forKey: "id") as! Int, entityNameString: "FavoriteEntity")
        if (fetchData.count == 0){
            favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
        }
        else{
            favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
        }
        if ((favoriteDictinary.value(forKey: "mobile")) != nil){
            
            informationDetails = ["key" : "service_provider_mobile_number","value" :(favoriteDictinary.value(forKey: "mobile"))! as! String ,"imageName": "phone"]
            informationArray.add(informationDetails)
        }
        if ((favoriteDictinary.value(forKey: "website")) != nil){
            
            informationDetails = [ "key" : "service_provider_website","value" :(favoriteDictinary.value(forKey: "website"))! as! String,"imageName": "website" ]
            informationArray.add(informationDetails)
        }
        if ((LocalizationLanguage.currentAppleLanguage() == "en")) {
            if  (favoriteDictinary.value(forKey: "name") != nil) {
                titleLabel.text = favoriteDictinary.value(forKey: "name") as? String
            }
            if  (favoriteDictinary.value(forKey: "shortdescription") != nil) {
                locationLabel.text = favoriteDictinary.value(forKey: "shortdescription") as? String
            }
            if ((favoriteDictinary.value(forKey: "address")) != nil){
                
                informationDetails = [ "key" : "service_provider_address","value" :(favoriteDictinary.value(forKey: "address"))! as! String,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        else{
            if  (favoriteDictinary.value(forKey: "arabicname") != nil) {
                titleLabel.text = favoriteDictinary.value(forKey: "arabicname") as? String
            }
            if  (favoriteDictinary.value(forKey: "arabiclocation") != nil) {
                locationLabel.text = favoriteDictinary.value(forKey: "arabiclocation") as? String
            }
            if ((favoriteDictinary.value(forKey: "arabicaddress")) != nil){
                
                informationDetails = [ "key" : "service_provider_address","value" :(favoriteDictinary.value(forKey: "arabicaddress"))! as! String,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        if ((favoriteDictinary.value(forKey: "openingtime")) != nil){
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                setOpeningTimeToArray(opTimeString: (favoriteDictinary.value(forKey: "openingtime"))! as! String, opTitleString: (favoriteDictinary.value(forKey: "openingtitle"))! as! String, clTimeString: (favoriteDictinary.value(forKey: "closingtime"))! as! String, clTitleString: (favoriteDictinary.value(forKey: "closingtitle"))! as! String)
            }
            else {
                setOpeningTimeToArray(opTimeString: (favoriteDictinary.value(forKey: "openingtime_arabic"))! as! String, opTitleString: (favoriteDictinary.value(forKey: "openingtitle_arabic"))! as! String, clTimeString: (favoriteDictinary.value(forKey: "closingtime_arabic"))! as! String, clTitleString: (favoriteDictinary.value(forKey: "closingtitle_arabic"))! as! String)
            }
        }
        if (((favoriteDictinary.value(forKey: "email")) != nil) && ((favoriteDictinary.value(forKey: "email")as! String ) != "")){
            
            informationDetails = [ "key" : "service_provider_mail_account","value"  :(favoriteDictinary.value(forKey: "email"))! as! String ,"imageName": "email" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "facebookpage")) != nil) && ((favoriteDictinary.value(forKey: "facebookpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_facebook_page","value" :(favoriteDictinary.value(forKey: "facebookpage"))! as! String ,"imageName": "facebook"]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "instagrampage")) != nil) && ((favoriteDictinary.value(forKey: "instagrampage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_instagram_page", "value" :(favoriteDictinary.value(forKey: "instagrampage"))! as! String,"imageName": "instagram" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "twitterpage")) != nil) && ((favoriteDictinary.value(forKey: "twitterpage") as! String) != "twitter")){
            
            informationDetails = [ "key" : "service_provider_twitter_page", "value"  :(favoriteDictinary.value(forKey: "twitterpage"))! as! String ,"imageName": "twitter" ]
            informationArray.add(informationDetails)
        }
        
        if (((favoriteDictinary.value(forKey: "snapchatpage")) != nil) && ((favoriteDictinary.value(forKey: "snapchatpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_snapchat_page", "value" :(favoriteDictinary.value(forKey: "snapchatpage"))! as! String,"imageName": "snapchat" ]
            informationArray.add(informationDetails)
        }
        detailTableView.reloadData()
    }
    func setHistoryInformationData()
    {
        if (historyDict?.mobile != nil){
            
            informationDetails = ["key" : "service_provider_mobile_number","value" :(historyDict?.mobile)! ,"imageName": "phone"]
            informationArray.add(informationDetails)
        }
        if ((historyDict?.website) != nil){
            
            informationDetails = [ "key" : "service_provider_website","value" :(historyDict?.website)! ,"imageName": "website" ]
            informationArray.add(informationDetails)
        }
        if((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.text = historyDict?.name
            locationLabel.text = historyDict?.shortdescription
            if ((historyDict?.address) != nil){
                
                informationDetails = [ "key" : "service_provider_address","value" :(historyDict?.address)! ,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        else {
            titleLabel.text = historyDict?.arabicname
            locationLabel.text = historyDict?.arabiclocation
            if ((historyDict?.address) != nil){
                informationDetails = [ "key" : "service_provider_address","value" :(historyDict?.arabicaddress)! ,"imageName": "location"  ]
                informationArray.add(informationDetails)
            }
        }
        if ((historyDict?.openingtime) != nil){
             if((LocalizationLanguage.currentAppleLanguage()) == "en") {
                setOpeningTimeToArray(opTimeString: (historyDict?.openingtime)!, opTitleString: (historyDict?.openingtitle)!, clTimeString: (historyDict?.closingtime)!, clTitleString: (historyDict?.closingtitle)!)
            }
             else {
                setOpeningTimeToArray(opTimeString: (historyDict?.openingtime_arabic)!, opTitleString: (historyDict?.openingtitle_arabic)!, clTimeString: (historyDict?.closingtime_arabic)!, clTitleString: (historyDict?.closingtitle_arabic)!)
            }
        }
        if (((historyDict?.email) != nil) && ((historyDict?.email ) != "")){
            informationDetails = [ "key" : "service_provider_mail_account","value"  :(historyDict?.email)!  ,"imageName": "email" ]
            informationArray.add(informationDetails)
        }
        if (((historyDict?.facebookpage) != nil) && ((historyDict?.facebookpage) != "")){
            
            informationDetails = [ "key" : "service_provider_facebook_page","value" :(historyDict?.facebookpage)!  ,"imageName": "facebook"]
            informationArray.add(informationDetails)
        }
        if (((historyDict?.instagrampage) != nil) && ((historyDict?.instagrampage) != "")){
            
            informationDetails = [ "key" : "service_provider_instagram_page", "value" :(historyDict?.instagrampage)! ,"imageName": "instagram" ]
            informationArray.add(informationDetails)
        }
        if (((historyDict?.twitterpage) != nil) && ((historyDict?.twitterpage) != "")){
            
            informationDetails = [ "key" : "service_provider_twitter_page", "value"  :(historyDict?.twitterpage)! ,"imageName": "twitter" ]
            informationArray.add(informationDetails)
        }
        if (((historyDict?.snapchatpage) != nil) && ((historyDict?.snapchatpage) != "")){
            
            informationDetails = [ "key" : "service_provider_snapchat_page", "value" :(historyDict?.snapchatpage)! ,"imageName": "snapchat" ]
            informationArray.add(informationDetails)
        }
        detailTableView.reloadData()
    }
    func setOpeningTimeToArray(opTimeString : String,opTitleString: String,clTimeString:String,clTitleString: String) {
        let appendString = opTimeString + " " + opTitleString + " " + "-" + " " + clTimeString + " " + clTitleString
        informationDetails = [ "key" : "service_provider_opening_time","value" : appendString,"imageName": "time" ]
        informationArray.add(informationDetails)
    }
    @IBAction func didTapFavorite(_ sender: UIButton) {
        let managedContext = getContext()
        if (fromFavorite == true){
            if (favoriteDeleted == true){
                favoriteDeleted = false
                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
                saveFavoriteDetailsToCoreData()
            }
            else{
                favoriteDeleted = true
                let favoritesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
                guard let serviceId = (favoriteDictinary.value(forKey: "id")) else{
                    return
                }
                favoritesFetchRequest.predicate = NSPredicate.init(format: "id ==\(serviceId)")
                let fetchResults = try! managedContext.fetch(favoritesFetchRequest)
                if (fetchResults.count != 0){
                    favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
                    for fetResult in fetchResults{
                        managedContext.delete(fetResult)
                    }
                    do {
                        try managedContext.save()
                        self.view.hideAllToasts()
                        let favoriteRemovedMessage =  NSLocalizedString("Removed_from_favorites", comment: "Removed from favorite message")
                        self.view.makeToast(favoriteRemovedMessage)
                    } catch {
                        print("error")
                    }
                }
                else{
                    favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
                    self.view.hideAllToasts()
                    let favoriteaddedMessage =  NSLocalizedString("Added_to_favorite", comment: "Addedc to favorite message")
                    self.view.makeToast(favoriteaddedMessage)
                }
            }
        }
        else if (fromHistory == false){
            let favFetchResults = checkAddedToFavorites(serviceId: (serviceProviderArrayDict?.id)!,entityNameString: "FavoriteEntity")
            if (favFetchResults.count == 0){
                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
                saveDetailsToCoreData()
            }
            else{
                favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
                for fetResult in favFetchResults{
                    managedContext.delete(fetResult)
                    self.view.hideAllToasts()
                    let favoriteRemovedMessage =  NSLocalizedString("Removed_from_favorites", comment: "Removed from favorite message")
                    self.view.makeToast(favoriteRemovedMessage)
                }
                do {
                    try managedContext.save()
                } catch {
                    print("error")
                }
            }
        }
            //From History page
        else{
            let favFetchResults = checkAddedToFavorites(serviceId: Int((historyDict?.id)!),entityNameString: "FavoriteEntity")
            if (favFetchResults.count == 0){
                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
                saveFavoriteToCoreDataUsingHistory()
            }
            else{
                favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
                for fetResult in favFetchResults{
                    managedContext.delete(fetResult)
                    self.view.hideAllToasts()
                    let favoriteRemovedMessage =  NSLocalizedString("Removed_from_favorites", comment: "Removed from favorite message")
                    self.view.makeToast(favoriteRemovedMessage)
                }
                do {
                    try managedContext.save()
                } catch {
                    print("error")
                }
            }
        }
    }
    //MARK: Favorite Coredata
    func saveDetailsToCoreData()
    {
        let managedContext = getContext()
        //set values to coredata
        guard let nameString = (serviceProviderArrayDict?.service_provider_name) else{
            return
        }
        guard let arabicNameString = (serviceProviderArrayDict?.service_provider_name_arabic) else{
            return
        }
        guard let address = (serviceProviderArrayDict?.service_provider_address) else{
            return
        }
        guard let arabicAddress = (serviceProviderArrayDict?.service_provider_address_arabic) else{
            return
        }
        guard let shortDescription = (serviceProviderArrayDict?.service_provider_location) else{
            return
        }
        guard let arabicLocation = (serviceProviderArrayDict?.service_provider_location_arabic) else{
            return
        }
        guard let category = (serviceProviderArrayDict?.service_provider_category) else{
            return
        }
        guard let arabicCategory = (serviceProviderArrayDict?.service_provider_category_arabic) else{
            return
        }
        guard let logoImage = (serviceProviderArrayDict?.service_provider_logo) else{
            return
        }
        guard let serviceId = (serviceProviderArrayDict?.id) else{
            return
        }
        guard let email = (serviceProviderArrayDict?.service_provider_mail_account) else{
            return
        }
        guard let websitePage = (serviceProviderArrayDict?.service_provider_website) else{
            return
        }
        guard let mobile = (serviceProviderArrayDict?.service_provider_mobile_number) else{
            return
        }
        guard let mapLocation = (serviceProviderArrayDict?.service_provider_map_location) else{
            return
        }
        guard let openingTime = (serviceProviderArrayDict?.service_provider_opening_time) else{
            return
        }
        guard let openingTitle = (serviceProviderArrayDict?.service_provider_opening_title) else{
            return
        }
        guard let openingTimeArabic = (serviceProviderArrayDict?.service_provider_opening_time_arabic) else{
            return
        }
        guard let openingTitleArabic = (serviceProviderArrayDict?.service_provider_opening_title_arabic) else{
            return
        }
        guard let closingTime = (serviceProviderArrayDict?.service_provider_closing_time) else{
            return
        }
        guard let closingTimeArabic = (serviceProviderArrayDict?.service_provider_closing_time_arabic) else{
            return
        }
        guard let closingTitle = (serviceProviderArrayDict?.service_provider_closing_title) else{
            return
        }
        guard let closingTitleArabic = (serviceProviderArrayDict?.service_provider_closing_title_arabic) else{
            return
        }
        guard let facebookPage = (serviceProviderArrayDict?.service_provider_facebook_page) else{
            return
        }
        guard let instagramPage = (serviceProviderArrayDict?.service_provider_instagram_page) else{
            return
        }
        guard let twitterPage = (serviceProviderArrayDict?.service_provider_twitter_page) else{
            return
        }
        guard let snapChatPage = (serviceProviderArrayDict?.service_provider_snapchat_page) else{
            return
        }
        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
        favoriteAttribute.setValue(serviceId, forKey: "id")
        favoriteAttribute.setValue(address, forKey: "address")
        favoriteAttribute.setValue(arabicAddress, forKey: "arabicaddress")
        favoriteAttribute.setValue(category, forKey: "category")
        favoriteAttribute.setValue(arabicCategory, forKey: "arabiccategory")
        favoriteAttribute.setValue(email, forKey: "email")
        favoriteAttribute.setValue(websitePage, forKey: "website")
        favoriteAttribute.setValue(mobile, forKey: "mobile")
        favoriteAttribute.setValue(mapLocation, forKey: "maplocation")
        favoriteAttribute.setValue(openingTime, forKey: "openingtime")
        favoriteAttribute.setValue(openingTitle, forKey: "openingtitle")
        favoriteAttribute.setValue(openingTimeArabic, forKey: "openingtime_arabic")
        favoriteAttribute.setValue(openingTitleArabic, forKey: "openingtitle_arabic")
        favoriteAttribute.setValue(closingTime, forKey: "closingtime")
        favoriteAttribute.setValue(closingTitle, forKey: "closingtitle")
        favoriteAttribute.setValue(closingTimeArabic, forKey: "closingtime_arabic")
        favoriteAttribute.setValue(closingTitleArabic, forKey: "closingtitle_arabic")
        favoriteAttribute.setValue(facebookPage, forKey: "facebookpage")
        favoriteAttribute.setValue(instagramPage, forKey: "instagrampage")
        favoriteAttribute.setValue(twitterPage, forKey: "twitterpage")
        favoriteAttribute.setValue(snapChatPage, forKey: "snapchatpage")
        favoriteAttribute.setValue(nameString, forKey: "name")
        favoriteAttribute.setValue(arabicNameString, forKey: "arabicname")
        favoriteAttribute.setValue(logoImage, forKey: "imgurl")
        favoriteAttribute.setValue(shortDescription, forKey: "shortdescription")
        favoriteAttribute.setValue(arabicLocation, forKey: "arabiclocation")
        favoriteAttribute.setValue(Date(), forKey: "favoritedate")
        do {
            try managedContext.save()
            self.view.hideAllToasts()
            let favoriteaddedMessage =  NSLocalizedString("Added_to_favorite", comment: "Addedc to favorite message")
            self.view.makeToast(favoriteaddedMessage)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveFavoriteDetailsToCoreData()
    {
        let managedContext = getContext()
        //set values to coredata
        guard let nameString = favoriteDictinary.value(forKey: "name") else{
            return
        }
        guard let arabicNameString = favoriteDictinary.value(forKey: "arabicname") else {
            return
        }
        guard let address = favoriteDictinary.value(forKey: "address") else {
            return
        }
        guard let arabicaddress = favoriteDictinary.value(forKey: "arabicaddress") else {
            return
        }
        guard let shortDescription = (favoriteDictinary.value(forKey: "shortdescription")) else {
            return
        }
        guard let arabicLocation = (favoriteDictinary.value(forKey: "arabiclocation")) else {
            return
        }
        guard let category = (favoriteDictinary.value(forKey: "category")) else {
            return
        }
        guard let arabicCategory = (favoriteDictinary.value(forKey: "arabiccategory")) else {
            return
        }
        guard let logoImage = (favoriteDictinary.value(forKey: "imgurl")) else {
            return
        }
        guard let serviceId = (favoriteDictinary.value(forKey: "id")) else {
           return
        }
        guard let email = (favoriteDictinary.value(forKey: "email")) else {
            return
        }
        guard let websitePage = (favoriteDictinary.value(forKey: "website")) else {
            return
        }
        guard let mobile = (favoriteDictinary.value(forKey: "mobile")) else {
            return
        }
        guard let mapLocation = (favoriteDictinary.value(forKey: "maplocation")) else {
            return
        }
        guard let facebookPage = (favoriteDictinary.value(forKey: "facebookpage")) else {
            return
        }
        guard let instagramPage = (favoriteDictinary.value(forKey: "instagrampage")) else {
            return
        }
        guard let twitterPage = (favoriteDictinary.value(forKey: "twitterpage")) else {
            return
        }
        guard let snapChatPage = (favoriteDictinary.value(forKey: "snapchatpage")) else {
            return
        }
        guard let openingTime = (favoriteDictinary.value(forKey: "openingtime")) else {
            return
        }
        guard let openingTitle = (favoriteDictinary.value(forKey: "openingtitle")) else {
            return
        }
        guard let openingtimeArabic = (favoriteDictinary.value(forKey: "openingtime_arabic")) else {
            return
        }
        guard let openingTitleArabic = (favoriteDictinary.value(forKey: "openingtitle_arabic")) else {
            return
        }
        guard let closingTime = (favoriteDictinary.value(forKey: "closingtime")) else {
            return
        }
        guard let closingTimeArabic = (favoriteDictinary.value(forKey: "closingtime_arabic")) else {
            return
        }
        guard let closingTitle = (favoriteDictinary.value(forKey: "closingtitle")) else {
            return
        }
        guard let closingtitleArabic = (favoriteDictinary.value(forKey: "closingtitle_arabic")) else {
            return
        }
        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
        
        favoriteAttribute.setValue(nameString, forKey: "name")
        favoriteAttribute.setValue(arabicNameString, forKey: "arabicname")
        favoriteAttribute.setValue(address, forKey: "address")
        favoriteAttribute.setValue(arabicaddress, forKey: "arabicaddress")
        favoriteAttribute.setValue(shortDescription, forKey: "shortdescription")
        favoriteAttribute.setValue(arabicLocation, forKey: "arabiclocation")
        favoriteAttribute.setValue(category, forKey: "category")
        favoriteAttribute.setValue(arabicCategory, forKey: "arabiccategory")
        favoriteAttribute.setValue(logoImage, forKey: "imgurl")
        favoriteAttribute.setValue(serviceId, forKey: "id")
        favoriteAttribute.setValue(email, forKey: "email")
        favoriteAttribute.setValue(websitePage, forKey: "website")
        favoriteAttribute.setValue(mobile, forKey: "mobile")
        favoriteAttribute.setValue(mapLocation, forKey: "maplocation")
        favoriteAttribute.setValue(facebookPage, forKey: "facebookpage")
        favoriteAttribute.setValue(instagramPage, forKey: "instagrampage")
        favoriteAttribute.setValue(twitterPage, forKey: "twitterpage")
        favoriteAttribute.setValue(snapChatPage, forKey: "snapchatpage")
        favoriteAttribute.setValue(openingTime, forKey: "openingtime")
        favoriteAttribute.setValue(openingTitle, forKey: "openingtitle")
        favoriteAttribute.setValue(openingtimeArabic, forKey: "openingtime_arabic")
        favoriteAttribute.setValue(openingTitleArabic, forKey: "openingtitle_arabic")
        favoriteAttribute.setValue(closingTime, forKey: "closingtime")
        favoriteAttribute.setValue(closingTitle, forKey: "closingtitle")
        favoriteAttribute.setValue(closingTimeArabic, forKey: "closingtime_arabic")
         favoriteAttribute.setValue(closingtitleArabic, forKey: "closingtitle_arabic")
        favoriteAttribute.setValue(Date(), forKey: "favoritedate")
        do {
            try managedContext.save()
            self.view.hideAllToasts()
            let favoriteaddedMessage =  NSLocalizedString("Added_to_favorite", comment: "Addedc to favorite message")
            self.view.makeToast(favoriteaddedMessage)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveFavoriteToCoreDataUsingHistory()
    {
        let managedContext = getContext()
        //set values to coredata
        guard let nameString = (historyDict?.name) else{
            return
        }
        guard let arabicNameString = (historyDict?.arabicname) else{
            return
        }
        guard let address = (historyDict?.address) else{
            return
        }
        guard let arabicAddress = (historyDict?.arabicaddress) else{
            return
        }
        guard let shortDescription = (historyDict?.shortdescription) else{
            return
        }
        guard let arabicLocation = (historyDict?.arabiclocation) else{
            return
        }
        guard let category = (historyDict?.category) else{
            return
        }
        guard let arabicCategory = (historyDict?.arabiccategory) else{
            return
        }
        guard let logoImage = (historyDict?.imgurl) else{
            return
        }
        guard let serviceId = (historyDict?.id) else{
            return
        }
        guard let email = (historyDict?.email) else{
            return
        }
        guard let websitePage = (historyDict?.website) else{
            return
        }
        guard let mobile = (historyDict?.mobile) else{
            return
        }
        guard let mapLocation = (historyDict?.maplocation) else{
            return
        }
        guard let openingTime = (historyDict?.openingtime) else{
            return
        }
        guard let openingTimeTitle = (historyDict?.openingtitle) else{
            return
        }
        guard let openingTimeArabic = (historyDict?.openingtime_arabic) else{
            return
        }
        guard let openingTitleArabic = (historyDict?.openingtitle_arabic) else{
            return
        }
        guard let closingTime = (historyDict?.closingtime) else{
            return
        }
        guard let closingTimeTitle = (historyDict?.closingtitle) else{
            return
        }
        guard let closingTimeArabic = (historyDict?.closingtime_arabic) else{
            return
        }
        guard let closingTitleArabic = (historyDict?.closingtitle_arabic) else{
            return
        }
        guard let facebookPage = (historyDict?.facebookpage) else{
            return
        }
        guard let instagramPage = (historyDict?.instagrampage) else{
            return
        }
        guard let twitterPage = (historyDict?.twitterpage) else{
            return
        }
        guard let snapChatPage = (historyDict?.snapchatpage) else{
            return
        }
        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
        favoriteAttribute.setValue(serviceId, forKey: "id")
        favoriteAttribute.setValue(address, forKey: "address")
        favoriteAttribute.setValue(arabicAddress, forKey: "arabicaddress")
        favoriteAttribute.setValue(category, forKey: "category")
        favoriteAttribute.setValue(arabicCategory, forKey: "arabiccategory")
        favoriteAttribute.setValue(email, forKey: "email")
        favoriteAttribute.setValue(websitePage, forKey: "website")
        favoriteAttribute.setValue(mobile, forKey: "mobile")
        favoriteAttribute.setValue(mapLocation, forKey: "maplocation")
        favoriteAttribute.setValue(openingTime, forKey: "openingtime")
        favoriteAttribute.setValue(openingTimeTitle, forKey: "openingtitle")
        favoriteAttribute.setValue(openingTimeArabic, forKey: "openingtime_arabic")
        favoriteAttribute.setValue(openingTitleArabic, forKey: "openingtitle_arabic")
        favoriteAttribute.setValue(closingTime, forKey: "closingtime")
        favoriteAttribute.setValue(closingTimeTitle, forKey: "closingtitle")
        favoriteAttribute.setValue(closingTimeArabic, forKey: "closingtime_arabic")
        favoriteAttribute.setValue(closingTitleArabic, forKey: "closingtitle_arabic")
        favoriteAttribute.setValue(facebookPage, forKey: "facebookpage")
        favoriteAttribute.setValue(instagramPage, forKey: "instagrampage")
        favoriteAttribute.setValue(twitterPage, forKey: "twitterpage")
        favoriteAttribute.setValue(snapChatPage, forKey: "snapchatpage")
        favoriteAttribute.setValue(nameString, forKey: "name")
        favoriteAttribute.setValue(arabicNameString, forKey: "arabicname")
        favoriteAttribute.setValue(logoImage, forKey: "imgurl")
        favoriteAttribute.setValue(shortDescription, forKey: "shortdescription")
        favoriteAttribute.setValue(arabicLocation, forKey: "arabiclocation")
        favoriteAttribute.setValue(Date(), forKey: "favoritedate")
        do {
            try managedContext.save()
            self.view.hideAllToasts()
            let favoriteaddedMessage =  NSLocalizedString("Added_to_favorite", comment: "Addedc to favorite message")
            self.view.makeToast(favoriteaddedMessage)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveHistoryDataToCoreData(){
       let managedContext = getContext()
        if(fromHistory == true) {
            guard let nameString = (historyDict?.name) else{
                return
            }
            guard let arabicNameString = (historyDict?.arabicname) else{
                return
            }
            guard let address = (historyDict?.address) else{
                return
            }
            guard let arabicAddress = (historyDict?.arabicaddress) else{
                return
            }
            guard let shortDescription = (historyDict?.shortdescription) else{
                return
            }
            guard let arabicLocation = (historyDict?.arabiclocation) else{
                return
            }
            guard let category = (historyDict?.category) else{
                return
            }
            guard let arabicCategory = (historyDict?.arabiccategory) else{
                return
            }
            guard let logoImage = (historyDict?.imgurl) else{
                return
            }
            guard let serviceId = (historyDict?.id) else{
                return
            }
            guard let email = (historyDict?.email) else{
                return
            }
            guard let websitePage = (historyDict?.website) else{
                return
            }
            guard let mobile = (historyDict?.mobile) else{
                return
            }
            guard let mapLocation = (historyDict?.maplocation) else{
                return
            }
            guard let openingTime = (historyDict?.openingtime) else{
                return
            }
            guard let openingTimeTitle = (historyDict?.openingtitle) else{
                return
            }
            guard let openingTimeArabic = (historyDict?.openingtime_arabic) else{
                return
            }
            guard let openingTitleArabic = (historyDict?.openingtitle_arabic) else{
                return
            }
            guard let closingTime = (historyDict?.closingtime) else{
                return
            }
            guard let closingTimeTitle = (historyDict?.closingtitle) else{
                return
            }
            guard let closingTimeArabic = (historyDict?.closingtime_arabic) else{
                return
            }
            guard let closingTitleArabic = (historyDict?.closingtitle_arabic) else{
                return
            }
            guard let facebookPage = (historyDict?.facebookpage) else{
                return
            }
            guard let instagramPage = (historyDict?.instagrampage) else{
                return
            }
            guard let twitterPage = (historyDict?.twitterpage) else{
                return
            }
            guard let snapChatPage = (historyDict?.snapchatpage) else{
                return
            }
            let historyInfo: HistoryEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedContext) as! HistoryEntity
            historyInfo.name = nameString
            historyInfo.arabicname = arabicNameString
            historyInfo.address = address
            historyInfo.arabicaddress = arabicAddress
            historyInfo.category = category
            historyInfo.arabiccategory = arabicCategory
            historyInfo.email = email
            historyInfo.facebookpage = facebookPage
            historyInfo.id = Int32(serviceId)
            historyInfo.imgurl = logoImage
            historyInfo.instagrampage = instagramPage
            historyInfo.maplocation = mapLocation
            historyInfo.mobile = mobile
            historyInfo.openingtime = openingTime
            historyInfo.openingtitle = openingTimeTitle
            historyInfo.openingtime_arabic = openingTimeArabic
            historyInfo.openingtitle_arabic = openingTitleArabic
            historyInfo.closingtime = closingTime
            historyInfo.closingtitle = closingTimeTitle
            historyInfo.closingtime_arabic = closingTimeArabic
            historyInfo.closingtitle_arabic = closingTitleArabic
            historyInfo.shortdescription = shortDescription
            historyInfo.arabiclocation = arabicLocation
            historyInfo.snapchatpage = snapChatPage
            historyInfo.twitterpage = twitterPage
            historyInfo.website = websitePage
            historyInfo.date_history = Date()
        }
        if(fromFavorite == false) {
            guard let nameString = (serviceProviderArrayDict?.service_provider_name) else{
                return
            }
            guard let arabicNameString = (serviceProviderArrayDict?.service_provider_name_arabic) else{
                return
            }
            guard let address = (serviceProviderArrayDict?.service_provider_address) else{
                return
            }
            guard let arabicAddress = (serviceProviderArrayDict?.service_provider_address_arabic) else{
                return
            }
            guard let shortDescription = (serviceProviderArrayDict?.service_provider_location) else{
                return
            }
            guard let arabicLocation = (serviceProviderArrayDict?.service_provider_location_arabic) else{
                return
            }
            guard let category = (serviceProviderArrayDict?.service_provider_category) else{
                return
            }
            guard let arabicCategory = (serviceProviderArrayDict?.service_provider_category_arabic) else{
                return
            }
            guard let logoImage = (serviceProviderArrayDict?.service_provider_logo) else{
                return
            }
            guard let serviceId = (serviceProviderArrayDict?.id) else{
                return
            }
            guard let email = (serviceProviderArrayDict?.service_provider_mail_account) else{
                return
            }
            guard let websitePage = (serviceProviderArrayDict?.service_provider_website) else{
                return
            }
            guard let mobile = (serviceProviderArrayDict?.service_provider_mobile_number) else{
                return
            }
            guard let mapLocation = (serviceProviderArrayDict?.service_provider_map_location) else{
                return
            }
            guard let openingTime = (serviceProviderArrayDict?.service_provider_opening_time) else{
                return
            }
            guard let openingTitle = (serviceProviderArrayDict?.service_provider_opening_title) else{
                return
            }
            guard let openingTimeArabic = (serviceProviderArrayDict?.service_provider_opening_time_arabic) else{
                return
            }
            guard let openingTitleArabic = (serviceProviderArrayDict?.service_provider_opening_title_arabic) else{
                return
            }
            guard let closingTime = (serviceProviderArrayDict?.service_provider_closing_time) else{
                return
            }
            guard let closingTitle = (serviceProviderArrayDict?.service_provider_closing_title) else{
                return
            }
            guard let closingTimeArabic = (serviceProviderArrayDict?.service_provider_closing_time_arabic) else{
                return
            }
            guard let closingTitlerabic = (serviceProviderArrayDict?.service_provider_closing_title_arabic) else{
                return
            }
            guard let facebookPage = (serviceProviderArrayDict?.service_provider_facebook_page) else{
                return
            }
            guard let instagramPage = (serviceProviderArrayDict?.service_provider_instagram_page) else{
                return
            }
            guard let twitterPage = (serviceProviderArrayDict?.service_provider_twitter_page) else{
                return
            }
            guard let snapChatPage = (serviceProviderArrayDict?.service_provider_snapchat_page) else{
                return
            }
            let historyInfo: HistoryEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedContext) as! HistoryEntity
            historyInfo.name = nameString
            historyInfo.arabicname = arabicNameString
            historyInfo.address = address
            historyInfo.arabicaddress = arabicAddress
            historyInfo.arabiclocation = arabicLocation
            historyInfo.category = category
            historyInfo.arabiccategory = arabicCategory
            historyInfo.email = email
            historyInfo.facebookpage = facebookPage
            historyInfo.id = Int32(serviceId)
            historyInfo.imgurl = logoImage
            historyInfo.instagrampage = instagramPage
            historyInfo.maplocation = mapLocation
            historyInfo.mobile = mobile
            historyInfo.openingtime = openingTime
            historyInfo.openingtitle = openingTitle
            historyInfo.openingtime_arabic = openingTimeArabic
            historyInfo.openingtitle_arabic = openingTitleArabic
            historyInfo.closingtime = closingTime
            historyInfo.closingtitle = closingTitle
            historyInfo.closingtime_arabic = closingTimeArabic
            historyInfo.closingtitle_arabic = closingTitlerabic
            historyInfo.shortdescription = shortDescription
            historyInfo.snapchatpage = snapChatPage
            historyInfo.twitterpage = twitterPage
            historyInfo.website = websitePage
            historyInfo.date_history = Date()
        }
        else {
            guard let nameString = (favoriteDictinary.value(forKey: "name") ) else{
                return
            }
            guard let arabicNameString = (favoriteDictinary.value(forKey: "arabicname") ) else{
                return
            }
            guard let address = (favoriteDictinary.value(forKey: "address") ) else{
                return
            }
            guard let arabicAddress = (favoriteDictinary.value(forKey: "arabicaddress") ) else{
                return
            }
            guard let shortDescription = (favoriteDictinary.value(forKey: "shortdescription") ) else{
                return
            }
            guard let arabicLocation = (favoriteDictinary.value(forKey: "arabiclocation") ) else{
                return
            }
            guard let category = (favoriteDictinary.value(forKey: "category") ) else{
                return
            }
            guard let arabicCategory = (favoriteDictinary.value(forKey: "arabiccategory") ) else{
                return
            }
            guard let logoImage = (favoriteDictinary.value(forKey: "imgurl") ) else{
                return
            }
            guard let serviceId = (favoriteDictinary.value(forKey: "id") as? Int ) else{
                return
            }
            guard let email = (favoriteDictinary.value(forKey: "email") ) else{
                return
            }
            guard let websitePage = (favoriteDictinary.value(forKey: "website") ) else{
                return
            }
            guard let mobile = (favoriteDictinary.value(forKey: "mobile") ) else{
                return
            }
            guard let mapLocation = (favoriteDictinary.value(forKey: "maplocation") ) else{
                return
            }
            guard let openingTime = (favoriteDictinary.value(forKey: "openingtime") ) else{
                return
            }
            guard let openingTitle = (favoriteDictinary.value(forKey: "openingtitle")) else {
                return
            }
            guard let openingtimeArabic = (favoriteDictinary.value(forKey: "openingtime_arabic")) else {
                return
            }
            guard let openingTitleArabic = (favoriteDictinary.value(forKey: "openingtitle_arabic")) else {
                return
            }
            guard let closingTime = (favoriteDictinary.value(forKey: "closingtime")) else {
                return
            }
            guard let closingTimeArabic = (favoriteDictinary.value(forKey: "closingtime_arabic")) else {
                return
            }
            guard let closingTitle = (favoriteDictinary.value(forKey: "closingtitle")) else {
                return
            }
            guard let closingtitleArabic = (favoriteDictinary.value(forKey: "closingtitle_arabic")) else {
                return
            }
            guard let facebookPage = (favoriteDictinary.value(forKey: "facebookpage") ) else{
                return
            }
            guard let instagramPage = (favoriteDictinary.value(forKey: "instagrampage") ) else{
                return
            }
            guard let twitterPage = (favoriteDictinary.value(forKey: "twitterpage") ) else{
                return
            }
            guard let snapChatPage = (favoriteDictinary.value(forKey: "snapchatpage") ) else{
                return
            }
            let historyInfo: HistoryEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedContext) as! HistoryEntity
            historyInfo.address = address as? String
            historyInfo.arabicaddress = arabicAddress as? String
            historyInfo.category = category as? String
            historyInfo.arabiccategory = arabicCategory as? String
            historyInfo.email = email as? String
            historyInfo.facebookpage = facebookPage as? String
            historyInfo.id = Int32(serviceId)
            historyInfo.imgurl = logoImage as? String
            historyInfo.instagrampage = instagramPage as? String
            historyInfo.maplocation = mapLocation as? String
            historyInfo.mobile = mobile as? String
            historyInfo.name = nameString as? String
            historyInfo.arabicname = arabicNameString as? String
            historyInfo.openingtime = openingTime as? String
            historyInfo.openingtitle = openingTitle as? String
            historyInfo.openingtime_arabic = openingtimeArabic as? String
            historyInfo.openingtitle_arabic = openingTitleArabic as? String
            historyInfo.closingtime = closingTime as? String
            historyInfo.closingtitle = closingTitle as? String
            historyInfo.closingtime_arabic = closingTimeArabic as? String
            historyInfo.closingtitle_arabic = closingtitleArabic as? String
            historyInfo.shortdescription = shortDescription as? String
            historyInfo.arabiclocation = arabicLocation as? String
            historyInfo.snapchatpage = snapChatPage as? String
            historyInfo.twitterpage = twitterPage as? String
            historyInfo.website = websitePage as? String
            historyInfo.date_history = Date()
        }
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func getContext() -> NSManagedObjectContext{
        
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        if #available(iOS 10.0, *) {
            return
                appDelegate!.persistentContainer.viewContext
        } else {
            return appDelegate!.managedObjectContext
        }
    }
    func checkAddedToFavorites(serviceId: Int, entityNameString: String) -> [NSManagedObject]
    {
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let favoritesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityNameString)
        favoritesFetchRequest.predicate = NSPredicate.init(format: "id ==\(serviceId)")
        fetchResults = try! managedContext.fetch(favoritesFetchRequest)
        return fetchResults
    }
    func fetchHistoryInfo(idValue: Int){
        var historyArray: [HistoryEntity] = []
        let managedContext = getContext()
        let historyFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEntity")
        let sort = NSSortDescriptor(key: #keyPath(HistoryEntity.date_history), ascending: false)
        historyFetchRequest.sortDescriptors = [sort]
        historyFetchRequest.predicate = NSPredicate.init(format: "id ==\(idValue)")
        do {
            historyArray = (try managedContext.fetch(historyFetchRequest) as? [HistoryEntity])!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (historyArray.count == 0){
            saveHistoryDataToCoreData()
        }
        else{
            let fetchResult = historyArray[0]
            let objectUpdate = fetchResult
            let isSameDate = Calendar.current.isDate(objectUpdate.date_history!, inSameDayAs:Date())
            if(isSameDate) {
                objectUpdate.date_history = Date()
                do{
                    try managedContext.save()
                }
                catch{
                    print(error)
                }
            }
            else {
                saveHistoryDataToCoreData()
            }
        }
    }
    func setFontForInformationPage() {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.font = UIFont(name: "Lato-Bold", size: titleLabel.font.pointSize)
            locationLabel.font = UIFont(name: "Lato-Italic", size: locationLabel.font.pointSize)
        }
        else {
            titleLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: titleLabel.font.pointSize)
            locationLabel.font = UIFont(name: "GESSUniqueLight-Light", size: locationLabel.font.pointSize)
        }
    }
}

