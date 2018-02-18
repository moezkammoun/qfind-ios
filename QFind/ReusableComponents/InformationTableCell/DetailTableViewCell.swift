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
        func setFontForInformationPage() {
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                informationText.font = UIFont(name: "Lato-Bold", size: informationText.font.pointSize)
            }
            else {
                informationText.font = UIFont(name: "GE_SS_Unique_Bold", size: informationText.font.pointSize)
            }
        }
        informationImageView.image = UIImage(named: informationCellDict["imageName"]!)
        if (informationCellDict["key"] == "service_provider_website"){
            
            let websiteFullUrl = informationCellDict["value"]
            let websiteShortUrl = websiteFullUrl?.replacingOccurrences(of: "https://", with: "", options: NSString.CompareOptions.literal, range:nil)
            informationText.text = websiteShortUrl
        }
        else{
             informationText.text = informationCellDict["value"]
        }
        
        
      
    }

}
