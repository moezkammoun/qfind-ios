//
//  PredicateCell.swift
//  QFind
//
//  Created by Exalture on 19/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit

class PredicateCell: UITableViewCell {
  
    
    @IBOutlet weak var predicateText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setPredicateCellValues(cellValues : PredicateSearch){
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            predicateText.font = UIFont(name: "Lato-Regular", size: predicateText.font.pointSize)
        }
        else {
            predicateText.font = UIFont(name: "GE_SS_Unique_Light", size: predicateText.font.pointSize)
        }
        predicateText.text = cellValues.search_name
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        predicateText.text = ""
    }

}
