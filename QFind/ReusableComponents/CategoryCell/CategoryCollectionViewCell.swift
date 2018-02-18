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
    
    func setCategoryCellValues(categoryValues : Category)
    {
        
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                titleLabel.font = UIFont(name: "Lato-Light", size: titleLabel.font.pointSize)
            }
            else {
                titleLabel.font = UIFont(name: "GE_SS_Unique_Light", size: titleLabel.font.pointSize)
            }
        
        self.titleLabel.text = categoryValues.categories_name
        if let imageUrl = categoryValues.categories_imge{
        thumbnailView.kf.indicatorType = .activity
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
            
        }
        
    }
    func setSubCategoryCellValues(subCategoryValues : SubCategory){
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.font = UIFont(name: "Lato-Light", size: titleLabel.font.pointSize)
        }
        else {
            titleLabel.font = UIFont(name: "GE_SS_Unique_Light", size: titleLabel.font.pointSize)
        }
        self.titleLabel.text = subCategoryValues.sub_categories_name
        if let imageUrl = subCategoryValues.sub_categories_imge{
            
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
        }
        
    }
    func setServiceProviderCellValues(serviceProviderValues : ServiceProvider){
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            titleLabel.font = UIFont(name: "Lato-Light", size: titleLabel.font.pointSize)
            subTitleLabel.font = UIFont(name: "Lato-Light", size: subTitleLabel.font.pointSize)
        }
        else {
            titleLabel.font = UIFont(name: "GE_SS_Unique_Light", size: titleLabel.font.pointSize)
            subTitleLabel.font = UIFont(name: "GE_SS_Unique_Light", size: subTitleLabel.font.pointSize)
        }
        self.titleLabel.text = serviceProviderValues.service_provider_name
         self.subTitleLabel.text = serviceProviderValues.service_provider_location
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
