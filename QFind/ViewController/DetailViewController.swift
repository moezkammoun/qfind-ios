 //
//  DetailViewController.swift
//  QFind
//
//  Created by Exalture on 16/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import CoreData
import Crashlytics
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
    @IBOutlet var timePopup: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var detailLoadingView: LoadingView!
    @IBOutlet weak var timePopupInnerView: UIView!
    var serviceProviderArrayDict: ServiceProvider?
    var informationDetails = [String : String]()
    var informationArray = NSMutableArray()
    var fromFavorite: Bool? = false
    var fromHistory: Bool? = false
    var fromSearch: Bool? = false
    var favoriteDeleted : Bool? = false
    var favoriteDictinary = NSMutableDictionary()
    var historyDict: HistoryEntity?
    var informationId = Int32()
    let networkReachability = NetworkReachabilityManager()
    var serviceProviderId: Int? = nil
    var weekWorkingTimeArray = NSMutableArray()
    var weekWorkingTime = [String : String]()
    var dayLabelFontSize =  CGFloat()
    @IBOutlet weak var bottombarHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomBarBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayThreeLabel: UILabel!
    @IBOutlet weak var dayFourLabel: UILabel!
    @IBOutlet weak var dayFiveLabel: UILabel!
    @IBOutlet weak var daySixLabel: UILabel!
    @IBOutlet weak var daySevenLabel: UILabel!
    @IBOutlet weak var dayNameOneLabel: UILabel!
    @IBOutlet weak var dayNameTwoLabel: UILabel!
    @IBOutlet weak var dayNameThreeLabel: UILabel!
    @IBOutlet weak var dayNameFourLabel: UILabel!
    @IBOutlet weak var dayNameFiveLabel: UILabel!
    @IBOutlet weak var dayNameSixLabel: UILabel!
    @IBOutlet weak var dayNameSevenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailLoadingView.isHidden = false
       detailLoadingView.showLoading()
        if (deepLinkId != nil) {
            serviceProviderId = deepLinkId
            
           
        }
        bottombarInitialSetup()
//        if(fromHistory == true){
//              getInformationFromServer()
//           // setHistoryInformationData()
//            //fetchHistoryInfo(idValue: Int((historyDict?.id)!))
//        }
//         else if(fromFavorite == false){
//            if (serviceProviderId != nil) {
                getInformationFromServer()
//            }
//            else {
//                fetchHistoryInfo(idValue: (serviceProviderArrayDict?.id)!)
//            }
     //   }
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
        let fetchData = checkAddedToFavorites(serviceId: serviceProviderId!, entityNameString: "FavoriteEntity")
        if (fetchData.count == 0){
            favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
        }
        else{
            favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
        }
//        if (fromFavorite == true){
//            //informationArray = NSMutableArray()
//            let fetchData = checkAddedToFavorites(serviceId: favoriteDictinary.value(forKey: "id") as! Int, entityNameString: "FavoriteEntity")
//            if (fetchData.count == 0){
//                favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
//            }
//            else{
//                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
//            }
//           // getInformationFromServer()
//            //setFavoriteInformationData()
//            /*vidya*/
//            //fetchHistoryInfo(idValue: favoriteDictinary.value(forKey: "id") as! Int)
//        }
//        else if (fromHistory == false){
//           // informationArray = NSMutableArray()
////            if (serviceProviderId == nil) {
////                 setInformationData()
////            }
//        }
//        else{
//            /*vidya*/
//            let fetchData = checkAddedToFavorites(serviceId: serviceProviderId!, entityNameString: "FavoriteEntity")
//            if (fetchData.count == 0){
//                favoriteButton.setImage(UIImage(named: "favoriteBlank"), for: .normal)
//            }
//            else{
//                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
//            }
//        }
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
        //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        deepLinkId = nil
        
        //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = homeViewController
    }
    func historyButtonPressed() {
        detailBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.history
        self.present(historyVC, animated: false, completion: nil)
    }
    @IBAction func didTapShare(_ sender: UIButton) {
        if  (networkReachability?.isReachable)! {
            let firstActivityItem = "QFind"
            
           // let secondActivityItem : NSURL = NSURL(string: "https://moushtarayatapp.com?provider_id=\(informationId)")!
             let secondActivityItem : NSURL = NSURL(string: "https://www.qfind.qa/site/play-store?provider_id=\(informationId)")!
            
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = (sender )
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            if (LocalizationLanguage.currentAppleLanguage() == "en") {
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: shareButton.frame.origin.x, y: shareButton.frame.origin.y, width: 0, height: 0)
        }
        else {
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 120, y: 150, width: 0, height: 0)
        }
