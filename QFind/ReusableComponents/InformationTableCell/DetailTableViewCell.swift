//
//  DetailTableViewCell.swift
//  
//
//  Created by Exalture on 25/01/18.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var forwardImageView: UIImageView!
    
    @IBOutlet weak var informationImageView: UIImageView!
    @IBOutlet weak var informationText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var separatorView: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setInformationCellValues(informationCellDict : [String: String])
    {
       informationText.text = informationCellDict["value"]
        informationImageView.image = UIImage(named: informationCellDict["imageName"]!)
    }

}
