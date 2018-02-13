//
//  HistoryViewController.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import CoreData
import UIKit
enum PageName{
    case history
    case searchResult
    case favorite
}

class HistoryViewController: RootViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchBarProtocol,BottomProtocol,predicateTableviewProtocol{
 
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var historySearchBar: SearchBarView!
    @IBOutlet weak var backButtonImageView: UIImageView!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var historyLoadingView: LoadingView!
    @IBOutlet weak var historyBottomBar: BottomBarView!
    @IBOutlet weak var historyView: UIView!
    var controller = PredicateSearchViewController()
    var pageNameString : PageName?
    var predicateSearchKey = String()
    var predicateSearchArray : [PredicateSearch]? = []
    var previousPage : PageName?
    var searchResultArray: [ServiceProvider]? = []
    
    var favoriteServiceProvider : ServiceProvider?
    var searchType : Int?
    var searchKey : String?
    
    var predicateTableHeight : Int?
    var tapGestRecognizer = UITapGestureRecognizer()
    var favoritesArray:[NSManagedObject]?
    var historyArray:[HistoryEntity]?
    var sectionArray: [HistoryEntity] = []
    var historyFullArray = NSMutableArray()
    var sectionDict: HistoryEntity?
    var favoriteDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUi()
        setRTLSupportForHistory()
        registerCell()
        
