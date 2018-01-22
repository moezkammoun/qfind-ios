//
//  HistoryViewController.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchBarProtocol,BottomProtocol,predicateTableviewProtocol{


   
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var historySearchBar: SearchBarView!
    
    @IBOutlet weak var historyBottomBar: BottomBarView!
    
    var controller = PredicateSearchViewController()
    var tapGesture = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()

        setRTLSupportForHistory()
        registerCell()
        historySearchBar.searchDelegate = self
        historyBottomBar.bottombarDelegate = self
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
       
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
            
            header.headerLabel.text = "Today"
            
            return header
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
       let heightValue = UIScreen.main.bounds.height/100
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            return CGSize(width: historyCollectionView.frame.width, height: heightValue*8)
        }
        else{
            return CGSize(width: historyCollectionView.frame.width, height: heightValue*8)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func favouriteButtonPressed() {
        
    }
    func qFindMakerPressed() {
        
    }
    func historyButtonPressed() {
        
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
            historySearchBar.searchInnerView.frame.origin.y+historySearchBar.searchInnerView.frame.height+20, width: historySearchBar.searchInnerView.frame.width, height: 510)
        
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

    

}
