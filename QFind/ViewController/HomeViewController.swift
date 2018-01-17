//
//  HomeViewController.swift
//  QFind
//
//  Created by Exalture on 12/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate, KASlideShowDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var slideShow: KASlideShow!
    var bannerArray = NSArray()
    // let keyboardSize = 50
    override func viewDidLoad() {
        super.viewDidLoad()

        setUILayout()
        setSlideShow()
        //setRTLSupport()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setRTLSupport()
    {
        searchText.textAlignment = .right
    }
    func setSlideShow()
    {
        
        //KASlideshow
        slideShow.delegate = self
        slideShow.delay = 1 // Delay between transitions
        slideShow.transitionDuration = 1.5 // Transition duration
        slideShow.transitionType = KASlideShowTransitionType.slide // Choose a transition type (fade or slide)
        slideShow.imagesContentMode = .scaleAspectFill // Choose a content mode for images to display
        slideShow.addImages(fromResources:bannerArray as! [Any]) // Add images from resources
        slideShow.add(KASlideShowGestureType.swipe) // Gesture to go previous/next directly on the image (Tap or Swipe)
        /*************Set this value when langue is changed in settings*****/
        slideShow.arabic = false
        slideShow.start()
    }
    func setUILayout()
    {
        bannerArray = ["banner", "findByCategoryBG", "car_service","cloth_stores"]
        searchView.layer.cornerRadius = 7.5
        searchView.layer.borderWidth = 2.0
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        searchText.delegate = self
        pageControl.numberOfPages = bannerArray.count
        pageControl.currentPage = Int(slideShow.currentIndex)
        pageControl.addTarget(self, action: #selector(HomeViewController.pageChanged), for: .valueChanged)

        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
       
        
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 200
            }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      
           
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 200
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
    
    

    @IBAction func didTapFindCategory(_ sender: UIButton) {
    }
    @IBAction func didTapMenu(_ sender: UIButton) {
    }
    
}
