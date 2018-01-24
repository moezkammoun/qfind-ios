//
//  HistoryViewController.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

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
    var tapGesture = UITapGestureRecognizer()
    var pageNameString : PageName?
    override func viewDidLoad() {
        super.viewDidLoad()

        setUi()
        setRTLSupportForHistory()
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
       setLocalizedVariable()
        
        
    }
    func setUi()
    {
        historySearchBar.searchDelegate = self
        historyBottomBar.bottombarDelegate = self
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
        historyLoadingView.isHidden = true
        //historyLoadingView.showLoading()
        //historyLoadingView.showNoDataView()
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
            self.historyLabel.text = NSLocalizedString("Search_results", comment: "Search_results Title Label in the history page")
        default:
            break
        }
        
    }
    func registerCell()
    {
       
        let nib = UINib(nibName: "HistoryOrSearchCell", bundle: nil)
        historyCollectionView?.register(nib, forCellWithReuseIdentifier: "historyCellId")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell : HistoryCollectionViewCell = historyCollectionView.dequeueReusableCell(withReuseIdentifier: "historyCellId", for: indexPath) as! HistoryCollectionViewCell
        if (pageNameString == PageName.favorite)
        {
            cell.favoriteButton.isHidden = false
        }
        else
        {
            cell.favoriteButton.isHidden = true
        }
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
 
        
        
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
    
    func favouriteButtonPressed() {
        
        historyBottomBar.historyView.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.white
         historyBottomBar.favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        if (pageNameString != PageName.favorite)
        {
            pageNameString = PageName.favorite
            setLocalizedVariable()
            historyCollectionView.reloadData()
            //self.view.layoutIfNeeded()
            
        }
        
        
    }
    func homebuttonPressed() {
        historyBottomBar.favoriteview.backgroundColor = UIColor.white
        historyBottomBar.historyView.backgroundColor = UIColor.white
       historyBottomBar.homeView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    func historyButtonPressed() {
        historyBottomBar.favoriteview.backgroundColor = UIColor.white
        historyBottomBar.homeView.backgroundColor = UIColor.white
         historyBottomBar.historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        if (pageNameString != PageName.history)
        {
            pageNameString = PageName.history
            setLocalizedVariable()
            historyCollectionView.reloadData()
            
            
        }
    }
    func searchButtonPressed() {
        print("search")
    }
    func textField(_ textField: UITextField, shouldChangeSearcgCharacters range: NSRange, replacementString string: String) -> Bool {
      
       
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
       
        if ((controller.view.tag == 0)&&(isBackSpace != -92))
        {
            
        controller.view.tag = 1
        print(controller.view.tag)
        controller.predicateProtocol = self
        addChildViewController(controller)
        controller.view.frame = CGRect(x: historySearchBar.searchInnerView.frame.origin.x, y:
            
            //give height as number of items * height of cell. height is set in PredicateVC
            historySearchBar.searchInnerView.frame.origin.y+historySearchBar.searchInnerView.frame.height+20, width: historySearchBar.searchInnerView.frame.width, height: 300)
        
        view.addSubview((controller.view)!)
        controller.didMove(toParentViewController: self)
        
       
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(HistoryViewController.removeSubview))
        self.view.addGestureRecognizer(tapGesture)
        }
        return true
    }

    @objc func removeSubview()
    {
        controller.view.removeFromSuperview()
        controller.view.tag = 0
      
    }
    func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PredicateCell = tableView.dequeueReusableCell(withIdentifier: "predicateCellId") as! PredicateCell!
        cell.precictaeTxet.text = "hospital" 
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int {
        return 6
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    

}
