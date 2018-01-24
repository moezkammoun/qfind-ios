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
    func setRTLSupportForHistory()
    {
        
        
        
        
    }
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
    }
}
