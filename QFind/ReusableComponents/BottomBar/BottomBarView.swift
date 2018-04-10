//
//  BottomBarView.swift
//  QFind
//
//  Created by Exalture on 15/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit
protocol BottomProtocol
{
    func favouriteButtonPressed()
    func homebuttonPressed()
    func historyButtonPressed()
    
}
class BottomBarView: UIView {
    @IBOutlet var bottomView: BottomBarView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var favoriteview: UIView!
    @IBOutlet weak var homeView: UIView!
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var favorireCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var historyCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var historyView: UIView!
    var bottombarDelegate : BottomProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("BottomBar", owner: self, options: nil)
        addSubview(bottomView)
        bottomView.frame = self.bounds
        bottomView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        if UIDevice().userInterfaceIdiom == .phone {
            if (UIScreen.main.nativeBounds.height == 2436) {
                favorireCenterYConstraint.constant = -12
                homeCenterYConstraint.constant = -12
                historyCenterYConstraint.constant = -12
            }
            else{
                favorireCenterYConstraint.constant = 0
                homeCenterYConstraint.constant = 0
                historyCenterYConstraint.constant = 0
            }
        }
        else{
           favorireCenterYConstraint.constant = 0
            homeCenterYConstraint.constant = 0
            historyCenterYConstraint.constant = 0
        }
        homeImage.layer.minificationFilter = kCAFilterTrilinear
        homeImage.layer.minificationFilterBias = 0.1
    }
   
    @IBAction func didTapFavorite(_ sender: UIButton) {
        self.bottombarDelegate?.favouriteButtonPressed()
        favoriteview.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
    }
   
    
    @IBAction func didTapHome(_ sender: UIButton) {
         self.bottombarDelegate?.homebuttonPressed()
        homeView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
    }
    @IBAction func didTapHistory(_ sender: UIButton) {
        self.bottombarDelegate?.historyButtonPressed()
        historyView.backgroundColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    }
}
