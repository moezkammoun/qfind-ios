//
//  HomeViewController.swift
//  QFind
//
//  Created by Exalture on 12/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITextFieldDelegate, KASlideShowDelegate,predicateTableviewProtocol {
    @IBOutlet weak var findByCategoryLabel: UILabel!
    @IBOutlet weak var qfindDayLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var homeLoadingView: LoadingView!
    @IBOutlet weak var slideShow: KASlideShow!
    @IBOutlet weak var orLabel: UILabel!
    
    
    @IBOutlet weak var aspectRationHome: NSLayoutConstraint!
    var bannerArray = NSArray()
    var controller = PredicateSearchViewController()
    var tapGesture = UITapGestureRecognizer()
    // let keyboardSize = 50
    override func viewDidLoad() {
        super.viewDidLoad()

        setUILayout()
        
        setRTLSupport()
        setSlideShow()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setLocalizedStrings()
        print(aspectRationHome.multiplier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func setRTLSupport()
    {
        if #available(iOS 9.0, *) {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .leftToRight {
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
        slideShow.start()
    }
    func setUILayout()
    {
        
        homeLoadingView.isHidden = true
       // homeLoadingView.showLoading()
       // homeLoadingView.showNoDataView()
        controller  = (storyboard?.instantiateViewController(withIdentifier: "predicateId"))! as! PredicateSearchViewController
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
    func setLocalizedStrings()
    {
        self.qfindDayLabel.text = NSLocalizedString("QFIND_OF_THE_DAY", comment: "QFIND_OF_THE_DAY Label in the home page")
       // self.searchText.text = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the home page")
        self.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the home page")
        self.findByCategoryLabel.text = NSLocalizedString("FIND_BY_CATEGORY", comment: "FIND_BY_CATEGORY Label in the home page")
        self.orLabel.text = NSLocalizedString("OR", comment: "OR Label in the home page")
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
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        if (controller.view.tag == 0)
        {
            
            controller.view.tag = 1
            print(controller.view.tag)
            controller.predicateProtocol = self
            addChildViewController(controller)
           
                
                //give height as number of items * height of cell. height is set in PredicateVC
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                controller.view.frame = CGRect(x: searchView.frame.origin.x, y: searchView.frame.origin.y+searchView.frame.height+20, width: searchView.frame.width, height: 255)
                
                }
                else{
                 controller.view.frame = CGRect(x: searchView.frame.origin.x, y: searchView.frame.origin.y+searchView.frame.height+20, width: searchView.frame.width, height: 150)
                
                }
              
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
        cell.precictaeTxet.text = "hi"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int {
        return 3
    }

    @IBAction func didTapFindCategory(_ sender: UIButton) {
        let categoryVC : CategoryViewController = storyboard?.instantiateViewController(withIdentifier: "categoryId") as! CategoryViewController
        
        self.present(categoryVC, animated: false, completion: nil)
    }
    @IBAction func didTapMenu(_ sender: UIButton) {
        let settingsVc : SettingsViewController = storyboard?.instantiateViewController(withIdentifier: "settingsId") as! SettingsViewController
        self.present(settingsVc, animated: false, completion: nil)
        
    }
    
}
