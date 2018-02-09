//
//  HistoryCollectionViewCell.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import CoreData
import UIKit
protocol HistoryCellProtocol
{
    func favouriteStarPressed()
}
class HistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var historyThumbnail: UIImageView!
    var historyDelegate : HistoryCellProtocol?
    var favDict : NSManagedObject?
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
        deleteFavoriteFromCoredata()
        
        historyDelegate?.favouriteStarPressed()
    }
    func searchResultData(searchResultCellValues: ServiceProvider){
        self.titleLabel.text = searchResultCellValues.service_provider_name
        self.subLabel.text = searchResultCellValues.service_provider_location
        self.historyThumbnail.kf.indicatorType = .activity
        self.historyThumbnail.kf.setImage(with: URL(string: searchResultCellValues.service_provider_logo! ))
    }
    func setFavoriteData(favoriteId: Int, favoriteName: String, subTitle : String, imgUrl : String){
        self.titleLabel.text = favoriteName
        self.subLabel.text = subTitle
       
        self.historyThumbnail.kf.indicatorType = .activity
        self.historyThumbnail.kf.setImage(with: URL(string: imgUrl))
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.subLabel.text = ""
        self.historyThumbnail.image = nil
        
    }
    func deleteFavoriteFromCoredata()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        var managedContext : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            managedContext =
                appDelegate.persistentContainer.viewContext
            
        } else {
            // Fallback on earlier versions
            managedContext = appDelegate.managedObjectContext
            
        }
        managedContext?.delete(favDict!)
        do {
            try managedContext?.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
