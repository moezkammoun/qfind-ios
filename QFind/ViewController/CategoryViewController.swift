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
class CategoryViewController: UIViewController,KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BottomProtocol,SearchBarProtocol,predicateTableviewProtocol {
    
    @IBOutlet weak var bottomBar: BottomBarView!
    
    @IBOutlet weak var categoryLoadingView: LoadingView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var slideShow: KASlideShow!
     var controller = PredicateSearchViewController()
     var tapGesture = UITapGestureRecognizer()
     var categoryPageNameString : PageNameInCategory?
    var dummyString = String()
     var bannerArray = NSArray()
    var categoryDataArray : [Category]? = []
    var subCategoryDataArray : [SubCategory]? = []
    var subCategoryTitle : String?
    var categoryIdVar : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

       
        registerNib()
        setUpUi()
        
        categoryPageNameString = PageNameInCategory.category
        getCategoriesFromServer()
        setLocalizedVariables()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setRTLSupport()
        setImageSlideShow()
        //setLocalizedVariables()
        bottomBar.favoriteview.backgroundColor = UIColor.white
        bottomBar.historyView.backgroundColor = UIColor.white
        bottomBar.homeView.backgroundColor = UIColor.white
        //categoryPageNameString = PageNameInCategory.category
       
    }
    
    func setUpUi()
    {
        categoryTitle.textAlignment = .center
        
        bottomBar.bottombarDelegate = self
        
        searchBarView.searchDelegate = self
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
                
                
                
            }
            else{
                slideShow.arabic = true
                 searchBarView.searchText.textAlignment = .right
            }
        } else {
            // Fallback on earlier versions
        }
        
        
       
    }
    func setLocalizedVariables()
    {
        
         self.categoryTitle.text = NSLocalizedString("CATEGORIES", comment: "CATEGORIES Label in the category page")

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
            print(subCategoryDictionary)
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
      
       
        
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        
        historyVC.pageNameString = PageName.favorite
        self.present(historyVC, animated: false, completion: nil)
    }
    func homebuttonPressed() {

      
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func historyButtonPressed() {
        
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
       
        historyVC.pageNameString = PageName.history
        self.present(historyVC, animated: false, completion: nil)
    }
    // MARK: Searchbar
    func searchButtonPressed() {
        
    }
    func textField(_ textField: UITextField, shouldChangeSearcgCharacters range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if let countValue = searchBarView.searchText.text
        {
//            if ((countValue.count) >= 1)
//            {
                if ((controller.view.tag == 0)&&(isBackSpace != -92))
                {
                    
                    switch countValue
                    {
                    case  "ho" :
                        dummyString = "Hotel"
                    case "re" :
                        dummyString = "Restaurant"
                    case "Hos" :
                        dummyString = "Hospital"
                    default :
                        dummyString = ""
                        
                        
                    }
                    controller.view.tag = 1
                    
                    controller.predicateProtocol = self
                    addChildViewController(controller)
                    controller.view.frame = CGRect(x: searchBarView.searchInnerView.frame.origin.x, y:
                        
                        //give height as number of items * height of cell. height is set in PredicateVC
                        searchBarView.searchInnerView.frame.origin.y+searchBarView.searchInnerView.frame.height+20, width: searchBarView.searchInnerView.frame.width, height: 300)
                    
                    view.addSubview((controller.view)!)
                    controller.didMove(toParentViewController: self)
                    
                    
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(HistoryViewController.removeSubview))
                    self.view.addGestureRecognizer(tapGesture)
                    controller.predicateSearchTable.reloadData()
                }
                
            }
            
       // }
       
        return true
    }

    @objc func removeSubview()
    {
        controller.view.removeFromSuperview()
        controller.view.tag = 0
        
    }
    // MARK: Tableview
    func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PredicateCell = tableView.dequeueReusableCell(withIdentifier: "predicateCellId") as! PredicateCell!
        if (searchBarView.searchText.isEqual("ho"))
        {
            cell.precictaeTxet.text = "Hotel"
        }
       else if (searchBarView.searchText.isEqual("hos"))
        {
            cell.precictaeTxet.text = "Hospital"
        }
        cell.precictaeTxet.text = "Hospital"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int {
        return 6
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
                print(categoryIdVar!)
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
                           // self.categoryLoadingView.isHidden = false
                           // self.categoryLoadingView.stopLoading()
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
    

}
