//
//  HomeViewController.swift
//  QFind
//
//  Created by Exalture on 12/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import UIKit

class HomeViewController: RootViewController,UITextFieldDelegate, KASlideShowDelegate,predicateTableviewProtocol {
    @IBOutlet weak var findByCategoryButton: UIButton!
    @IBOutlet weak var findByCategoryLabel: UILabel!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var qfindDayLabel: UILabel!
    @IBOutlet weak var scrollSubView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var homeLoadingView: LoadingView!
    @IBOutlet weak var slideShow: KASlideShow!
    @IBOutlet weak var orLabel: UILabel!
    
    
    @IBOutlet weak var aspectRationHome: NSLayoutConstraint!
    var bannerArray = NSArray()
    var controller = PredicateSearchViewController()
    var predicateSearchArray : [PredicateSearch]? = []
    var predicateSearchKey = String()
     var predicateTableHeight : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUILayout()
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
        setRTLSupport()
        setSlideShow()
        setLocalizedStrings()
        searchText.text = ""
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setRTLSupport()
    {
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
                slideShow.arabic = false
                searchText.textAlignment = .left
            }
            else{
                slideShow.arabic = true
                searchText.textAlignment = .right
            }
        } else {
            // Fallback on earlier versions
        }
       
        
    }
    func setSlideShow()
    {
        
        //KASlideshow
        slideShow.delegate = self
        slideShow.delay = 1 // Delay between transitions
        slideShow.transitionDuration = 1.5 // Transition duration
        slideShow.transitionType = KASlideShowTransitionType.slide // Choose a transition type (fade or slide)
        slideShow.imagesContentMode = .scaleAspectFill // Choose a content mode for images to display
        slideShow.addImages(fromResources:bannerArray as! [Any]) // Add images from resources
        slideShow.add(KASlideShowGestureType.swipe) // Gesture to go previous/next
        slideShow.start()
    }
    func setUILayout()
    {
        
        homeLoadingView.isHidden = true
       // homeLoadingView.showLoading()
       // homeLoadingView.showNoDataView()
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
        bannerArray = ["banner", "findByCategoryBG", "car_service","cloth_stores"]
        searchView.layer.cornerRadius = 7.5
        searchView.layer.borderWidth = 2.0
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        searchText.delegate = self
        pageControl.numberOfPages = bannerArray.count
        pageControl.currentPage = Int(slideShow.currentIndex)
        pageControl.addTarget(self, action: #selector(HomeViewController.pageChanged), for: .valueChanged)

        self.findByCategoryButton.layer.masksToBounds = false;
        self.findByCategoryButton.layer.shadowOffset = CGSize(width: -1, height: 15)
        self.findByCategoryButton.layer.shadowRadius = 12;
        self.findByCategoryButton.layer.shadowOpacity = 0.5;

        
    }
    func setLocalizedStrings()
    {
        self.qfindDayLabel.text = NSLocalizedString("QFIND_OF_THE_DAY", comment: "QFIND_OF_THE_DAY Label in the home page")
       
        self.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the home page")
        self.findByCategoryLabel.text = NSLocalizedString("FIND_BY_CATEGORY", comment: "FIND_BY_CATEGORY Label in the home page")
        self.orLabel.text = NSLocalizedString("OR", comment: "OR Label in the home page")
    }
    @objc func keyboardWillShow(notification: NSNotification) {
       
        
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 200
            }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      
           
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
            }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //KASlideShow delegate
    
    func kaSlideShowWillShowNext(_ slideshow: KASlideShow) {
       
      
       
    }
    
    func kaSlideShowWillShowPrevious(_ slideshow: KASlideShow) {
        
    }
    
    func kaSlideShowDidShowNext(_ slideshow: KASlideShow) {
        pageControl.currentPage = Int(slideShow.currentIndex)
      
    }
    
    func kaSlideShowDidShowPrevious(_ slideshow: KASlideShow) {
        
         pageControl.currentPage = Int(slideShow.currentIndex)
    }
    @objc func pageChanged() {
       
    }
    //MARK: SearchBar
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        predicateSearchKey = textField.text! + string
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92){
            predicateSearchKey = String(predicateSearchKey.characters.dropLast())
        }
        
        if ((predicateSearchKey.count) >= 2)
        {
            controller.predicateProtocol = self
            self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y+self.searchView.frame.height+20, width: 0, height: 0)
            addChildViewController(controller)
            view.addSubview((controller.view)!)
            controller.didMove(toParentViewController: self)
            let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView(sender:)))
            self.scrollSubView.addGestureRecognizer(tapGestRecognizer)
            getPredicateSearchFromServer()
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
    func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int {
        if let countValue = predicateSearchArray?.count
        {
            if countValue > 3
            {
                 return 3
            }
            else{
                return (predicateSearchArray?.count)!
            }
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PredicateCell = tableView.dequeueReusableCell(withIdentifier: "predicateCellId") as! PredicateCell!
        let predicatedict = predicateSearchArray![indexPath.row]
        cell.setPredicateCellValues(cellValues: predicatedict)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath) {
         let predicatedict = predicateSearchArray![indexPath.row]
        searchText.text = predicatedict.search_name
        controller.view.removeFromSuperview()
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        historyVC.pageNameString = PageName.searchResult
        historyVC.searchType = predicatedict.search_type
        historyVC.searchKey = predicatedict.search_name
        self.present(historyVC, animated: false, completion: nil)
    }
    
    @IBAction func didTapFindCategory(_ sender: UIButton) {
        controller.view.removeFromSuperview()
        let categoryVC : CategoryViewController = storyboard?.instantiateViewController(withIdentifier: "categoryId") as! CategoryViewController
        
        self.present(categoryVC, animated: false, completion: nil)
    }
    @IBAction func didTapMenu(_ sender: UIButton) {
      self.showSidebar()
        
    }
    func getPredicateSearchFromServer()
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
                        if let countValue = self.predicateSearchArray?.count
                        {
                            if countValue > 3
                            {
                                self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y+self.searchView.frame.height+20, width: self.searchView.frame.width, height: (CGFloat(self.predicateTableHeight!*3)))
                            }
                            else if ((self.predicateSearchArray?.count == 1) && (self.predicateSearchArray![0].item_id == nil))
                                {
                                    self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y+self.searchView.frame.height+20, width: 0, height: 0)
                                }else{
                               self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y+self.searchView.frame.height+20, width: self.searchView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight)!))
                                }
                        }
                        
                        
                        
                    case .failure(let error):
                        self.homeLoadingView.isHidden = false
                        self.homeLoadingView.stopLoading()
                        self.homeLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }
    
    @IBAction func didTapHomeSearch(_ sender: UIButton) {
        controller.view.removeFromSuperview()
        let trimmedText = searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText == ""
        {
            
            let alert = UIAlertController(title: "Alert", message: "Please Enter Search Text", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
            historyVC.searchType = 4
            historyVC.searchKey = trimmedText
            historyVC.pageNameString = PageName.searchResult
            self.present(historyVC, animated: false, completion: nil)
        }
        
    }

}