//            activityViewController.excludedActivityTypes = [
//                UIActivityType.postToWeibo,
//                UIActivityType.print,
//                UIActivityType.assignToContact,
//                UIActivityType.saveToCameraRoll,
//                UIActivityType.addToReadingList,
//                UIActivityType.postToFlickr,
//                UIActivityType.postToVimeo,
//                UIActivityType.postToTencentWeibo
//            ]
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
                        webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
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
                        webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
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
        else if (informationDict["key"] == "service_provider_opening_time") {
            loadTimePopup()
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
                    webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                    
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
        else if (informationDict["key"] == "service_provider_instagram_page") {
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
                webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                self.present(webViewVc, animated: false, completion: nil)
            }
            }
            else{
                self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
            }
        }
        else if (informationDict["key"] == "service_provider_twitter_page"){
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
                    webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
                    self.present(webViewVc, animated: false, completion: nil)
                }
        }
        else{
            self.view.hideAllToasts()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
        }
        }
        else if (informationDict["key"] == "service_provider_snapchat_page") {
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
                    webViewVc.titleString = NSLocalizedString("QFind", comment: "QFind title Label in the webview page")
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
      
        
        if (deepLinkId != nil) {
             deepLinkId = nil
            
            //self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
            
        }
        else {
            
             self.dismiss(animated: false, completion: nil)
            
        }
       
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

        
        if (serviceProviderArrayDict?.serviceProviderTimeArray?.count != 0) {
        
            let serviceProviderTime = serviceProviderArrayDict?.serviceProviderTimeArray
            informationDetails = setOpeningClosingTime(serviceProviderWorkingTime: serviceProviderTime!)
            if (informationDetails.count != 0) {
                 informationArray.add(informationDetails)
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
        //if(( serviceProviderArrayDict?.id) != nil) {
            guard let idValue = serviceProviderArrayDict?.id else{
                return
            }
            //let idValue = serviceProviderArrayDict?.id
        informationId = Int32(idValue)
        //}
        detailTableView.reloadData()
        
    }
    func setOpeningClosingTime(serviceProviderWorkingTime: [ServiceProviderTime])-> [String : String] {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
        let currentDateString: String = dateFormatter.string(from: date)
        
        var informationDictValue = [String : String]()
        for var workigTime in serviceProviderWorkingTime {
          
             var popupAppendString = String()
                if ((LocalizationLanguage.currentAppleLanguage()) == "en") {

                     popupAppendString = (workigTime.service_provider_opening_time)! + " " + (workigTime.service_provider_opening_title)! + " " + "-" + " " + (workigTime.service_provider_closing_time)! + " " + (workigTime.service_provider_closing_title)!
            }
                else {
                      popupAppendString = (workigTime.service_provider_opening_time_arabic)! + " " + (workigTime.service_provider_opening_title_arabic)! + " " + "-" + " " + (workigTime.service_provider_closing_time_arabic)! + " " + (workigTime.service_provider_closing_title_arabic)!
            }
            if((workigTime.service_provider_opening_time)!.caseInsensitiveCompare("holiday") == ComparisonResult.orderedSame){
                        weekWorkingTime = [ "key" : "timeKey" ,"value" : "Closed", "dayValue" : workigTime.day!]
                        weekWorkingTimeArray.add(weekWorkingTime)
                       
                    }
                    else {
                        weekWorkingTime = [ "key" : "timeKey" ,"value" : popupAppendString, "dayValue" : workigTime.day!]
                weekWorkingTimeArray.add(weekWorkingTime)
                       
                    }
            let closedLabel = NSLocalizedString("Closed", comment: "closed label in timepopup")
                    if((workigTime.day)!.caseInsensitiveCompare(currentDateString) == ComparisonResult.orderedSame){

                        if((workigTime.service_provider_opening_time)!.caseInsensitiveCompare("holiday") == ComparisonResult.orderedSame){
                            informationDictValue = [ "key" : "service_provider_opening_time","value" : closedLabel,"imageName": "time" ]
                        }
                        else {
                            informationDictValue = [ "key" : "service_provider_opening_time","value" : popupAppendString,"imageName": "time" ]
                        }
                    }
                   
        }
        
        return informationDictValue
    }
   
    @IBAction func didTapFavorite(_ sender: UIButton) {
        let managedContext = getContext()

            let favFetchResults = checkAddedToFavorites(serviceId: serviceProviderId!,entityNameString: "FavoriteEntity")
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

        guard let shortDescription = (serviceProviderArrayDict?.service_provider_location) else{
            return
        }
        guard let arabicLocation = (serviceProviderArrayDict?.service_provider_location_arabic) else{
            return
        }

        guard let logoImage = (serviceProviderArrayDict?.service_provider_logo) else{
            return
        }
        guard let serviceId = (serviceProviderArrayDict?.id) else{
            return
        }

        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
        favoriteAttribute.setValue(serviceId, forKey: "id")

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

            guard let nameString = (serviceProviderArrayDict?.service_provider_name) else{
                return
            }
            guard let arabicNameString = (serviceProviderArrayDict?.service_provider_name_arabic) else{
                return
            }

            guard let shortDescription = (serviceProviderArrayDict?.service_provider_location) else{
                return
            }
            guard let arabicLocation = (serviceProviderArrayDict?.service_provider_location_arabic) else{
                return
            }

            guard let logoImage = (serviceProviderArrayDict?.service_provider_logo) else{
                return
            }
            guard let serviceId = (serviceProviderArrayDict?.id) else{
                return
            }

            let historyInfo: HistoryEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryEntity", into: managedContext) as! HistoryEntity

            
            historyInfo.name = nameString
            historyInfo.arabicname = arabicNameString

            historyInfo.arabiclocation = arabicLocation

            historyInfo.id = Int32(serviceId)
            historyInfo.imgurl = logoImage

            historyInfo.shortdescription = shortDescription
        
            historyInfo.date_history = Date()

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
    //MARK: Popup
    func loadTimePopup()
    {
        let testFrame : CGRect = self.view.frame
        timePopup.frame = testFrame
        timePopup.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        timePopup?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(timePopup)
        timePopupInnerView.layer.cornerRadius = 5.0
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            dayLabelFontSize = 21
        }
        else {
            dayLabelFontSize = 14
        }
            if (weekWorkingTime.count != 0) {

                if (LocalizationLanguage.currentAppleLanguage() == "ar"){
                     let closedLabel = NSLocalizedString("Closed", comment: "closed label in timepopup")
                     for weekValue  in weekWorkingTimeArray {
                    let weekTime : [String : String] = weekValue as! [String : String]
                    if((weekTime["dayValue"])?.caseInsensitiveCompare("monday") == ComparisonResult.orderedSame){
                       let dayName = NSLocalizedString("Monday", comment: "day name in timepopup")
                        dayNameOneLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameOneLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            dayOneLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                           dayOneLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        dayOneLabel.attributedText = attributedStringValue
                        }
                        
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("tuesday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Tuesday", comment: "day name in timepopup")
                        dayNameTwoLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameTwoLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            dayTwoLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            dayTwoLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                         dayTwoLabel.attributedText = attributedStringValue
                        }
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("wednesday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Wednesday", comment: "day name in timepopup")
                        dayNameThreeLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameThreeLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            dayThreeLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            dayThreeLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        dayThreeLabel.attributedText = attributedStringValue
                        }
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("thursday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Thursday", comment: "day name in timepopup")
                        dayNameFourLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameFourLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            dayFourLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            dayFourLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        dayFourLabel.attributedText = attributedStringValue
                        }
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("friday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Friday", comment: "day name in timepopup")
                        dayNameFiveLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameFiveLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            dayFiveLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            dayFiveLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        dayFiveLabel.attributedText = attributedStringValue
                        }
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("saturday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Saturday", comment: "day name in timepopup")
                        dayNameSixLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameSixLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            daySixLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            daySixLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        daySixLabel.attributedText = attributedStringValue
                        }
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("sunday") == ComparisonResult.orderedSame){
                        let dayName = NSLocalizedString("Sunday", comment: "day name in timepopup")
                        dayNameSevenLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                        dayNameSevenLabel.text = dayName
                        if (( weekTime["value"]?.caseInsensitiveCompare("closed")) == ComparisonResult.orderedSame) {
                            daySevenLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: dayLabelFontSize)
                            daySevenLabel.text = closedLabel
                        }
                        else {
                        let fullArray = weekTime["value"]?.components(separatedBy: " ")
                        let attributedStringValue = setAttributedTimeString(timeArray: fullArray!)
                        daySevenLabel.attributedText = attributedStringValue
                        }
                    }
                }
                }
                else {
                for weekValue  in weekWorkingTimeArray {
                    let weekTime : [String : String] = weekValue as! [String : String]
                    dayOneLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameOneLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayTwoLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameTwoLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayThreeLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameThreeLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayFourLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameFourLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayFiveLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameFiveLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    daySixLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameSixLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    daySevenLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    dayNameSevenLabel.font = UIFont(name: "Lato-Bold", size: dayLabelFontSize)
                    if((weekTime["dayValue"])?.caseInsensitiveCompare("monday") == ComparisonResult.orderedSame){
                        dayOneLabel.text = weekTime["value"]
                        dayNameOneLabel.text = weekTime["dayValue"]!
                        
                        
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("tuesday") == ComparisonResult.orderedSame){
                        dayTwoLabel.text = weekTime["value"]
                        dayNameTwoLabel.text = weekTime["dayValue"]!
                        
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("wednesday") == ComparisonResult.orderedSame){
                        dayThreeLabel.text = weekTime["value"]
                        dayNameThreeLabel.text = weekTime["dayValue"]!
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("thursday") == ComparisonResult.orderedSame){
                        dayFourLabel.text = weekTime["value"]
                        dayNameFourLabel.text = weekTime["dayValue"]!
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("friday") == ComparisonResult.orderedSame){
                        dayFiveLabel.text = weekTime["value"]
                        dayNameFiveLabel.text = weekTime["dayValue"]!
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("saturday") == ComparisonResult.orderedSame){
                        daySixLabel.text = weekTime["value"]
                        dayNameSixLabel.text = weekTime["dayValue"]!
                    }
                    else if((weekTime["dayValue"])?.caseInsensitiveCompare("sunday") == ComparisonResult.orderedSame){
                        daySevenLabel.text = weekTime["value"]
                        dayNameSevenLabel.text = weekTime["dayValue"]!
                    }
                
                }
                }
               
        }

        

       
       
    }

    func setAttributedTimeString(timeArray: [String]) -> NSAttributedString {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            dayLabelFontSize = 21
        }
        else {
            dayLabelFontSize = 14
        }
        
        let timeMutableString1 = NSMutableAttributedString(
            string:timeArray[0],
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Lato-Bold",
                size: dayLabelFontSize)!])
        let timeMutableString2 = NSMutableAttributedString(
            string:  " ",
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Lato-Bold",
                size: dayLabelFontSize)!])
        let timeMutableString3 = NSMutableAttributedString(
            string:  timeArray[1],
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "GESSUniqueBold-Bold",
                size: dayLabelFontSize)!])
        let timeMutableString4 = NSMutableAttributedString(
            string:  timeArray[2],
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Lato-Bold",
                size: dayLabelFontSize)!])

        let timeMutableString5 = NSMutableAttributedString(
            string:timeArray[3],
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Lato-Bold",
                size: dayLabelFontSize)!])
        let timeMutableString6 = NSMutableAttributedString(
            string:  timeArray[4],
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "GESSUniqueBold-Bold",
                size: dayLabelFontSize)!])

        timeMutableString1.append(timeMutableString2)
        timeMutableString1.append(timeMutableString3)
        timeMutableString1.append(timeMutableString2)
        timeMutableString1.append(timeMutableString4)
        timeMutableString1.append(timeMutableString2)
        timeMutableString1.append(timeMutableString5)
        timeMutableString1.append(timeMutableString2)
        timeMutableString1.append(timeMutableString6)
        return timeMutableString1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != timePopupInnerView {
            timePopup.removeFromSuperview()
        }
    }
    @IBAction func didTapPopupClose(_ sender: UIButton) {
        timePopup.removeFromSuperview()
    }
    //MARK: Servicecall
    func getInformationFromServer()
    {
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            Alamofire.request(QFindRouter.getServiceProviderData(["token": tokenString,
                                                                  "language" :1 , "service": serviceProviderId,"device_id" : ""]))
                .responseObject { (response: DataResponse<InformationProviderData>) -> Void in
                    switch response.result {
                    case .success(let data):
                    
                        if ((data.response == "error") || (data.code != "200")){
                            self.detailLoadingView.stopLoading()
                            self.detailLoadingView.isHidden = true
                        }
                        else{
                                self.serviceProviderArrayDict = data.informationproviderData
                                self.fetchHistoryInfo(idValue: (self.serviceProviderArrayDict?.id)!)
                                self.setInformationData()
                            self.detailLoadingView.stopLoading()
                            self.detailLoadingView.isHidden = true
                        }
                    case .failure(let error): 
                        self.detailLoadingView.stopLoading()
                        self.detailLoadingView.isHidden = true
                    }
            }
        }
    }
}

