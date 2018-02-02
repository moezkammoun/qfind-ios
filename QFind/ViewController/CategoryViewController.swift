//
//  CategoryViewController.swift
//  QFind
//
//  Created by Exalture on 15/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import UIKit

enum PageNameInCategory{
    case category
    case subcategory
    case informationPage
    
}
class CategoryViewController: RootViewController,KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BottomProtocol,SearchBarProtocol,predicateTableviewProtocol {
    
    @IBOutlet weak var bottomBar: BottomBarView!
    
    @IBOutlet weak var categoryLoadingView: LoadingView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var slideShow: KASlideShow!
    @IBOutlet weak var categoryView: UIView!
    
    
     var controller = PredicateSearchViewController()
    
     var categoryPageNameString : PageNameInCategory?
    var dummyString = String()
     var bannerArray = NSArray()
    var categoryDataArray : [Category]? = []
    var subCategoryDataArray : [SubCategory]? = []
    var predicateSearchArray : [PredicateSearch]? = []
    var subCategoryTitle : String?
    var categoryIdVar : Int?
    var predicateSearchKey = String()
    var predicateTableHeight : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

       
        registerNib()
        setUpUi()
        categoryPageNameString = PageNameInCategory.category
        
        
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
        getCategoriesFromServer()
        setLocalizedVariables()
        setRTLSupport()
        setImageSlideShow()
        searchBarView.searchText.text = ""
        bottomBar.favoriteview.backgroundColor = UIColor.white
        bottomBar.historyView.backgroundColor = UIColor.white
        bottomBar.homeView.backgroundColor = UIColor.white
       
    }
    
    func setUpUi()
    {
        categoryTitle.textAlignment = .center
        
        bottomBar.bottombarDelegate = self
        
        searchBarView.searchDelegate = self
        searchBarView.searchText.autocorrectionType = .no
        searchBarView.searchText.autocapitalizationType = .none
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
        categoryLoadingView.isHidden = false
        categoryLoadingView.showLoading()
    }
    func setRTLSupport()
    {
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
                slideShow.arabic = false
                searchBarView.searchText.textAlignment = .left
                
                if let _img = backImageView.image{
                    backImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.downMirrored)
                }
                
            }
            else{
                slideShow.arabic = true
                 searchBarView.searchText.textAlignment = .right
                
                if let _img = backImageView.image {
                    backImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                }
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
       
    }
    func setLocalizedVariables()
    {
        
         self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
         self.searchBarView.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the search bar ")

    }
    func registerNib()
    {
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryCollectionView?.register(nib, forCellWithReuseIdentifier: "categoryCellId")
        
        
    }
    func setImageSlideShow()
    {
        
        
       bannerArray = ["banner", "findByCategoryBG", "car_service","cloth_stores"]
        
        pageControl.numberOfPages = bannerArray.count
        pageControl.currentPage = Int(slideShow.currentIndex)
        pageControl.addTarget(self, action: #selector(HomeViewController.pageChanged), for: .valueChanged)

        
        
        //KASlideshow
        slideShow.delegate = self
        slideShow.delay = 1 // Delay between transitions
        slideShow.transitionDuration = 1.5 // Transition duration
        slideShow.transitionType = KASlideShowTransitionType.slide // Choose a transition type (fade or slide)
        slideShow.imagesContentMode = .scaleAspectFill // Choose a content mode for images to display
        slideShow.addImages(fromResources:bannerArray as! [Any]) // Add images from resources
        slideShow.add(KASlideShowGestureType.swipe) // Gesture to go previous/next directly on the image (Tap or Swipe)
        /*************Set this value when langue is changed in settings*****/
        slideShow.start()
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
    
    // MARK: CollectionView
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (categoryPageNameString == PageNameInCategory.category)
        {
            return (categoryDataArray?.count)!
        }
        else{
            return (subCategoryDataArray?.count)!
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCollectionViewCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellId", for: indexPath) as! CategoryCollectionViewCell
        self.categoryLoadingView.hideNoDataView()
        if (categoryPageNameString == PageNameInCategory.category)
        {
            cell.titleCenterConstraint.constant = 0
            cell.subTitleLabel.isHidden = true
            let categoryDictionary = categoryDataArray![indexPath.row]
            cell.setCategoryCellValues(categoryValues: categoryDictionary)
        }
        else{
            cell.titleCenterConstraint.constant = 7
            cell.subTitleLabel.isHidden = false
            let subCategoryDictionary = subCategoryDataArray![indexPath.row]
            cell.setSubCategoryCellValues(subCategoryValues: subCategoryDictionary)
        }
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
      
       
        
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.view.removeFromSuperview()
        searchBarView.searchText.text = ""
        if categoryPageNameString == PageNameInCategory.category
        {
            categoryPageNameString = PageNameInCategory.subcategory
            let categoryDict = categoryDataArray![indexPath.row]
            categoryIdVar = categoryDict.categories_id
            categoryTitle.text = categoryDict.categories_name?.uppercased()
            categoryLoadingView.activityIndicator.startAnimating()
            getSubcategoriesFromServer()
           
        }
        else {
            categoryPageNameString = PageNameInCategory.informationPage
            let informationVC : DetailViewController = storyboard?.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
            controller.view.removeFromSuperview()
            self.present(informationVC, animated: false, completion: nil)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return CGSize(width: categoryCollectionView.frame.width/2-20, height: heightValue*7)
        }
        else{
            return CGSize(width: categoryCollectionView.frame.width/2-17, height: heightValue*7)
        }
        
    }
 // MARK: Bottombar
    func favouriteButtonPressed() {
      
       
        controller.view.removeFromSuperview()
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.favorite
        self.present(historyVC, animated: false, completion: nil)
    }
    func homebuttonPressed() {

      
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func historyButtonPressed() {
        
        controller.view.removeFromSuperview()
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
       
        historyVC.pageNameString = PageName.history
        self.present(historyVC, animated: false, completion: nil)
    }
    // MARK: Searchbar
    func searchButtonPressed() {
        controller.view.removeFromSuperview()
        let trimmedText = searchBarView.searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
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
                    controller.view.isHidden = false
                    controller.predicateProtocol = self
                     self.controller.view.frame = CGRect(x: self.searchBarView.searchInnerView.frame.origin.x, y:self.searchBarView.searchInnerView.frame.origin.y+self.searchBarView.searchInnerView.frame.height+20, width: 0, height: 0)
                    addChildViewController(controller)
                    view.addSubview((controller.view)!)
                    controller.didMove(toParentViewController: self)
                let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView(sender:)))
                self.categoryView.addGestureRecognizer(tapGestRecognizer)
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
    func menuButtonSelected() {
        self.showSidebar()
    }
    // MARK: Tableview
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
        searchBarView.searchText.text = predicatedict.search_name
        controller.view.removeFromSuperview()
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.searchResult
        historyVC.searchType = predicatedict.search_type
        historyVC.searchKey = predicatedict.search_name
        self.present(historyVC, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func didTapBack(_ sender: UIButton) {
        if categoryPageNameString == PageNameInCategory.category{
            self.dismiss(animated: false, completion: nil)
            
            //self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
           
        }
        else{
            categoryPageNameString = PageNameInCategory.category
            self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
            
            categoryCollectionView.reloadData()
        }
        
    }
    // MARK: Service calls
    func getCategoriesFromServer()
    {
       
            if let tokenString = tokenDefault.value(forKey: "accessTokenString")
            {
            Alamofire.request(QFindRouter.getCategory(["token": tokenString,
                                                          "language": languageKey]))
                .responseObject { (response: DataResponse<CategoryData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        
                        self.categoryDataArray = data.categoryData
                        
                        self.categoryCollectionView.reloadData()
                        self.categoryLoadingView.isHidden = true
                        self.categoryLoadingView.stopLoading()
                    case .failure(let error):
                        self.categoryLoadingView.isHidden = false
                        self.categoryLoadingView.stopLoading()
                        self.categoryLoadingView.noDataView.isHidden = false
                    }
                    
                }
            }
    }
    func getSubcategoriesFromServer()
    {
        categoryLoadingView.isHidden = false
        categoryLoadingView.showLoading()
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            if let categoryIdvar = self.categoryIdVar
            {
            Alamofire.request(QFindRouter.getSubCategory(["token": tokenString,
                                                          "language": languageKey , "category" :categoryIdvar]))
                .responseObject { (response: DataResponse<SubCategoryData>) -> Void in
                    switch response.result {
                        
                    case .success(let data):
                        
                        self.subCategoryDataArray = data.subCategoryData
                        DispatchQueue.main.async {
                            self.categoryCollectionView.reloadData()
                        }
                        
                        
                       
                         if ((data.response == "error") || (data.code != "200")){
                            self.categoryLoadingView.stopLoading()
                            self.categoryLoadingView.showNoDataView()
                        }
                         else{
                           
                            self.categoryLoadingView.isHidden = true
                            self.categoryLoadingView.stopLoading()
                        }
                    case .failure(let error):
                        self.categoryLoadingView.isHidden = false
                        self.categoryLoadingView.stopLoading()
                        self.categoryLoadingView.noDataView.isHidden = false
                    }
                    
            }
            }
        }
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
                            if ((self.predicateSearchArray?.count == 1) && (self.predicateSearchArray![0].item_id == nil))
                            {
                                 self.controller.view.frame = CGRect(x: self.searchBarView.searchInnerView.frame.origin.x, y:self.searchBarView.searchInnerView.frame.origin.y+self.searchBarView.searchInnerView.frame.height+20, width: 0, height: 0)
                            }else{
                                self.controller.view.frame = CGRect(x: self.searchBarView.searchInnerView.frame.origin.x, y:self.searchBarView.searchInnerView.frame.origin.y+self.searchBarView.searchInnerView.frame.height+20, width: self.searchBarView.searchInnerView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight)!))
                            }
                            
                            
                        case .failure(let error):
                            self.categoryLoadingView.isHidden = false
                            self.categoryLoadingView.stopLoading()
                            self.categoryLoadingView.noDataView.isHidden = false
                        }
                        
                }
            
        }
    }

}
