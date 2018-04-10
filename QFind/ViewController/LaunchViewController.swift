//
//  LaunchViewController.swift
//  QFind
//
//  Created by Exalture on 23/03/18.
//  Copyright © 2018 QFind. All rights reserved.
//
import  Alamofire
import UIKit

class LaunchViewController: UIViewController {
    var animationViews  = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAnimation()
    }
    func setAnimation()
    {
        
        var screenWidth = CGFloat()
        var screenHeight = CGFloat()
        screenWidth = self.view.frame.width*0.56
        screenHeight = self.view.frame.height*0.30
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            screenWidth = self.view.frame.width*0.5
            screenHeight = self.view.frame.height*0.35
        }
        let imgFrame : CGRect = CGRect(x: (self.view.frame.width-screenWidth)/2, y: (self.view.frame.height-screenHeight)/2, width: screenWidth, height: screenHeight)
        print(self.view.frame)
        animationViews  = UIImageView(frame: imgFrame)
        let animationImages:[UIImage] = [UIImage(named: "launchIImage1")!,UIImage(named: "launchIImage2")!, UIImage(named: "launchIImage3")!, UIImage(named: "launchIImage4")!,UIImage(named: "launchIImage5")!,UIImage(named: "launchIImage6")!,UIImage(named: "launchIImage7")!,UIImage(named: "launchIImage8")!,UIImage(named: "launchIImage9")!,UIImage(named: "launchIImage10")!,UIImage(named: "launchIImage11")!,UIImage(named: "launchIImage12")!,UIImage(named: "launchIImage13")!,UIImage(named: "launchIImage14")!,UIImage(named: "launchIImage15")!,UIImage(named: "launchIImage16")!]
        animationViews.image = UIImage(named: "launchIImage1")!
        animationViews.animationImages = animationImages
        animationViews.animationDuration = 1.8
        animationViews.animationRepeatCount = 1
        
        animationViews.startAnimating()
       
        self.perform(#selector(dismissView), with: nil, afterDelay: 3)

        self.view.addSubview(animationViews)
        animationViews.image = UIImage(named: "launchIImage16")!
    }
    @objc func dismissView()
    {
        
        if(deepLinkId == nil){
        if (tokenDefault.value(forKey: "accessTokenString") == nil)
        {
            Alamofire.request(QFindRouter.getAccessToken(["clientid": "DEB47D9B-61DD-25A6-CB6F-46F310F78130",
                                                          "clientsecret": "7B446C1F-94F4-967D-25BF-45A63DBC2BAF"]))
                .responseObject { (response: DataResponse<TokenData>) -> Void in
                    switch response.result {
                    case .success(let data):
                        if let token = data.accessToken{
                            tokenDefault.set(token, forKey: "accessTokenString")
                            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homeViewController
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }
        else {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
        }
        else{
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "informationId") as! DetailViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = homeViewController
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    

   

}
