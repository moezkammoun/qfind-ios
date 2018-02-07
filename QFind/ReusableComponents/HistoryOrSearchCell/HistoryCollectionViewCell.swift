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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 9.0, *) {
            let attribute = self.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            
            
            self.titleLabel.textAlignment = .center
            self.subLabel.textAlignment = .center
            
        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
    }
    func searchResultData(searchResultCellValues: ServiceProvider){
        self.titleLabel.text = searchResultCellValues.service_provider_name
        self.subLabel.text = searchResultCellValues.service_provider_location
        let imageArray = searchResultCellValues.image
        self.historyThumbnail.kf.indicatorType = .activity
        self.historyThumbnail.kf.setImage(with: URL(string: imageArray![0] as! String))
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.subLabel.text = ""
        self.historyThumbnail.image = nil
        
    }
}