        fetchHistoryInfo()
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
        setLocalizedVariable()
        
        
        if (pageNameString == PageName.searchResult)
        {
            guard let searchItemType = self.searchType else{
                return
            }
            guard let searchItemKey = self.searchKey else{
                return
            }
            getSearchResultFromServer(searchType: searchItemType, searchKey: searchItemKey)
        }
        else if (pageNameString == PageName.favorite){
            fetchDataFromCoreData()
        }
        
    }
    func setUi()
    {
        historySearchBar.searchDelegate = self
        historyBottomBar.bottombarDelegate = self
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
        historyLoadingView.isHidden = false
        historyLoadingView.showLoading()
        historyLabel.textAlignment = .center
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setRTLSupportForHistory()
    {
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
                
                historySearchBar.searchText.textAlignment = .left
                if let _img = backButtonImageView.image{
                    backButtonImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.downMirrored)
                }
            }
            else{
                
                historySearchBar.searchText.textAlignment = .right
                if let _img = backButtonImageView.image {
                    backButtonImageView.image = UIImage(cgImage: _img.cgImage!, scale:_img.scale , orientation: UIImageOrientation.upMirrored)
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    func setLocalizedVariable()
    {
        
        self.historySearchBar.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the search bar ")
        switch pageNameString {
        case .history?:
            self.historyLabel.text = NSLocalizedString("HISTORY", comment: "HISTORY Label in the history page")
            historyBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        case .favorite? :
            self.historyLabel.text = NSLocalizedString("Favorites", comment: "Favorites Title Label in the Favorites page").uppercased()
            historyBottomBar.favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        case .searchResult? :
            self.historyLabel.text = NSLocalizedString("Search_results", comment: "Search_results Title Label in the history page").uppercased()
        default:
            break
        }
        
    }
    func registerCell()
    {
        
        let nib = UINib(nibName: "HistoryOrSearchCell", bundle: nil)
        historyCollectionView?.register(nib, forCellWithReuseIdentifier: "historyCellId")
    }
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch pageNameString{
        case .history?:
            if(historyFullArray.count != 0){
                return historyFullArray.count
            }
            else{
                return 0
            }
            
            
            
        case .favorite?:
            if (favoritesArray?.count != 0){
                return 1
            }else{
                return 0
            }
            
        case .searchResult?:
            if (searchResultArray!.count > 0)
            {
                if((searchResultArray![0].service_provider_name) != nil && (searchResultArray![0].service_provider_address) != nil)
                {
                    return 1
                }
                    
                else{
                    return 0
                }
            }
            else
            {
                return 0
            }
        default:
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch pageNameString{
        case .history?:
            let itemCount = historyFullArray[section] as! NSArray
            
            return itemCount.count
        case .favorite?:
            return (favoritesArray?.count)!
        case .searchResult?:
            return (searchResultArray?.count)!
        default:
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HistoryCollectionViewCell = historyCollectionView.dequeueReusableCell(withReuseIdentifier: "historyCellId", for: indexPath) as! HistoryCollectionViewCell
        
        switch pageNameString{
        case .history?:
            
            let history = historyFullArray[indexPath.section] as! [HistoryEntity]
            let sectionHistory = history[indexPath.row]
            cell.setHistoryData(historyInfo: sectionHistory)
            cell.favoriteButton.isHidden = true
        case .favorite?:
            cell.favBtnTapAction = {
                () in
                
                self.deleteFavorite(currentIndex: indexPath)
                
            }
            cell.favoriteButton.isHidden = false
            let favoriteDict = favoritesArray![indexPath.row]
            let id = favoriteDict.value(forKey: "id")
            let name = favoriteDict.value(forKey: "name")
            let shortDescription = favoriteDict.value(forKey: "shortdescription")
            let img = favoriteDict.value(forKey: "imgurl")
            cell.setFavoriteData(favoriteId: id as! Int, favoriteName: name as! String, subTitle: shortDescription as! String, imgUrl: img as! String)
            
        case .searchResult?:
            cell.favoriteButton.isHidden = true
            let searchResultDict = searchResultArray![indexPath.row]
            cell.searchResultData(searchResultCellValues: searchResultDict)
        default:
            break
            
        }
        
        let shadowSize : CGFloat = 5.0
        var shadowPath : UIBezierPath?
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
                //left
                shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                       y: -shadowSize / 2,
                                                       width: cell.frame.size.width - (shadowSize*3) ,
                                                       height: cell.frame.size.height + shadowSize ))
            }
            else{
                
                shadowPath = UIBezierPath(rect: CGRect(x:  shadowSize*3,
                                                       y: -shadowSize / 2,
                                                       width: cell.frame.size.width + shadowSize*5  ,
                                                       height: cell.frame.size.height + shadowSize ))
            }
        } else {
            // Fallback on earlier versions
        }
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowOpacity = 0.19
        cell.layer.shadowPath = shadowPath?.cgPath
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            return CGSize(width: historyCollectionView.frame.width, height: heightValue*10)
        }
        else{
            return CGSize(width: historyCollectionView.frame.width, height: heightValue*9)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = historyCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
        switch pageNameString {
        case .history?:
            if historyFullArray.count != 0{
                let history = historyFullArray[indexPath.section] as! [HistoryEntity]
                let sectionHistory = history[indexPath.row]
                let dateString = setDateFormat(dateData: sectionHistory.date_history!)
                
                header.headerLabel.text = dateString
                let currentDateString = setDateFormat(dateData: Date())
                if(dateString == currentDateString){
                    header.headerLabel.text = NSLocalizedString("Today", comment: "section header Label in the history page")
                }
                
                
                
                
                
                if(indexPath.section == 1){
                    
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                    let unitFlags = Set<Calendar.Component>([.year, .month, .day])
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(identifier: "UTC")!
                    let components = calendar.dateComponents(unitFlags, from: yesterday)
                    let yesterdayDate = calendar.date(from: components)
                    if(sectionHistory.date_history == yesterdayDate){
                        header.headerLabel.text = NSLocalizedString("Yesterday", comment: "section header Label in the history page")
                    }
                }
                
            }
        case .favorite? :
            header.headerLabel.text = ""
        case .searchResult? :
            header.headerLabel.text = ""
        default:
            break
        }
        
        
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        let heightValue = UIScreen.main.bounds.height/100
        switch pageNameString {
        case .history?:
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return CGSize(width: historyCollectionView.frame.width, height: heightValue*8)
            }
            else{
                return CGSize(width: historyCollectionView.frame.width, height: heightValue*8)
            }
        case .favorite? :
            return CGSize.zero
        case .searchResult? :
            return CGSize.zero
        default:
            return CGSize.zero
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (pageNameString == PageName.searchResult){
            let servicePrividerDict = searchResultArray![indexPath.row]
            let informationVC : DetailViewController = storyboard?.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
            self.historyView.removeGestureRecognizer(tapGestRecognizer)
            controller.view.removeFromSuperview()
            
            informationVC.serviceProviderArrayDict = servicePrividerDict
            self.present(informationVC, animated: false, completion: nil)
        }
        else if (pageNameString == PageName.favorite){
            
            let favoriteServiceDict = favoritesArray![indexPath.row]
            let informationVC : DetailViewController = storyboard?.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
            self.historyView.removeGestureRecognizer(tapGestRecognizer)
            controller.view.removeFromSuperview()
            setFavoriteDictionary(favDict: favoriteServiceDict)
            
            informationVC.favoriteDictinary = favoriteDictionary
            informationVC.fromFavorite = true
            self.present(informationVC, animated: false, completion: nil)
            
        }
        else if (pageNameString == PageName.history){
            
            let historyServiceDict = historyArray![indexPath.row] as HistoryEntity
            let informationVC : DetailViewController = storyboard?.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
            
            self.historyView.removeGestureRecognizer(tapGestRecognizer)
            controller.view.removeFromSuperview()
            
            informationVC.fromHistory = true
            informationVC.historyDict = historyServiceDict
            
            self.present(informationVC, animated: false, completion: nil)
            
        }
    }
    func setFavoriteDictionary(favDict: NSManagedObject){
        favoriteDictionary.setValue(favDict.value(forKey: "address"), forKey: "address")
        favoriteDictionary.setValue(favDict.value(forKey: "category"), forKey: "category")
        favoriteDictionary.setValue(favDict.value(forKey: "email"), forKey: "email")
        favoriteDictionary.setValue(favDict.value(forKey: "facebookpage"), forKey: "facebookpage")
        favoriteDictionary.setValue(favDict.value(forKey: "googlepluspage"), forKey: "googlepluspage")
        favoriteDictionary.setValue(favDict.value(forKey: "id"), forKey: "id")
        favoriteDictionary.setValue(favDict.value(forKey: "imgurl"), forKey: "imgurl")
        favoriteDictionary.setValue(favDict.value(forKey: "instagrampage"), forKey: "instagrampage")
        favoriteDictionary.setValue(favDict.value(forKey: "linkedinpage"), forKey: "linkedinpage")
        
        favoriteDictionary.setValue(favDict.value(forKey: "maplocation"), forKey: "maplocation")
        
        favoriteDictionary.setValue(favDict.value(forKey: "mobile"), forKey: "mobile")
        
        favoriteDictionary.setValue(favDict.value(forKey: "name"), forKey: "name")
        favoriteDictionary.setValue(favDict.value(forKey: "openingtime"), forKey: "openingtime")
        favoriteDictionary.setValue(favDict.value(forKey: "shortdescription"), forKey: "shortdescription")
        favoriteDictionary.setValue(favDict.value(forKey: "snapchatpage"), forKey: "snapchatpage")
        favoriteDictionary.setValue(favDict.value(forKey: "twitterpage"), forKey: "twitterpage")
        favoriteDictionary.setValue(favDict.value(forKey: "website"), forKey: "website")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: BottomBar
    func favouriteButtonPressed() {
        
        setBottomBarFavoriteBackground()
        previousPage = pageNameString
        if (pageNameString != PageName.favorite)
        {
            historyLoadingView.isHidden = true
            pageNameString = PageName.favorite
            fetchDataFromCoreData()
            setLocalizedVariable()
            historyCollectionView.reloadData()
            
        }
        
        
        
    }
    func homebuttonPressed() {
        historyBottomBar.favoriteview.backgroundColor = UIColor.white
        historyBottomBar.historyView.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    func historyButtonPressed() {
        setBottomBarHistoryBackground()
        previousPage = pageNameString
        if (pageNameString != PageName.history){
            
            pageNameString = PageName.history
            
            setLocalizedVariable()
            historyLoadingView.isHidden = true
            historyCollectionView.reloadData()
            
            
        }
    }
    func setBottomBarHistoryBackground(){
        historyBottomBar.favoriteview.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.white
        historyBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        historySearchBar.searchText.text = ""
    }
    func setBottomBarFavoriteBackground(){
        historyBottomBar.historyView.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.white
        historyBottomBar.favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        historySearchBar.searchText.text = ""
    }
    func setBottomBarSearchBackground(){
        historyBottomBar.favoriteview.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.white
        historyBottomBar.historyView.backgroundColor = UIColor.white
        historySearchBar.searchText.text = ""
    }
    //MARK:Searchbar
    func searchButtonPressed() {
        self.historyView.removeGestureRecognizer(tapGestRecognizer)
        controller.view.removeFromSuperview()
        let trimmedText = historySearchBar.searchText.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if historySearchBar.searchText.text == ""
        {
            
            let alert = UIAlertController(title: "Alert", message: "Please Enter Search Text", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else{
            previousPage = pageNameString
            pageNameString = PageName.searchResult
            setLocalizedVariable()
            
            guard let searchItemKey = trimmedText else{
                return
            }
            getSearchResultFromServer(searchType: 4, searchKey: searchItemKey)
            
        }
        // controller.predicateSearchTable.reloadData()
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
            self.controller.view.frame = CGRect(x: self.historySearchBar.searchInnerView.frame.origin.x, y:self.historySearchBar.searchInnerView.frame.origin.y+self.historySearchBar.searchInnerView.frame.height+20, width: self.historySearchBar.searchInnerView.frame.width, height: 0)
            addChildViewController(controller)
            view.addSubview((controller.view)!)
            controller.didMove(toParentViewController: self)
            
            tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView(sender:)))
            self.historyView.addGestureRecognizer(tapGestRecognizer)
            getPredicateSearchFromServer()
            
            
        }
        else{
            self.historyView.removeGestureRecognizer(tapGestRecognizer)
            controller.view.removeFromSuperview()
        }
        return true
    }
    @objc func dismissPopupView(sender: UITapGestureRecognizer)
    {
        self.historyView.removeGestureRecognizer(tapGestRecognizer)
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
        let predicateSearchdict = predicateSearchArray![indexPath.row]
        historySearchBar.searchText.text = predicateSearchdict.search_name
        self.historyView.removeGestureRecognizer(tapGestRecognizer)
        controller.view.removeFromSuperview()
        setBottomBarSearchBackground()
        previousPage = pageNameString
        pageNameString = PageName.searchResult
        setLocalizedVariable()
        guard let searchItemType = predicateSearchdict.search_type else{
            return
        }
        guard let searchItemKey = predicateSearchdict.search_name else{
            return
        }
        getSearchResultFromServer(searchType: searchItemType, searchKey: searchItemKey)
        
        controller.predicateSearchTable.reloadData()
        
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        historySearchBar.searchText.text = ""
        if ((previousPage == PageName.history)&&(pageNameString == PageName.searchResult)){
            previousPage = pageNameString
            pageNameString = PageName.history
            setLocalizedVariable()
            setBottomBarHistoryBackground()
            historyCollectionView.reloadData()
        }
        else if((previousPage == PageName.favorite)&&(pageNameString == PageName.searchResult)){
            
            previousPage = pageNameString
            pageNameString = PageName.favorite
            setLocalizedVariable()
            setBottomBarFavoriteBackground()
            historyCollectionView.reloadData()
        }
            
        else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    func getPredicateSearchFromServer()
    {
        let trimmedSearchKey = self.predicateSearchKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            
            Alamofire.request(QFindRouter.getPredicateSearch(["token": tokenString,
                                                              "search_key":  trimmedSearchKey , "language" :languageKey]))
                .responseObject { (response: DataResponse<PredicateSearchData>) -> Void in
                    switch response.result {
                        
                    case .success(let data):
                        
                        self.predicateSearchArray = data.predicateSearchData
                        self.controller.predicateSearchTable.reloadData()
                        if ((self.predicateSearchArray?.count == 1) && (self.predicateSearchArray![0].item_id == nil))
                        {
                            self.controller.view.frame = CGRect(x: self.historySearchBar.searchInnerView.frame.origin.x, y:self.historySearchBar.searchInnerView.frame.origin.y+self.historySearchBar.searchInnerView.frame.height+20, width: 0, height: 0)
                        }else{
                            self.controller.view.frame = CGRect(x: self.historySearchBar.searchInnerView.frame.origin.x, y:self.historySearchBar.searchInnerView.frame.origin.y+self.historySearchBar.searchInnerView.frame.height+20, width: self.historySearchBar.searchInnerView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*(self.predicateTableHeight)!))
                        }
                        
                    case .failure(let error):
                        self.historyLoadingView.isHidden = false
                        self.historyLoadingView.stopLoading()
                        self.historyLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }
    func getSearchResultFromServer(searchType: Int, searchKey: String)
    {
        historyLoadingView.isHidden = false
        historyLoadingView.showLoading()
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            Alamofire.request(QFindRouter.getSearchResult(["token": tokenString,
                                                           "search_key": searchKey , "language" :languageKey , "search_type": searchType]))
                .responseObject { (response: DataResponse<SearchResultData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        
                        self.searchResultArray = data.searchResultData
                        
                        if ((data.response == "error") || (data.code != "200")){
                            self.historyLoadingView.stopLoading()
                            self.historyLoadingView.noDataView.isHidden = false
                            self.historyCollectionView.reloadData()
                            self.historyLoadingView.showNoDataView()
                            self.historyLoadingView.noDataLabel.text = "No Results Found"
                        }
                        else{
                            
                            self.historyLoadingView.isHidden = true
                            self.historyLoadingView.stopLoading()
                            
                            self.historyCollectionView.reloadData()
                        }
                        
                        
                    case .failure(let error):
                        self.historyLoadingView.isHidden = false
                        self.historyLoadingView.stopLoading()
                        self.historyCollectionView.reloadData()
                        self.historyLoadingView.showNoDataView()
                        self.historyLoadingView.noDataLabel.text = "No Results Found"
                        self.historyLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }
    
    func fetchDataFromCoreData() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        var managedContext : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            managedContext =
                appDelegate.persistentContainer.viewContext
        } else {
            
            managedContext = appDelegate.managedObjectContext
        }
        let favoritesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteEntity")
        
        do {
            favoritesArray = try managedContext?.fetch(favoritesFetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (favoritesArray?.count != 0){
            self.historyLoadingView.isHidden = true
            self.historyLoadingView.stopLoading()
            
        }
        else{
            self.historyLoadingView.isHidden = false
            self.historyLoadingView.stopLoading()
            self.historyLoadingView.showNoDataView()
            self.historyLoadingView.noDataLabel.text = "No Favorites Found"
            self.historyLoadingView.noDataView.isHidden = false
            
        }
        historyCollectionView.reloadData()
        
        
        
    }
    
    
    func deleteFavorite(currentIndex: IndexPath){
        var refreshAlert = UIAlertController(title: "Item will be deleted from favorites", message: "Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            var managedContext : NSManagedObjectContext?
            if #available(iOS 10.0, *) {
                managedContext =
                    appDelegate.persistentContainer.viewContext
                
            } else {
                // Fallback on earlier versions
                managedContext = appDelegate.managedObjectContext
                
            }
            managedContext?.delete(self.favoritesArray![currentIndex.row])
            do {
                try managedContext?.save()
                self.favoritesArray?.remove(at: currentIndex.row)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            if (self.favoritesArray?.count == 0){
                self.historyLoadingView.isHidden = false
                self.historyLoadingView.stopLoading()
                self.historyLoadingView.showNoDataView()
                self.historyLoadingView.noDataLabel.text = "No Favorites Found"
                self.historyLoadingView.noDataView.isHidden = false
            }
            self.historyCollectionView.reloadData()
        }))
        //cancel action
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
        
    }
    func fetchHistoryInfo(){
        let managedContext = getContext()
        let historyFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEntity")
        let sort = NSSortDescriptor(key: #keyPath(HistoryEntity.date_history), ascending: false)
        historyFetchRequest.sortDescriptors = [sort]
        do {
            historyArray = try managedContext.fetch(historyFetchRequest) as? [HistoryEntity]
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (historyArray?.count != 0){
            self.historyLoadingView.isHidden = true
            self.historyLoadingView.stopLoading()
            self.setHistoryArray(historyInfo: historyArray!)
            
            
        }
        else{
            self.historyLoadingView.isHidden = false
            self.historyLoadingView.stopLoading()
            self.historyLoadingView.showNoDataView()
            self.historyLoadingView.noDataLabel.text = "No History Found"
            self.historyLoadingView.noDataView.isHidden = false
            
        }
        historyCollectionView.reloadData()
        
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
    func setHistoryArray(historyInfo: [HistoryEntity]){
        
        
        for i in 0 ..< historyInfo.count {
            if (i == 0){
                sectionArray.append(historyInfo[i])
            }
            else{
                if ((historyInfo[i].date_history) == (historyInfo[i-1]).date_history){
                    sectionArray.append(historyInfo[i])
                    if(i == historyInfo.count-1){
                        historyFullArray.add(sectionArray)
                    }
                }
                else{
                    historyFullArray.add(sectionArray)
                    sectionArray = [HistoryEntity]()
                    sectionArray.append(historyInfo[i])
                }
            }
        }
        if (historyInfo.count == 1){
            historyFullArray.add(sectionArray)
        }
    }
    func setDateFormat(dateData: Date)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let stringDate = dateFormatter.string(from: dateData)
        return stringDate
    }
    
}

