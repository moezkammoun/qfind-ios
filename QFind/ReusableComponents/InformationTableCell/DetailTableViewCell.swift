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
        informationImageView.image = UIImage(named: informationCellDict["imageName"]!)
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                informationText.font = UIFont(name: "Lato-Bold", size: informationText.font.pointSize)
            }
            else {
                informationText.font = UIFont(name: "GESSUniqueBold-Bold", size: informationText.font.pointSize)
            }
        
        
        if (informationCellDict["key"] == "service_provider_website"){
            
            let websiteFullUrl = informationCellDict["value"]
            let websiteShortUrl = websiteFullUrl?.replacingOccurrences(of: "https://", with: "", options: NSString.CompareOptions.literal, range:nil)
            informationText.text = websiteShortUrl
        }
        else{
            informationText.text = informationCellDict["value"]
        }
        if(informationCellDict["key"] == "service_provider_mobile_number"){
            informationText.font = UIFont(name: "Lato-Bold", size: informationText.font.pointSize)
        }
        if (informationCellDict["key"] == "service_provider_opening_time") {
            let closedLabel = NSLocalizedString("Closed", comment: "closed label in timepopup")
           if ((LocalizationLanguage.currentAppleLanguage()) == "ar") {
            if (( informationCellDict["value"]?.caseInsensitiveCompare(closedLabel)) == ComparisonResult.orderedSame) {
                informationText.text = informationCellDict["value"]
            }
            else {
                let fullArray = informationCellDict["value"]?.components(separatedBy: " ")
                let timeMutableString1 = NSMutableAttributedString(
                    string:fullArray![0],
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "Lato-Bold",
                        size: informationText.font.pointSize)!])
                let timeMutableString2 = NSMutableAttributedString(
                    string:  " ",
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "Lato-Bold",
                        size: informationText.font.pointSize)!])
                let timeMutableString3 = NSMutableAttributedString(
                    string:  fullArray![1],
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "GESSUniqueBold-Bold",
                        size: informationText.font.pointSize)!])
                let timeMutableString4 = NSMutableAttributedString(
                    string:  fullArray![2],
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "Lato-Bold",
                        size: informationText.font.pointSize)!])
                
                let timeMutableString5 = NSMutableAttributedString(
                    string:fullArray![3],
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "Lato-Bold",
                        size: informationText.font.pointSize)!])
                let timeMutableString6 = NSMutableAttributedString(
                    string:  fullArray![4],
                    attributes: [NSAttributedStringKey.font:UIFont(
                        name: "GESSUniqueBold-Bold",
                        size: informationText.font.pointSize)!])
                timeMutableString1.append(timeMutableString2)
                timeMutableString1.append(timeMutableString3)
                timeMutableString1.append(timeMutableString2)
                timeMutableString1.append(timeMutableString4)
                timeMutableString1.append(timeMutableString2)
                timeMutableString1.append(timeMutableString5)
                timeMutableString1.append(timeMutableString2)
                timeMutableString1.append(timeMutableString6)
                informationText.attributedText = timeMutableString1
            
            }
            
           }

        }
        
        
      
    }

}
