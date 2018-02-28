//
//  HomeViewController.swift
//  QFind
//
//  Created by Exalture on 12/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import Kingfisher
import UIKit

let sliderImagesDefault = UserDefaults.standard

class HomeViewController: RootViewController,UITextFieldDelegate, KASlideShowDelegate,predicateTableviewProtocol {
    
    static let sharedHome = HomeViewController()
    @IBOutlet weak var findByCategoryButton: UIButton!
    @IBOutlet weak var findByCategoryLabel: UILabel!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var qfindDayLabel: UILabel!
    @IBOutlet weak var scrollSubView: UIView!
    @IBOutlet weak var sliderLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var homeLoadingView: LoadingView!
    @IBOutlet weak var slideShow: KASlideShow!
    @IBOutlet weak var orLabel: UILabel!
    
    
    @IBOutlet weak var aspectRationHome: NSLayoutConstraint!
    let networkReachability = NetworkReachabilityManager()
    var controller = PredicateSearchViewController()
    var predicateSearchArray : [PredicateSearch]? = []
    var predicateSearchKey = String()
     var predicateTableHeight : Int?
    var qFindDict : QFindOfTheDay?
    var qFindArray = NSMutableArray()
    var qfindImageDict = NSMutableDictionary()
    var countValue : Int?
    var arrayCount : Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUILayout()
        sliderLoading.isHidden = false
        sliderLoading.startAnimating()
        
