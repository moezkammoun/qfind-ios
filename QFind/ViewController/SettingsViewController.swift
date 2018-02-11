//
//  SettingsViewController.swift
//  QFind
//
//  Created by Exalture on 22/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import UIKit

class SettingsViewController: RootViewController,SearchBarProtocol,BottomProtocol,predicateTableviewProtocol {

    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var arabicButtonLabel: UILabel!
    @IBOutlet weak var settingsSearchBar: SearchBarView!
    @IBOutlet weak var settingsBottomBar: BottomBarView!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsLoadingView: LoadingView!
    var controller = PredicateSearchViewController()
    
    @IBOutlet weak var englishButtonLabel: UILabel!
    var predicateSearchKey = String()
    var predicateSearchArray : [PredicateSearch]? = []
    var predicateTableHeight : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUILayout()
         setRTLSupportForSttings()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            predicateTableHeight = 85
        }
        else{
            predicateTableHeight = 50
        }
        setLocalizedVariablesForSettings()
        settingsBottomBar.favoriteview.backgroundColor = UIColor.white
        settingsBottomBar.historyView.backgroundColor = UIColor.white
        settingsBottomBar.homeView.backgroundColor = UIColor.white
        settingsSearchBar.searchText.text = ""
    }
    func setUILayout()
    {
        self.englishButton.layer.masksToBounds = false;
        self.englishButton.layer.shadowOffset = CGSize(width: -1, height: 15)
        self.englishButton.layer.shadowRadius = 5;
        self.englishButton.layer.shadowOpacity = 0.5;
        
        self.arabicButton.layer.masksToBounds = false;
        self.arabicButton.layer.shadowOffset = CGSize(width: -1, height: 15)
        self.arabicButton.layer.shadowRadius = 5;
        self.arabicButton.layer.shadowOpacity = 0.5;
        
        
        settingsSearchBar.searchDelegate = self
        settingsBottomBar.bottombarDelegate = self
         controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
    }
    func setRTLSupportForSttings()
    {
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
                
                settingsSearchBar.searchText.textAlignment = .left
                if let _img = backImageView.image{
                    backImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.downMirrored)
                }
            }
            else{
                
                settingsSearchBar.searchText.textAlignment = .right
                if let _img = backImageView.image {
                    backImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    func setLocalizedVariablesForSettings()
    {
         self.settingsLabel.text = NSLocalizedString("Settings", comment: "Settings Label in the Settings page").uppercased()
        self.selectLanguageLabel.text = NSLocalizedString("Select_language", comment: "Select_language Label in the Settings page")
        self.englishButtonLabel.text = NSLocalizedString("ENGLISH", comment: "ENGLISH BUTTON LABEL in the Settings page")
         self.arabicButtonLabel.text = NSLocalizedString("Arabic", comment: "Arabic button label in the Settings page")
          self.settingsSearchBar.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the search bar ")
        
    }
    @IBAction func didTapEnglish(_ sender: UIButton) {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            let alert = UIAlertController(title: "Alert", message: "Sorry. current language is English", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            var refreshAlert = UIAlertController(title: "You will be redirected to the home page after changing the language. ", message: "Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                LocalizationLanguage.setAppleLAnguageTo(lang: "en")
                languageKey = 1
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    
                } else {
                    // Fallback on earlier versions
                }
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
           
        }
       
    }
    
    @IBAction func didTapArabic(_ sender: UIButton) {
      
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            var refreshAlert = UIAlertController(title: "You will be redirected to the home page after changing the language.", message: "Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              
                LocalizationLanguage.setAppleLAnguageTo(lang: "ar")
                languageKey = 2
                if #available(iOS 9.0, *) {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
                    
                } else {
                    // Fallback on earlier versions
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            present(refreshAlert, animated: true, completion: nil)
          
            
        }
        else {
            
            let alert = UIAlertController(title: "Alert", message: "Sorry. current language is Arabic", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        

    }
    func showAlertToUSer()
    {
        var refreshAlert = UIAlertController(title: "You will be redirected to the home page after changing the language.", message: "Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismiss(animated: true, completion: nil)
            
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    func favouriteButtonPressed() {
        settingsBottomBar.favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.favorite
        self.present(historyVC, animated: false, completion: nil)
    }
    func homebuttonPressed() {
      
        settingsBottomBar.homeView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func historyButtonPressed() {
        settingsBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.history
        self.present(historyVC, animated: false, completion: nil)
    }
     //MARK:Searchbar
    func searchButtonPressed() {
        controller.view.removeFromSuperview()
         let trimmedText = settingsSearchBar.searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText == ""
        {
            
            let alert = UIAlertController(title: "Alert", message: "Please Enter Search Text", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
            
            historyVC.pageNameString = PageName.searchResult
            historyVC.searchType = 4
            historyVC.searchKey = trimmedText
            self.present(historyVC, animated: false, completion: nil)
       
        }
    }
    func textField(_ textField: UITextField, shouldChangeSearcgCharacters range: NSRange, replacementString string: String) -> Bool {
        
        
        
        predicateSearchKey = textField.text! + string
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            predicateSearchKey = String(predicateSearchKey.characters.dropLast())
            
        }
        
        if ((predicateSearchKey.count) >= 2)
        {
            controller.predicateProtocol = self
            self.controller.view.frame = CGRect(x: self.settingsSearchBar.searchInnerView.frame.origin.x, y:self.settingsSearchBar.searchInnerView.frame.origin.y+self.settingsSearchBar.searchInnerView.frame.height+20, width: self.settingsSearchBar.searchInnerView.frame.width, height: 0)
            addChildViewController(controller)
            view.addSubview((controller.view)!)
            controller.didMove(toParentViewController: self)
            
            let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView(sender:)))
            self.settingsView.addGestureRecognizer(tapGestRecognizer)
            getPredicateSearchFromSettings()
            
            
        }
        else{
            controller.view.removeFromSuperview()
        }
        return true
    }
    @objc func dismissPopupView(sender: UITapGestureRecognizer)
    {
        controller.view.removeFromSuperview()
        
    }
    func menuButtonSelected() {
       self.showSidebar()
        
    }
    //MARK:TableView
    func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int {
        return (predicateSearchArray?.count)!
    }
    func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PredicateCell = tableView.dequeueReusableCell(withIdentifier: "predicateCellId") as! PredicateCell!
        let predicatedict = predicateSearchArray![indexPath.row]
        cell.setPredicateCellValues(cellValues: predicatedict)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath) {
        let predicatedict = predicateSearchArray![indexPath.row]
        settingsSearchBar.searchText.text = predicatedict.search_name
        controller.view.removeFromSuperview()
          let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.searchResult
        historyVC.searchType = predicatedict.search_type
        historyVC.searchKey = predicatedict.search_name
        self.present(historyVC, animated: false, completion: nil)
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    func getPredicateSearchFromSettings()
    {
         let trimmedSearchKey = self.predicateSearchKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            
            Alamofire.request(QFindRouter.getPredicateSearch(["token": tokenString,
                                                              "search_key": trimmedSearchKey , "language" :languageKey]))
                .responseObject { (response: DataResponse<PredicateSearchData>) -> Void in
                    switch response.result {
                        
                    case .success(let data):
                        
                        self.predicateSearchArray = data.predicateSearchData
                        self.controller.predicateSearchTable.reloadData()
                        if ((self.predicateSearchArray?.count == 1) && (self.predicateSearchArray![0].item_id == nil))
                        {
                            self.controller.view.frame = CGRect(x: self.settingsSearchBar.searchInnerView.frame.origin.x, y:self.settingsSearchBar.searchInnerView.frame.origin.y+self.settingsSearchBar.searchInnerView.frame.height+20, width: 0, height: 0)
                        }else{
                        self.controller.view.frame = CGRect(x: self.settingsSearchBar.searchInnerView.frame.origin.x, y:self.settingsSearchBar.searchInnerView.frame.origin.y+self.settingsSearchBar.searchInnerView.frame.height+20, width: self.settingsSearchBar.searchInnerView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight)!))
                        }
                        
                    case .failure(let error):
                        self.settingsLoadingView.isHidden = false
                        self.settingsLoadingView.stopLoading()
                        self.settingsLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }
   

}
