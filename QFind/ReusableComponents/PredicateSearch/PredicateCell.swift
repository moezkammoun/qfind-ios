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
        predicateText.text = cellValues.search_name
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        predicateText.text = ""
    }

}
