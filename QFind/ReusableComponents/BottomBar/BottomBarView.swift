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
    func qFindMakerPressed()
    func historyButtonPressed()
    
}
class BottomBarView: UIView {
    @IBOutlet var bottomView: BottomBarView!
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
    }
   
    @IBAction func didTapFavorite(_ sender: UIButton) {
        self.bottombarDelegate?.favouriteButtonPressed()
    }
    @IBAction func didTapQFindMarker(_ sender: UIButton) {
        self.bottombarDelegate?.qFindMakerPressed()
    }
    
    @IBAction func didTapHistory(_ sender: UIButton) {
        self.bottombarDelegate?.historyButtonPressed()
    }
}