        if (networkReachability?.isReachable == false) {
       
            self.view.hideAllToasts()
            let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
            self.view.makeToast(checkInternet)
            sliderLoading.stopAnimating()
        }
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.slideShow.addImage(UIImage(named: "sliderPlaceholder"))
        predicateSearchKey = ""
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            predicateTableHeight = 85
        }
        else{
            predicateTableHeight = 50
        }
        
        setRTLSupport()
        setLocalizedStrings()
        searchText.text = ""
        setHomeSliderImages()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        setFontForHomeView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setRTLSupport() {
        if #available(iOS 9.0, *) {
           
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
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
    func setSlideShow(imgArray : NSArray) {
       
        sliderLoading.stopAnimating()
        sliderLoading.isHidden = true
       
            //KASlideshow
            slideShow.delegate = self
            slideShow.delay = 1
            slideShow.transitionDuration = 1.5
            slideShow.transitionType = KASlideShowTransitionType.slide
            slideShow.imagesContentMode = .scaleAspectFit
            slideShow.images = imgArray as! NSMutableArray
            slideShow.add(KASlideShowGestureType.swipe)
            slideShow.start()
            pageControl.numberOfPages = imgArray.count
            pageControl.currentPage = Int(slideShow.currentIndex)
            pageControl.addTarget(self, action: #selector(HomeViewController.pageChanged), for: .valueChanged)
        
        
    }
    func setUILayout() {
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
        
        searchView.layer.cornerRadius = 7.5
        searchView.layer.borderWidth = 2.0
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        searchText.delegate = self
        

        self.findByCategoryButton.layer.masksToBounds = false;
        self.findByCategoryButton.layer.shadowOffset = CGSize(width: -1, height: 15)
        self.findByCategoryButton.layer.shadowRadius = 12;
        self.findByCategoryButton.layer.shadowOpacity = 0.5;
     
    }
    func setLocalizedStrings() {
       
        self.qfindDayLabel.text = NSLocalizedString("QFIND_OF_THE_DAY", comment: "QFIND_OF_THE_DAY Label in the home page")
       
    
        self.findByCategoryLabel.text = NSLocalizedString("FIND_BY_CATEGORY", comment: "FIND_BY_CATEGORY Label in the home page")
        self.orLabel.text = NSLocalizedString("OR", comment: "OR Label in the home page")
        // setFontForHomeView()
    }
    func setHomeSliderImages() {
        let sliderImagesArray = sliderImagesDefault.value(forKey: "sliderimages")
        if (sliderImagesArray == nil)
        {
            getQFindOfTheDayFromServer()
        }
        else{
            let needToCallWebservice = getArrayCount()
            
            let sliderDate = sliderImagesDefault.value(forKey: "sliderDate") as! Date
            let isSameDate = Calendar.current.isDate(sliderDate, inSameDayAs:Date())
            if(isSameDate && needToCallWebservice == false) {
                getImage()
            }
            else {
                 getQFindOfTheDayFromServer()
            }
            
        }

    }
    func getArrayCount() -> Bool
    {
        let decoded  = sliderImagesDefault.object(forKey: "sliderimages") as! Data
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! SliderImagesModel
        let sliderArray = decodedTeams.sliderImages
        let sliderArrayCount = sliderArray.count
        for var i in (0..<sliderArray.count) {
            let index = sliderArray.index(of: "")
            if (index < 5) {
                sliderArray.removeObject(at: index)
            }
        }
        if sliderArrayCount == sliderArray.count {
            return false
        }
        return true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
       
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 250
               
            }
        }
        else {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 250
              
            }
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      
        if(UIDevice.current.userInterfaceIdiom == .pad) {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 250
            }
        }
        else {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 250
            }
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
//        if ((predicateSearchKey.count) > 0 ) {
//                        searchButton.isHidden = false
//                    }
//                    else {
//                        searchButton.isHidden = true
//                    }
    
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
        searchText.text = predicatedict.search_name
        controller.view.removeFromSuperview()
        let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
        historyVC.pageNameString = PageName.searchResult
        historyVC.searchType = predicatedict.search_type
        historyVC.searchKey = predicatedict.search_name
        self.present(historyVC, animated: false, completion: nil)
    }
    
    @IBAction func didTapFindCategory(_ sender: UIButton) {
        if  (networkReachability?.isReachable)! {
           
            controller.view.removeFromSuperview()
            slideShow.stop()
            let categoryVC : CategoryViewController = storyboard?.instantiateViewController(withIdentifier: "categoryId") as! CategoryViewController
            
            self.present(categoryVC, animated: false, completion: nil)
            
        }
        else {
            //let toastMessage = NSLocalizedString("checkInternet", comment: "checkInternet toast in the Home")
            self.view.hideAllToasts()
            let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
            self.view.makeToast(checkInternet)
           
        }
       
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
                                self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y-CGFloat(3*(self.predicateTableHeight!))-3, width: self.searchView.frame.width, height: (CGFloat(self.predicateTableHeight!*3)))
                            }
                            else if ((self.predicateSearchArray?.count == 1) && (self.predicateSearchArray![0].item_id == nil))
                                {
                                    self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y, width: 0, height: 0)
                                }else{

                                    
                                self.controller.view.frame = CGRect(x: self.searchView.frame.origin.x, y:self.searchView.frame.origin.y-CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight!)), width: self.searchView.frame.width, height:  CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight!)))
                                    
                                
                                }
                        }
                        
                        
                        
                    case .failure(let error):
                        print("error")
                      
                    }
                    
            }
            
        }
    }
    
    @IBAction func didTapHomeSearch(_ sender: UIButton) {
        controller.view.removeFromSuperview()
       
         if  (networkReachability?.isReachable)!  {
        
            if ((predicateSearchKey.count) > 0 ) {
                 let trimmedText = searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let historyVC : HistoryViewController = storyboard?.instantiateViewController(withIdentifier: "historyId") as! HistoryViewController
                historyVC.searchType = 4
                historyVC.searchKey = trimmedText
                historyVC.pageNameString = PageName.searchResult
                self.present(historyVC, animated: false, completion: nil)
            }
           
       
        }
        else{
                self.view.hideAllToasts()
                searchText.resignFirstResponder()
                let checkInternet =  NSLocalizedString("Check_internet", comment: "check internet message")
                self.view.makeToast(checkInternet)
           
        }
        
    }
    func getQFindOfTheDayFromServer()
    {
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
           
                Alamofire.request(QFindRouter.getQFindOfTheDay(["token": tokenString]))
                    .responseObject { (response: DataResponse<QfindOfTheDayData>) -> Void in
                        switch response.result {
                            
                        case .success(let data):
                            
                           
                            
                            if ((data.response == "error") || (data.code != "200")){
                                self.sliderLoading.stopAnimating()
                                self.sliderLoading.isHidden = true
                                self.slideShow.addImage(UIImage(named: "sliderPlaceholder"))
                            }
                            else{
                                //self.sliderLoading.stopAnimating()
                                //self.sliderLoading.isHidden = true
                                self.qFindDict = data.qfindOfTheDayData
                                
                                self.imageDownloader(imgArray: (self.qFindDict?.image)!.mutableCopy() as! NSMutableArray)
                            }
                        case .failure(let error):
                            self.sliderLoading.stopAnimating()
                            self.sliderLoading.isHidden = true
                            self.slideShow.addImage(UIImage(named: "sliderPlaceholder"))
                          
                        }
                        
                }
            
        }else{
            
        }
    }
    
    
    func imageDownloader(imgArray : NSMutableArray){
        
        while self.qFindArray.count < imgArray.count {
            self.qFindArray.add("")
        }
        

        for var i in (0..<imgArray.count)
        {
            let slideiImageUrl = URL(string: imgArray[i] as! String)
            KingfisherManager.shared.retrieveImage(with: slideiImageUrl!, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                ImageDownloader.default.downloadTimeout = 70
                if let image = image {
                    self.arrayCount = self.arrayCount! + 1

                    self.qFindArray[i] = image

                    if (self.arrayCount == imgArray.count)
                    {
                        
                        
                        let sliderData = SliderImagesModel(sliderImages: self.qFindArray)
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: sliderData)
                        sliderImagesDefault.set(encodedData, forKey: "sliderimages")
                        sliderImagesDefault.set(Date(), forKey: "sliderDate")
                        self.getImage()
                    
                        
                    }
                   
                } else {
                   
                    print(error)
                }
            })
        }
 
   
    }
 func getImage(){
    let decoded  = sliderImagesDefault.object(forKey: "sliderimages") as! Data
    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! SliderImagesModel
    self.qFindArray = decodedTeams.sliderImages
    
    for var i in (0..<qFindArray.count) {
         let index = self.qFindArray.index(of: "")
            if (index < 5) {
                self.qFindArray.removeObject(at: index)
            }
    }
    setSlideShow(imgArray: self.qFindArray)
    }
    func setFontForHomeView() {
         let searchPlaceHolder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the home page")
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            qfindDayLabel.font = UIFont(name: "Lato-Regular", size: qfindDayLabel.font.pointSize)
            findByCategoryLabel.font = UIFont(name: "Lato-Bold", size: qfindDayLabel.font.pointSize)
            orLabel.font = UIFont(name: "Lato-Regular", size: orLabel.font.pointSize)
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.init(red: 202/255, green: 201/255, blue: 201/255, alpha: 1),
                NSAttributedStringKey.font : UIFont(name: "Lato-Regular", size: (searchText.font?.pointSize)!)! // Note the !
            ]
            
            searchText.attributedPlaceholder = NSAttributedString(string: searchPlaceHolder, attributes:attributes)
            
        }
        else {
            qfindDayLabel.font = UIFont(name: "GESSUniqueLight-Light", size: qfindDayLabel.font.pointSize)
             findByCategoryLabel.font = UIFont(name: "GESSUniqueBold-Bold", size: qfindDayLabel.font.pointSize)
            orLabel.font = UIFont(name: "GESSUniqueLight-Light", size: orLabel.font.pointSize)
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.init(red: 202/255, green: 201/255, blue: 201/255, alpha: 1),
                NSAttributedStringKey.font : UIFont(name: "GESSUniqueLight-Light", size: (searchText.font?.pointSize)!)! // Note the !
            ]
          
            searchText.attributedPlaceholder = NSAttributedString(string: searchPlaceHolder, attributes: attributes)
        }
       
    }
    

}
