//
//  HistoryCollectionViewCell.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var historyThumbnail: UIImageView!
     var favBtnTapAction : (()->())?
    var ipadTitleFontSize =  CGFloat()
    var ipadSubTitleFontSize =  CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            ipadTitleFontSize = 26
            ipadSubTitleFontSize = 15
        }
        else {
            ipadTitleFontSize = 15
            ipadSubTitleFontSize = 12
        }
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.font = UIFont(name: "Lato-Light", size:ipadTitleFontSize)
            subLabel.font = UIFont(name: "Lato-Light", size: ipadSubTitleFontSize)
            
        }
        else {
            titleLabel.font = UIFont(name: "GESSUniqueLight-Light", size: ipadTitleFontSize)
            subLabel.font = UIFont(name: "GESSUniqueLight-Light", size: ipadSubTitleFontSize)
        }
        if #available(iOS 9.0, *) {
            self.titleLabel.textAlignment = .center
            self.subLabel.textAlignment = .center
            
            
        } else {
            // Fallback on earlier versions
        }
    }
   

   
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        favBtnTapAction?()
    }
    func searchResultData(searchResultCellValues: ServiceProvider){
       if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
        self.titleLabel.text = searchResultCellValues.service_provider_name
        self.subLabel.text = searchResultCellValues.service_provider_location
        }
       else {
        self.titleLabel.text = searchResultCellValues.service_provider_name_arabic
        self.subLabel.text = searchResultCellValues.service_provider_location_arabic
        
        }
        self.historyThumbnail.kf.indicatorType = .activity
        self.historyThumbnail.kf.setImage(with: URL(string: searchResultCellValues.service_provider_logo! ))
        if (historyThumbnail.image == nil) {
            historyThumbnail.image = UIImage(named: "placeholder")
        }}
    func setFavoriteData(favoriteId: Int, favoriteName: String, subTitle : String, imgUrl : String){
        
        self.titleLabel.text = favoriteName
        self.subLabel.text = subTitle
       
        self.historyThumbnail.kf.indicatorType = .activity
        self.historyThumbnail.kf.setImage(with: URL(string: imgUrl))
        if (historyThumbnail.image == nil) {
            historyThumbnail.image = UIImage(named: "placeholder")
        }
    }

    func setHistoryData(historyInfo: HistoryEntity){
         if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
           
            self.titleLabel.text = historyInfo.name
            self.subLabel.text = historyInfo.shortdescription
        }
         else{
            
            self.titleLabel.text = historyInfo.arabicname
            self.subLabel.text = historyInfo.arabiclocation
        }
        
        
        self.historyThumbnail.kf.indicatorType = .activity
        if(historyInfo.imgurl != nil){
            self.historyThumbnail.kf.setImage(with: URL(string: historyInfo.imgurl!))
        }
        
        
        if (historyThumbnail.image == nil) {
            historyThumbnail.image = UIImage(named: "placeholder")
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.subLabel.text = ""
        self.historyThumbnail.image = UIImage(named: "placeholder")
        
    }
   
}
