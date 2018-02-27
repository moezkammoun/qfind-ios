//
//  LoadingView.swift
//  QFind
//
//  Created by Exalture on 22/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var xibView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noDataView: UIView!
    var isNoDataDisplayed : Bool = false
    override func awakeFromNib()
    {
        loadView()
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    fileprivate func loadView()
    {
        if xibView == nil
        {
            xibView = Bundle.main.loadNibNamed("LoadingViewXib", owner: self, options: nil)![0] as! UIView
            xibView.frame = self.bounds
            xibView.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundColor = UIColor(red: 233, green: 233, blue: 233, alpha: 1)
            self.addSubview(xibView)
            let constrants = wk_getLayouts()
            self.addConstraints(constrants.0)
            self.addConstraints(constrants.1)
        }
        //self.userInteractionEnabled = false
        
    }
    fileprivate func wk_getLayouts()->(Array<NSLayoutConstraint>,Array<NSLayoutConstraint>)
    {
        let hConstaints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view" : xibView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view" : xibView])
        return (hConstaints,vConstraints)
    }
    
    func showLoading()
    {
        activityIndicator.color = UIColor(red: 13/255, green: 50/255, blue: 68/255, alpha: 1)
       // self.isHidden = false
        self.noDataLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
       // self.isHidden = false
        
    }
    
    func stopLoading()
    {
        self.isNoDataDisplayed = true
        activityIndicator.stopAnimating()
      //  self.isHidden = true
        
    }
    
    func showNoDataView(){
        self.isNoDataDisplayed = true
        //self.isHidden = false
        let noDataText = NSLocalizedString("No_result_found", comment: "No result message")
        self.noDataLabel.text = noDataText
        self.noDataView.isHidden = false
        self.noDataView.backgroundColor = UIColor(red: 243/255, green: 241/255, blue: 238/255, alpha: 1)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.noDataLabel.isHidden = false
    }
    func hideNoDataView(){
        self.isNoDataDisplayed = false
        //self.isHidden = true
        self.noDataView.isHidden = true
        //self.activityIndicatorControl.stopAnimating()
        self.noDataLabel.isHidden = true
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
