//
//  CategoryViewController.swift
//  QFind
//
//  Created by Exalture on 15/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import Kingfisher
import UIKit

enum PageNameInCategory{
    case category
    case subcategory
    case serviceProvider
    case informationPage
    
}
class CategoryViewController: RootViewController,KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BottomProtocol,SearchBarProtocol,predicateTableviewProtocol {
   
    
    @IBOutlet weak var bottomBar: BottomBarView!
    
    @IBOutlet weak var categoryLoadingView: LoadingView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categorySliderLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var slideShow: KASlideShow!
    @IBOutlet weak var categoryView: UIView!
    
    
     var controller = PredicateSearchViewController()
    
     var categoryPageNameString : PageNameInCategory?
    var dummyString = String()
    var categoryDataArray : [Category]? = []
    var subCategoryDataArray : [SubCategory]? = []
    var predicateSearchArray : [PredicateSearch]? = []
    var subCategoryTitle : String?
    var categoryIdVar : Int?
    var predicateSearchKey = String()
    var predicateTableHeight : Int?
    var categoryQFindArray = NSMutableArray()
    var arrayCount : Int? = 0
    var tapGestRecognizer = UITapGestureRecognizer()
    var serviceProviderArray = [ServiceProvider]()
    var haveSubCategory : Bool? = nil
    var subCategoryName: String? = nil
    let networkReachability = NetworkReachabilityManager()
    var serviceProviderFullArray = NSMutableArray()
    var serviceProvideId: Int? = 0
    var offsetValue: Int? = 1
    
