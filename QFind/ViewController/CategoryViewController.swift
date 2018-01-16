//
//  CategoryViewController.swift
//  QFind
//
//  Created by Exalture on 15/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,KASlideShowDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BottomProtocol,SearchBarProtocol {
  let bottomBar = BottomBarView()
    let searchBar = SearchBarView()
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var slideShow: KASlideShow!
    
     var bannerArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        setImageSlideShow()
        registerNib()
        
      
        bottomBar.bottombarDelegate = self
        searchBar.searchDelegate = self
        

        
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
        slideShow.delay = 2 // Delay between transitions
        slideShow.transitionDuration = 1.5 // Transition duration
        slideShow.transitionType = KASlideShowTransitionType.slide // Choose a transition type (fade or slide)
        slideShow.imagesContentMode = .scaleAspectFill // Choose a content mode for images to display
        slideShow.addImages(fromResources:bannerArray as! [Any]) // Add images from resources
        slideShow.add(KASlideShowGestureType.swipe) // Gesture to go previous/next directly on the image (Tap or Swipe)
        /*************Set this value when langue is changed in settings*****/
        slideShow.arabic = false
        slideShow.start()
    }
    //KASlideShow delegate
    
    func kaSlideShowWillShowNext(_ slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowNext")
        
        
    }
    
    func kaSlideShowWillShowPrevious(_ slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowPrevious")
    }
    
    func kaSlideShowDidShowNext(_ slideshow: KASlideShow) {
        NSLog("kaSlideShowDidNext")
        print(Int(slideShow.currentIndex))
        
        
        pageControl.currentPage = Int(slideShow.currentIndex)
        
        print(pageControl.currentPage)
        print(pageControl.numberOfPages)
    }
    
    func kaSlideShowDidShowPrevious(_ slideshow: KASlideShow) {
        NSLog("kaSlideShowDidPrevious")
        pageControl.currentPage = Int(slideShow.currentIndex)
    }
    @objc func pageChanged() {
        print("pageChanged")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CategoryCollectionViewCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellId", for: indexPath) as! CategoryCollectionViewCell
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightValue = UIScreen.main.bounds.height/100
        if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                return CGSize(width: categoryCollectionView.frame.width/2-10, height: heightValue*8)
        }
        else{
            return CGSize(width: categoryCollectionView.frame.width/2-6.5, height: heightValue*6)
        }
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

  

}
