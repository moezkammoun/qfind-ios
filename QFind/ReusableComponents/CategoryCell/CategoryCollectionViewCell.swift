//
//  CategoryCollectionViewCell.swift
//  QFind
//
//  Created by Exalture on 15/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import Kingfisher
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleCenterConstraint: NSLayoutConstraint!
    var ipadFontSize =  CGFloat()
    var ipadSubtitleFontSize =  CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            ipadFontSize = 21
            ipadSubtitleFontSize = 14
        }
        else {
            ipadFontSize = 11
            ipadSubtitleFontSize = 10
        }
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.font = UIFont(name: "Lato-Light", size: ipadFontSize)
            subTitleLabel.font = UIFont(name: "Lato-Light", size: ipadSubtitleFontSize)
        }
        else {
            titleLabel.font = UIFont(name: "GESSUniqueLight-Light", size: ipadFontSize)
            subTitleLabel.font = UIFont(name: "GESSUniqueLight-Light", size: ipadSubtitleFontSize)
        }
    }
   
    func setCategoryCellValues(categoryValues : Category){
        
        self.titleLabel.text = categoryValues.categories_name
        if let imageUrl = categoryValues.categories_imge{
        thumbnailView.kf.indicatorType = .activity
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
            
        }
        self.layoutIfNeeded()
    }
    func setSubCategoryCellValues(subCategoryValues : SubCategory){
       
        self.titleLabel.text = subCategoryValues.sub_categories_name
        if let imageUrl = subCategoryValues.sub_categories_imge{
            
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
        }
        
    }
    func setServiceProviderCellValues(serviceProviderValues : ServiceProvider){
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            
            self.titleLabel.text = serviceProviderValues.service_provider_name
            self.subTitleLabel.text = serviceProviderValues.service_provider_location
        }
        else {
            
            self.titleLabel.text = serviceProviderValues.service_provider_name_arabic
            self.subTitleLabel.text = serviceProviderValues.service_provider_location_arabic
        }
        
        if let imageUrl = serviceProviderValues.service_provider_logo{
           
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
        }
        if (thumbnailView.image == nil) {
            thumbnailView.image = UIImage(named: "placeholder")
        }
        
        
    }
    override func prepareForReuse() {
        thumbnailView.image = UIImage(named: "placeholder")
    }
}
