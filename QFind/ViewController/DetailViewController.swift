//
//  DetailViewController.swift
//  QFind
//
//  Created by Exalture on 16/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit
import MessageUI
class DetailViewController: UIViewController,BottomProtocol,MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var detailBottomBar: BottomBarView!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    @IBOutlet weak var detailLoadingView: LoadingView!
    @IBOutlet weak var titleLabel: UILabel!
    var phnNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetUp()
       
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
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender )
        
        // This line remove the arrow of the popover to show in iPad
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "detailCellId", for:indexPath) as! DetailTableViewCell
        if (indexPath.row == 5)
        {
            cell.separatorView.isHidden = true
        }
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
        if (indexPath.row == 0)
        {
            if let url = URL(string: "tel://\(phnNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else if (indexPath.row == 1)
        {
            let websiteUrlString = "http://www.techotopia.com/"
            if let websiteUrl = NSURL(string: websiteUrlString) {
                // show alert to choose app
                if UIApplication.shared.canOpenURL(websiteUrl as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(websiteUrl as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(websiteUrl as URL)
                    }
                }
            }
        }
        else if (indexPath.row == 2)
        {
            //Working in Swift new versions.
            let latitude = 10.0158685
            let longitude =  76.3418586
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string:"comgooglemaps://?center=\(latitude),\(longitude)&zoom=14&views=traffic&q=\(latitude),\(longitude)")!)
                }
            } else {
                print("Can't use comgooglemaps://");
                
                if (UIApplication.shared.canOpenURL(URL(string:"https://maps.google.com")! ))
                {
                    UIApplication.shared.openURL(URL(string:
                        "https://maps.google.com/?q=@\(latitude),\(longitude)")!)
                }
            }
        }
    
    else if (indexPath.row == 4)
    {
        let email = "vidyar851@gmail.com"
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
         else if (indexPath.row == 5)
        {
            
            let facebookUrl = URL(string: "fb://profile/vidyarajan.rajan.5")
            if( UIApplication.shared.canOpenURL(facebookUrl!))
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(facebookUrl!, options: [:], completionHandler: nil)
                } else {
                    
                    UIApplication.shared.openURL(facebookUrl!)
                    
                }
            }
            else{
                let facebookUrlString = URL(string: "http://www.facebook.com/vidyarajan.rajan.5")
                UIApplication.shared.openURL(facebookUrlString!)
            }
        }
        
        
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
