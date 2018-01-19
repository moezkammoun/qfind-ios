//
//  HistoryViewController.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SearchBarProtocol,BottomProtocol{


   
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var historySearchBar: SearchBarView!
    
    @IBOutlet weak var historyBottomBar: BottomBarView!
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        historySearchBar.searchDelegate = self
        historyBottomBar.bottombarDelegate = self
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

}
