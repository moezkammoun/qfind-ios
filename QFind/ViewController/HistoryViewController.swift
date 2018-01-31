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

class HistoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchBarProtocol,BottomProtocol,predicateTableviewProtocol{


   
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var historySearchBar: SearchBarView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var historyLoadingView: LoadingView!
    @IBOutlet weak var historyBottomBar: BottomBarView!
    
    var controller = PredicateSearchViewController()
    
    var pageNameString : PageName?
    
    var predicateSearchKey = String()
    var predicateSearchArray : [PredicateSearch]? = []
    var previousPage : PageName?
    var searchResultArray: [SearchResult]? = []
    var predicateSearchdict : PredicateSearch?
    var favoriteArray : NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUi()
        setRTLSupportForHistory()
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
       setLocalizedVariable()
        
        
        if (pageNameString == PageName.searchResult)
        {
            getSearchResultFromServer(searchPredicateData: predicateSearchdict!)
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
            }
            else{
                
                historySearchBar.searchText.textAlignment = .right
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    func setLocalizedVariable()
    {
        
       
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
        controller.view.removeFromSuperview()
        previousPage = pageNameString
        pageNameString = PageName.searchResult
        setLocalizedVariable()
        getSearchResultFromServer(searchPredicateData: predicateSearchdict!)
        controller.predicateSearchTable.reloadData()
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
            

            controller.view.tag = 1
            
            controller.predicateProtocol = self
            self.controller.view.frame = CGRect(x: self.historySearchBar.searchInnerView.frame.origin.x, y:self.historySearchBar.searchInnerView.frame.origin.y+self.historySearchBar.searchInnerView.frame.height+20, width: self.historySearchBar.searchInnerView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*50))
            addChildViewController(controller)
            view.addSubview((controller.view)!)
            controller.didMove(toParentViewController: self)
            
          
            getPredicateSearchFromServer()
            
          
        }
        else{
            controller.view.removeFromSuperview()
        }
        return true
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
        predicateSearchdict = predicateSearchArray![indexPath.row]
        historySearchBar.searchText.text = predicateSearchdict?.search_name
        controller.view.removeFromSuperview()
        setBottomBarSearchBackground()
        previousPage = pageNameString
        pageNameString = PageName.searchResult
        setLocalizedVariable()
        getSearchResultFromServer(searchPredicateData: predicateSearchdict!)
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
        
        
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            
            Alamofire.request(QFindRouter.getPredicateSearch(["token": tokenString,
                                                              "search_key": predicateSearchKey , "language" :languageKey]))
                .responseObject { (response: DataResponse<PredicateSearchData>) -> Void in
                    switch response.result {
                        
                    case .success(let data):
                       
                        self.predicateSearchArray = data.predicateSearchData
                        self.controller.predicateSearchTable.reloadData()
                        self.controller.view.frame = CGRect(x: self.historySearchBar.searchInnerView.frame.origin.x, y:self.historySearchBar.searchInnerView.frame.origin.y+self.historySearchBar.searchInnerView.frame.height+20, width: self.historySearchBar.searchInnerView.frame.width, height: CGFloat((self.predicateSearchArray?.count)!*50))
                        
                        
                    case .failure(let error):
                        self.historyLoadingView.isHidden = false
                        self.historyLoadingView.stopLoading()
                        self.historyLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }
    func getSearchResultFromServer(searchPredicateData: PredicateSearch)
    {
        historyLoadingView.isHidden = false
        historyLoadingView.showLoading()
      
        if let tokenString = tokenDefault.value(forKey: "accessTokenString")
        {
            Alamofire.request(QFindRouter.getSearchResult(["token": tokenString,
                                                              "search_key": searchPredicateData.search_name! , "language" :languageKey , "search_type": searchPredicateData.search_type!]))
                .responseObject { (response: DataResponse<SearchResultData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        
                        self.searchResultArray = data.searchResultData
                        
                        if ((data.response == "error") || (data.code != "200")){
                            self.historyLoadingView.stopLoading()
                            self.historyLoadingView.noDataView.isHidden = false
                             self.historyCollectionView.reloadData()
                            self.historyLoadingView.showNoDataView()
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
                        self.historyLoadingView.noDataView.isHidden = false
                    }
                    
            }
            
        }
    }

    

}
