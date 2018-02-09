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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var backImgaeView: UIImageView!
    @IBOutlet weak var detailLoadingView: LoadingView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet var viewForwebView: UIView!
    
    @IBOutlet var detailWebView: UIWebView!
    var serviceProviderArrayDict: ServiceProvider?
    var informationDetails = [String : String]()
    var informationArray = NSMutableArray()
    var fromFavorite: Bool? = false
    var favoriteDeleted : Bool? = false
    var favoriteDictinary = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
       // initialSetUp()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setLocalizedVariables()
        detailBottomBar.favoriteview.backgroundColor = UIColor.white
        detailBottomBar.historyView.backgroundColor = UIColor.white
        detailBottomBar.homeView.backgroundColor = UIColor.white
       
        initialSetUp()
        
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
        
        informationArray = NSMutableArray()
        if (fromFavorite == true){
            guard let titleText = favoriteDictinary.value(forKey: "name") else{
                return
            }
            titleLabel.text = titleText as! String
            setFavoriteInformationData()
        }
        else{
             titleLabel.text = serviceProviderArrayDict?.service_provider_name
            setInformationData()
        }
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
        if (indexPath.row == (informationArray.count)-1)
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
                //let urlString = URL(string: "inbox-gmail://")
                // UIApplication.shared.openURL(urlString!)
                
                
            }
        }//
    }
         else if (informationDict["key"] == "service_provider_facebook_page")
        {
            guard let urlString = informationDict["value"] else{
                return
            }
            let facebookUrl = URL(string: urlString)
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
    let fetchData = checkAddedToFavorites(serviceId: (serviceProviderArrayDict?.id)!)
    if (fetchData.count == 0){
        favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
    }
    else{
        favoriteButton.setImage(UIImage(named: "favorite-red"), for: .normal)
    }
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
    func setFavoriteInformationData()
    {

       
        favoriteButton.setImage(UIImage(named: "favorite-red"), for: .normal)
        if ((favoriteDictinary.value(forKey: "mobile")) != nil){
            
            informationDetails = ["key" : "service_provider_mobile_number","value" :(favoriteDictinary.value(forKey: "mobile"))! as! String ,"imageName": "phone"]
            informationArray.add(informationDetails)
        }
        if ((favoriteDictinary.value(forKey: "website")) != nil){
            
            informationDetails = [ "key" : "service_provider_website","value" :(favoriteDictinary.value(forKey: "website"))! as! String,"imageName": "website" ]
            informationArray.add(informationDetails)
        }
        if ((favoriteDictinary.value(forKey: "shortdescription")) != nil){
            
            informationDetails = [ "key" : "service_provider_location","value" :(favoriteDictinary.value(forKey: "shortdescription"))! as! String,"imageName": "location"  ]
            informationArray.add(informationDetails)
        }
        if ((favoriteDictinary.value(forKey: "openingtime")) != nil){
            
            informationDetails = [ "key" : "service_provider_opening_time","value" :(favoriteDictinary.value(forKey: "openingtime"))! as! String,"imageName": "time" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "email")) != nil) && ((favoriteDictinary.value(forKey: "email")as! String ) != "")){
            
            informationDetails = [ "key" : "service_provider_mail_account","value"  :(favoriteDictinary.value(forKey: "email"))! as! String ,"imageName": "email" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "facebookpage")) != nil) && ((favoriteDictinary.value(forKey: "facebookpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_facebook_page","value" :(favoriteDictinary.value(forKey: "facebookpage"))! as! String ,"imageName": ""]
            informationArray.add(informationDetails)
        }
        
        if (((favoriteDictinary.value(forKey: "linkedinpage")) != nil) && ((favoriteDictinary.value(forKey: "linkedinpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_linkdin_page", "value":(favoriteDictinary.value(forKey: "linkedinpage"))! as! String ,"imageName": ""]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "instagrampage")) != nil) && ((favoriteDictinary.value(forKey: "instagrampage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_instagram_page", "value" :(favoriteDictinary.value(forKey: "instagrampage"))! as! String,"imageName": "" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "twitterpage")) != nil) && ((favoriteDictinary.value(forKey: "twitterpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_twitter_page", "value"  :(favoriteDictinary.value(forKey: "twitterpage"))! as! String as! String,"imageName": "" ]
            informationArray.add(informationDetails)
        }
        
        if (((favoriteDictinary.value(forKey: "snapchatpage")) != nil) && ((favoriteDictinary.value(forKey: "snapchatpage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_snapchat_page", "value" :(favoriteDictinary.value(forKey: "snapchatpage"))! as! String,"imageName": "" ]
            informationArray.add(informationDetails)
        }
        if (((favoriteDictinary.value(forKey: "googlepluspage")) != nil) && ((favoriteDictinary.value(forKey: "googlepluspage") as! String) != "")){
            
            informationDetails = [ "key" : "service_provider_googleplus_page", "value" :(favoriteDictinary.value(forKey: "googlepluspage"))! as! String ,"imageName": "" ]
            informationArray.add(informationDetails)
        }
        
        detailTableView.reloadData()
        
    }
    @IBAction func didTapWebViewClose(_ sender: UIButton) {
        detailWebView.loadRequest(URLRequest.init(url: URL.init(string: "about:blank")!))
        viewForwebView.removeFromSuperview()
    }
    @IBAction func didTapFavorite(_ sender: UIButton) {
        
        
         let managedContext = getContext()
        if (fromFavorite == true){
            if (favoriteDeleted == true){
                favoriteDeleted = false
              
                  favoriteButton.setImage(UIImage(named: "favorite-red"), for: .normal)

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
                    favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
                    for fetResult in fetchResults{
                                    managedContext.delete(fetResult)
                                }
                    
                                do {
                                    try managedContext.save()
                                } catch {
                                    print("error")
                                }
                   
                }
                else{
                    favoriteButton.setImage(UIImage(named: "favorite-white"), for: .normal)
                    
                }
                
            
            
            }
        }
        else{
            let favFetchResults = checkAddedToFavorites(serviceId: (serviceProviderArrayDict?.id)!)
            if (favFetchResults.count == 0){
                favoriteButton.setImage(UIImage(named: "favorite-red"), for: .normal)
                saveDetailsToCoreData()
            }
            else{
                favoriteButton.setImage(UIImage(named: "favorite-White"), for: .normal)
                for fetResult in favFetchResults{
                    managedContext.delete(fetResult)
                }
                
                do {
                    try managedContext.save()
                } catch {
                    print("error")
                }
            }
       
        }
    }
    //for data passed from service provider
    func saveDetailsToCoreData()
    {
         let managedContext = getContext()
        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
        
        //set values to coredata
        guard let nameString = (serviceProviderArrayDict?.service_provider_name) else{
            return
        }
        guard let address = (serviceProviderArrayDict?.service_provider_address) else{
            return
        }
        guard let shortDescription = (serviceProviderArrayDict?.service_provider_location) else{
            return
        }
        guard let category = (serviceProviderArrayDict?.service_provider_category) else{
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
        guard let facebookPage = (serviceProviderArrayDict?.service_provider_facebook_page) else{
            return
        }
        
        guard let linkedInPage = (serviceProviderArrayDict?.service_provider_linkdin_page) else{
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
        guard let googlePlusPage = (serviceProviderArrayDict?.service_provider_googleplus_page) else{
            return
        }
        favoriteAttribute.setValue(serviceId, forKey: "id")
         favoriteAttribute.setValue(address, forKey: "address")
         favoriteAttribute.setValue(category, forKey: "category")
        favoriteAttribute.setValue(email, forKey: "email")
        favoriteAttribute.setValue(websitePage, forKey: "website")
         favoriteAttribute.setValue(mobile, forKey: "mobile")
        favoriteAttribute.setValue(mapLocation, forKey: "maplocation")
        favoriteAttribute.setValue(openingTime, forKey: "openingtime")
         favoriteAttribute.setValue(facebookPage, forKey: "facebookpage")
        favoriteAttribute.setValue(linkedInPage, forKey: "linkedinpage")
         favoriteAttribute.setValue(instagramPage, forKey: "instagrampage")
         favoriteAttribute.setValue(twitterPage, forKey: "twitterpage")
        favoriteAttribute.setValue(snapChatPage, forKey: "snapchatpage")
        favoriteAttribute.setValue(googlePlusPage, forKey: "googlepluspage")
        favoriteAttribute.setValue(nameString, forKey: "name")
        favoriteAttribute.setValue(logoImage, forKey: "imgurl")
        favoriteAttribute.setValue(shortDescription, forKey: "shortdescription")
        do {
            try managedContext.save()
            //people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveFavoriteDetailsToCoreData()
    {
        
        let managedContext = getContext()
        let entityFavorite =
            NSEntityDescription.entity(forEntityName: "FavoriteEntity",
                                       in: managedContext)!
        
        let favoriteAttribute = NSManagedObject(entity: entityFavorite,
                                                insertInto: managedContext)
       
        //set values to coredata
        let nameString = favoriteDictinary.value(forKey: "name")
        if(nameString != nil) {
           favoriteAttribute.setValue(nameString, forKey: "name")
        }
            
        let address = favoriteDictinary.value(forKey: "address")
        if (address != nil){
            favoriteAttribute.setValue(address, forKey: "address")
        }
         let shortDescription = (favoriteDictinary.value(forKey: "shortdescription"))
        if (shortDescription != nil){
           favoriteAttribute.setValue(shortDescription, forKey: "shortdescription")
        }
        let category = (favoriteDictinary.value(forKey: "category"))
        if (category != nil){
            favoriteAttribute.setValue(category, forKey: "category")
        }
       let logoImage = (favoriteDictinary.value(forKey: "imgurl"))
        if (logoImage != nil){
            favoriteAttribute.setValue(logoImage, forKey: "imgurl")
        }
        let serviceId = (favoriteDictinary.value(forKey: "id"))
        if (serviceId != nil){
            favoriteAttribute.setValue(serviceId, forKey: "id")
        }
        let email = (favoriteDictinary.value(forKey: "email"))
        if (email != nil){
            favoriteAttribute.setValue(email, forKey: "email")
        }
       let websitePage = (favoriteDictinary.value(forKey: "website"))
        if(websitePage != nil){
            favoriteAttribute.setValue(websitePage, forKey: "website")
        }
       let mobile = (favoriteDictinary.value(forKey: "mobile"))
        if(mobile != nil){
         favoriteAttribute.setValue(mobile, forKey: "mobile")
        }
         let mapLocation = (favoriteDictinary.value(forKey: "maplocation"))
        if(mapLocation != nil){
             favoriteAttribute.setValue(mapLocation, forKey: "maplocation")
          
        }
        let facebookPage = (favoriteDictinary.value(forKey: "facebookpage"))
        if(facebookPage != nil){
            favoriteAttribute.setValue(facebookPage, forKey: "facebookpage")
        }
        
        
        let linkedInPage = (favoriteDictinary.value(forKey: "linkedinpage"))
        if(linkedInPage != nil){
             favoriteAttribute.setValue(linkedInPage, forKey: "linkedinpage")
        }
        let instagramPage = (favoriteDictinary.value(forKey: "instagrampage"))
        if(instagramPage != nil){
             favoriteAttribute.setValue(instagramPage, forKey: "instagrampage")
        }
       let twitterPage = (favoriteDictinary.value(forKey: "twitterpage"))
        if(twitterPage != nil){
             favoriteAttribute.setValue(twitterPage, forKey: "twitterpage")
        }
        let snapChatPage = (favoriteDictinary.value(forKey: "snapchatpage"))
        if(snapChatPage != nil){
              favoriteAttribute.setValue(snapChatPage, forKey: "snapchatpage")
        }
       let googlePlusPage = (favoriteDictinary.value(forKey: "googlepluspage"))
        if(googlePlusPage != nil){
            favoriteAttribute.setValue(googlePlusPage, forKey: "googlepluspage")
        }
         let openingTime = (favoriteDictinary.value(forKey: "openingtime"))
         if(openingTime != nil){
              favoriteAttribute.setValue(openingTime, forKey: "openingtime")
        }
        
       
        do {
            try managedContext.save()
            //people.append(person)
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
    func checkAddedToFavorites(serviceId: Int) -> [NSManagedObject]
    {
        
        let managedContext = getContext()
        var fetchResults : [NSManagedObject] = []
        let favoritesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")

        favoritesFetchRequest.predicate = NSPredicate.init(format: "id ==\(serviceId)")
         fetchResults = try! managedContext.fetch(favoritesFetchRequest)
   
         return fetchResults
    }
}

