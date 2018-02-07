//
//  HistoryViewController.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
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
    //var predicateSearchdict : PredicateSearch?
    var searchType : Int?
    var searchKey : String?
    var favoriteArray : NSMutableArray?
    var predicateTableHeight : Int?
    var tapGestRecognizer = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUi()
        setRTLSupportForHistory()
        registerCell()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch pageNameString{
        case .history?:
            return 3
        case .favorite?:
            return 3
        case .searchResult?:
            return (searchResultArray?.count)!
        default:
            return 0
            
        }
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch pageNameString{
        case .history?:
            historyLoadingView.isHidden = true
            return 3
            
           
            
        case .favorite?:
           // if (favoriteArray?.count != 0){
             historyLoadingView.isHidden = true
                return 1
               
           
//            }
//            else{
//                return 0
//            }
        
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
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell : HistoryCollectionViewCell = historyCollectionView.dequeueReusableCell(withReuseIdentifier: "historyCellId", for: indexPath) as! HistoryCollectionViewCell
        
        switch pageNameString{
        case .history?:
            cell.favoriteButton.isHidden = true
            cell.titleLabel.text = "Four Season Hotel"
            cell.subLabel.text = "qwerty uiop"
        case .favorite?:
            cell.favoriteButton.isHidden = false
            cell.titleLabel.text = "Four Season Hotel"
            cell.subLabel.text = "qwerty uiop"
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
                if (indexPath.section == 0)
                {
                    header.headerLabel.text = NSLocalizedString("Today", comment: "section header Label in the history page")
                    
                    // header.headerLabel.text = "Today"
                }
                else if (indexPath.section == 1){
                    header.headerLabel.text = NSLocalizedString("Yesterday", comment: "section header Label in the history page")
                }
                else {
                    header.headerLabel.text = "21-1-2018"
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
            pageNameString = PageName.favorite
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
//        else if((previousPage == PageName.searchResult)&&(pageNameString == PageName.history))
//    {
//            previousPage = pageNameString
//            pageNameString = PageName.searchResult
//            setLocalizedVariable()
//            historyCollectionView.reloadData()
//        }
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
    
    

}