    //RefreshControl
     var footerView:CustomFooterView?
    var isLoading:Bool = false
    let footerViewReuseIdentifier = "RefreshFooterView"
    override func viewDidLoad() {
        super.viewDidLoad()

       
        registerNib()
        setUpUi()
        categoryPageNameString = PageNameInCategory.category
        
        if  (networkReachability?.isReachable)!{
            getCategoriesFromServer()
        }
        else{
            self.categoryLoadingView.stopLoading()
             self.categoryLoadingView.isHidden = true
            
            
            //self.categoryLoadingView.noDataView.isHidden = false
            let alert = UIAlertController(title: "Network", message: "No Network Available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
        }
        
        //Refreshcontrol
        
        self.categoryCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        
        
        
        
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        categorySliderLoader.isHidden = false
        categorySliderLoader.startAnimating()
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            predicateTableHeight = 85
        }
        else{
            predicateTableHeight = 50
        }
       
        setLocalizedVariables()
        setRTLSupport()
        sliderSetUp()
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
       
           if ((LocalizationLanguage.currentAppleLanguage()) == "en")  {
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
       
        
        
       
    }
    func setLocalizedVariables()
    {
        
        switch categoryPageNameString {
        case .category?:
            self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
        default:
            break
        }
        
         self.searchBarView.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the search bar ")

    }
    func registerNib()
    {
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryCollectionView?.register(nib, forCellWithReuseIdentifier: "categoryCellId")
        
        
    }
    func sliderSetUp()
    {
        let sliderImagesArray = sliderImagesDefault.value(forKey: "sliderimages")
        if (sliderImagesArray == nil)
        {
            getQFindOfTheDayFromServer()
        }
        else{
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let currentDay = components.day
            let currentMonth = components.month
            let currentYear = components.year
            let previoisDay : Int = sliderImagesDefault.value(forKey: "sliderDay") as! Int
            let previoisMonth : Int = sliderImagesDefault.value(forKey: "sliderMonth") as! Int
            let previoisYear : Int = sliderImagesDefault.value(forKey: "sliderYear") as! Int
            
            if ((previoisYear < currentYear!) || ((previoisMonth < currentMonth!) && (previoisYear == currentYear)) || (( previoisDay < currentDay!) && (previoisMonth == currentMonth))){
                getQFindOfTheDayFromServer()
                
            }
            else{
                getImage()
            }
            
        }
    }
    func setImageSlideShow(imageArray : NSArray)
    {
       
        categorySliderLoader.stopAnimating()
        categorySliderLoader.isHidden = true
        //KASlideshow
        slideShow.delegate = self
        slideShow.delay = 1
        slideShow.transitionDuration = 1.5
        slideShow.transitionType = KASlideShowTransitionType.slide
        slideShow.imagesContentMode = .scaleAspectFit
        slideShow.images = imageArray as! NSMutableArray
        slideShow.add(KASlideShowGestureType.swipe)
        slideShow.start()
        
        pageControl.numberOfPages = imageArray.count
        pageControl.currentPage = Int(slideShow.currentIndex)
        pageControl.addTarget(self, action: #selector(HomeViewController.pageChanged), for: .valueChanged)
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
        if ((categoryPageNameString == PageNameInCategory.category) && ((categoryDataArray!.count) > 0) ){
            guard categoryDataArray![0].categories_name != nil else{
                return 0
            }
            return (categoryDataArray?.count)!
        }
        else if ((categoryPageNameString == PageNameInCategory.subcategory) && ((subCategoryDataArray!.count) > 0) ){
            guard subCategoryDataArray![0].sub_categories_name != nil else{
                return 0
            }
            return (subCategoryDataArray?.count)!
        }
        else if ((categoryPageNameString == PageNameInCategory.serviceProvider) && ((serviceProviderArray.count) > 0) ){
            guard serviceProviderArray[0].service_provider_name != nil else{
                return 0
            }
            guard serviceProviderArray[0].service_provider_address != nil else{
                return 0
            }
            return (serviceProviderArray.count)
        }
        else{
            return 0
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
        else if (categoryPageNameString == PageNameInCategory.subcategory){
          
            cell.titleCenterConstraint.constant = 0
            cell.subTitleLabel.isHidden = true
            categoryTitle.text = subCategoryName
            let subCategoryDictionary = subCategoryDataArray![indexPath.row]
            
            cell.setSubCategoryCellValues(subCategoryValues: subCategoryDictionary)
        }
        else if(categoryPageNameString == PageNameInCategory.serviceProvider){
            cell.titleCenterConstraint.constant = 7
            cell.subTitleLabel.isHidden = false
            let serviceProviderDict = serviceProviderArray[indexPath.row]
            cell.setServiceProviderCellValues(serviceProviderValues: serviceProviderDict)
            
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
        if  (networkReachability?.isReachable)!{
            if categoryPageNameString == PageNameInCategory.category
            {
                let categoryDict = categoryDataArray![indexPath.row]
                categoryIdVar = categoryDict.categories_id
                if(categoryDict.have_subcategories == true)
                {
                    haveSubCategory = true
                    categoryLoadingView.isHidden = false
                    categoryLoadingView.showLoading()
                    categoryPageNameString = PageNameInCategory.subcategory
                    subCategoryName = categoryDict.categories_name?.uppercased()
                    categoryTitle.text = categoryDict.categories_name?.uppercased()
                   
                    
                    getSubcategoriesFromServer()
                } else {
                    categoryLoadingView.showLoading()
                    haveSubCategory = false
                    categoryPageNameString = PageNameInCategory.serviceProvider
                    offsetValue = 1
                    serviceProviderArray = [ServiceProvider]()
                    serviceProvideId = categoryIdVar
                    categoryTitle.text = categoryDict.categories_name?.uppercased()
                    categoryLoadingView.isHidden = false
                    categoryLoadingView.showLoading()
                    getServiceProviderFromServer(categoryId: categoryIdVar!, offsetValue: 1)
                }
                
                
            }
            else if(categoryPageNameString == PageNameInCategory.subcategory) {
                
                categoryPageNameString = PageNameInCategory.serviceProvider
                offsetValue = 1
                serviceProviderArray = [ServiceProvider]()
                let subCategoryDict = subCategoryDataArray![indexPath.row]
                categoryTitle.text = subCategoryDict.sub_categories_name?.uppercased()
                let subcategoryIdVar = subCategoryDict.sub_categories_id
                serviceProvideId = categoryIdVar
                
                
               
               
                getServiceProviderFromServer(categoryId: subcategoryIdVar!, offsetValue: 1)
            }
            else {
                
                let servicePrividerDict = serviceProviderArray[indexPath.row]
                let informationVC : DetailViewController = storyboard?.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
                controller.view.removeFromSuperview()
                
                informationVC.serviceProviderArrayDict = servicePrividerDict
                self.present(informationVC, animated: false, completion: nil)
            }
            
        }
        else{
            self.categoryLoadingView.stopLoading()
            self.categoryLoadingView.isHidden = true
            
            //self.categoryLoadingView.noDataView.isHidden = false
            let alert = UIAlertController(title: "Network", message: "No Network Available", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(categoryPageNameString == PageNameInCategory.serviceProvider){
            if isLoading {
                return CGSize.zero
            }
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
        else{
            return CGSize.zero
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
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
                tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView(sender:)))
                self.categoryView.addGestureRecognizer(tapGestRecognizer)
                    getPredicateSearchFromServer()
                
                
            }
                            else{
                categoryView.removeGestureRecognizer(tapGestRecognizer)
                                controller.view.removeFromSuperview()
                            }

            
        
       
        return true
    }
    @objc func dismissPopupView(sender: UITapGestureRecognizer)
    {
        categoryView.removeGestureRecognizer(tapGestRecognizer)
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
         categoryView.removeGestureRecognizer(tapGestRecognizer)
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
        categoryLoadingView.isHidden = true
        
        if categoryPageNameString == PageNameInCategory.category{
            self.dismiss(animated: false, completion: nil)
            
            //self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
           
        }
        else if(categoryPageNameString == PageNameInCategory.serviceProvider){
            if haveSubCategory == true{
                categoryPageNameString = PageNameInCategory.subcategory
                categoryCollectionView.reloadData()
            }
            else{
                categoryPageNameString = PageNameInCategory.category
                self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")
                
                categoryCollectionView.reloadData()
            }
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
        if(networkReachability?.isReachable == true){
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
            }}
        
            else{
                self.categoryLoadingView.stopLoading()
                self.categoryLoadingView.isHidden = true
                
                //self.categoryLoadingView.noDataView.isHidden = false
                let alert = UIAlertController(title: "Network", message: "No Network Available", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
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
                           self.categoryLoadingView.stopLoading()
                            self.categoryLoadingView.isHidden = true
                            
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
    //MARK: QFindOfTHeDayAPI
    func getQFindOfTheDayFromServer()
    {
     
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            
            Alamofire.request(QFindRouter.getQFindOfTheDay(["token": tokenString]))
                .responseObject { (response: DataResponse<QfindOfTheDayData>) -> Void in
                    switch response.result {
                        
                    case .success(let data):
                        
                       
                        
                        
                        
                        if ((data.response == "error") || (data.code != "200")){
                            self.categorySliderLoader.stopAnimating()
                        }
                        else{
                             self.categorySliderLoader.stopAnimating()
                            self.categorySliderLoader.isHidden = true
                            let qFindDict = data.qfindOfTheDayData
                            self.imageDownloader(imgArray: (qFindDict?.image)!)
                           
                        }
                    case .failure(let error):
                         self.categorySliderLoader.stopAnimating()
                       
                    }
                    
            }
            
        }
    }
    func imageDownloader(imgArray : NSArray){
        
        while self.categoryQFindArray.count < imgArray.count {
            self.categoryQFindArray.add("")
        }
       
        for var i in (0..<imgArray.count)
        {
            let imageUrl = URL(string: imgArray[i] as! String)
            KingfisherManager.shared.retrieveImage(with: imageUrl!, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                
                if let image = image {
                    self.arrayCount = self.arrayCount! + 1
                    self.categoryQFindArray[i] = image
                   
                    if (self.arrayCount == imgArray.count)
                    {
                        
                        let sliderData = SliderImagesModel(sliderImages: self.categoryQFindArray)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: sliderData)
                        sliderImagesDefault.set(encodedData, forKey: "sliderimages")
                        
                        let date = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day], from: date)
                        
                        sliderImagesDefault.set(components.day, forKey: "sliderDay")
                        sliderImagesDefault.set(components.month, forKey: "sliderMonth")
                        sliderImagesDefault.set(components.year, forKey: "sliderYear")
                        
                        self.getImage()
                        
                        
                    }
                    //your completion logic
                    //...
                } else {
                    // Error
                }
            })
        }
        
        
    }
    func getImage()
    {
        let decoded  = sliderImagesDefault.object(forKey: "sliderimages") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! SliderImagesModel
        self.categoryQFindArray = decodedTeams.sliderImages
        setImageSlideShow(imageArray: self.categoryQFindArray)
    }
    //MARK: ServiceProviderAPI
    func getServiceProviderFromServer(categoryId: Int,offsetValue: Int)
    {
         if (offsetValue < 2){
            categoryLoadingView.isHidden = false
            categoryLoadingView.showLoading()
        
        }
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            Alamofire.request(QFindRouter.getServiceProvider(["token": tokenString,
                                                              "language" :languageKey , "category": categoryId, "limit": 10,"offset": offsetValue]))
                .responseObject { (response: DataResponse<ServiceProviderData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        self.isLoading  = false
                        if ((data.response == "error") || (data.code != "200")){
                            self.categoryCollectionView.reloadData()
                            self.isLoading = false
                            if (offsetValue < 2){
                            self.categoryLoadingView.noDataView.isHidden = false
                            self.categoryLoadingView.showNoDataView()
                            self.categoryLoadingView.noDataLabel.text = "No Results Found"
                            }
                        }
                        else{
                            
                            self.categoryLoadingView.isHidden = true
                            self.categoryLoadingView.stopLoading()
                            for serviceProviderDict in data.serviceProviderData!{
                                self.serviceProviderArray.append(serviceProviderDict)
                            }
                            self.categoryCollectionView.reloadData()
                        }
                        
                        
                    case .failure(let error):
                        self.categoryLoadingView.stopLoading()
                        self.categoryLoadingView.isHidden = true
                        self.categoryCollectionView.reloadData()
                        self.isLoading = false
                         if (offsetValue < 2){
                            self.categoryLoadingView.isHidden = false
                            self.categoryLoadingView.showNoDataView()
                            self.categoryLoadingView.noDataLabel.text = "No Results Found"
                            self.categoryLoadingView.noDataView.isHidden = false
                       
                        }
                    }
                    
            }
            
        }
    }
    //Refreshcontrol
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(categoryPageNameString == PageNameInCategory.serviceProvider){
            let threshold   = 100.0 ;
            let contentOffset = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            let diffHeight = contentHeight - contentOffset;
            let frameHeight = scrollView.bounds.size.height;
            var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
            triggerThreshold   =  min(triggerThreshold, 0.0)
            let pullRatio  = min(fabs(triggerThreshold),1.0);
            self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
            if pullRatio >= 1 {
                self.footerView?.animateFinal()
            }
         
       
        }
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(categoryPageNameString == PageNameInCategory.serviceProvider){
            let contentOffset = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            let diffHeight = contentHeight - contentOffset;
            let frameHeight = scrollView.bounds.size.height;
            let pullHeight  = fabs(diffHeight - frameHeight);
            let pullHeightValue  = floor(pullHeight)
            if pullHeightValue == 0.0
            {
                if (self.footerView?.isAnimatingFinal)! {

                    self.isLoading = true
                    self.footerView?.startAnimate()
                    offsetValue = offsetValue!+1
                    
                    self.getServiceProviderFromServer(categoryId: serviceProvideId!, offsetValue: offsetValue!)
                  
                }
            }
        }
        
    }

}
