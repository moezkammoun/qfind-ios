//
//  HistoryEntity.swift
//  QFind
//
//  Created by Exalture on 11/02/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import CoreData
import Foundation

class HistoryEntity: NSManagedObject {
    @NSManaged var address: String?
    @NSManaged var arabicaddress: String?
    @NSManaged var category: String?
    @NSManaged var arabiccategory: String?
    @NSManaged var email: String?
    @NSManaged var facebookpage: String?
    @NSManaged var id: Int32
    @NSManaged var imgurl: String?
    @NSManaged var instagrampage: String?
    @NSManaged var maplocation: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var arabicname: String?
    @NSManaged var openingtime: String?
    @NSManaged var openingtitle: String?
    @NSManaged var openingtime_arabic: String?
    @NSManaged var openingtitle_arabic: String?
    @NSManaged var closingtime: String?
    @NSManaged var closingtitle: String?
    @NSManaged var closingtime_arabic: String?
    @NSManaged var closingtitle_arabic: String?
    @NSManaged var shortdescription: String?
    @NSManaged var arabiclocation: String?
    @NSManaged var snapchatpage: String?
    @NSManaged var twitterpage: String?
    @NSManaged var website: String?
    @NSManaged var date_history: Date?
}
