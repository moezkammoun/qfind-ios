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
        
        self.titleLabel.text = categoryValues.categories_name
        if let imageUrl = categoryValues.categories_imge{
        thumbnailView.kf.indicatorType = .activity
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
            
        }
        
    }
    func setSubCategoryCellValues(subCategoryValues : SubCategory)
    {
        
        self.titleLabel.text = subCategoryValues.sub_categories_name
       // self.subTitleLabel.text = subCategoryValues.sub_categories_description
        if let imageUrl = subCategoryValues.sub_categories_imge{
            
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
        }
        
    }
    func setServiceProviderCellValues(serviceProviderValues : ServiceProvider)
    {
        
        self.titleLabel.text = serviceProviderValues.service_provider_name
         self.subTitleLabel.text = serviceProviderValues.service_provider_location
        if let imageUrl = serviceProviderValues.service_provider_logo{
            
            thumbnailView.kf.setImage(with: URL(string: imageUrl))
        }
        
    }
    
}
