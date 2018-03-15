//
//  ModelClass.swift
//  QFind
//
//  Created by Exalture on 25/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Foundation


struct TokenData: ResponseObjectSerializable {
    var accessToken: String? = nil

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.accessToken = representation["result"] as? String

        }
    }
}

struct CategoryData: ResponseObjectSerializable {
        var categoryData: [Category]? = []
    
        public init?(response: HTTPURLResponse, representation: AnyObject) {
            if let data = representation["result"] as? [[String: Any]] {
                self.categoryData = Category.collection(response: response, representation: data as AnyObject )
            }
        }
}

struct Category: ResponseObjectSerializable, ResponseCollectionSerializable {
    var categories_id: Int? = nil
    var categories_imge: String? = nil
    var categories_name: String? = nil
    var have_subcategories : Bool? = nil
   

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.categories_id = representation["categories_id"] as? Int
            self.categories_imge = representation["categories_imge"] as? String
            self.categories_name = representation["categories_name"] as? String
            self.have_subcategories = representation["have_subcategories"] as? Bool
            
            
            
        }
    }
}
struct SubCategoryData: ResponseObjectSerializable {
    var subCategoryData: [SubCategory]? = []
    var code:  String? = nil
    var response: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        
        if let representationData = representation as? [String: Any] {
            self.code = representationData["code"] as? String
            self.response = representationData["response"] as? String
        }
        if let data = representation["result"] as? [[String: Any]] {
           
            self.subCategoryData = SubCategory.collection(response: response, representation: data as AnyObject )
        }
        
        
    }
}

struct SubCategory: ResponseObjectSerializable, ResponseCollectionSerializable {
    var sub_categories_id: Int? = nil
    var sub_categories_imge: String? = nil
    var sub_categories_name: String? = nil
    var sub_categories_description: String? = nil
    
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.sub_categories_id = representation["sub_categories_id"] as? Int
            self.sub_categories_imge = representation["sub_categories_imge"] as? String
            self.sub_categories_name = representation["sub_categories_name"] as? String
            self.sub_categories_description = representation["sub_categories_description"] as? String
           
            
        }
       
    }
}

struct PredicateSearchData: ResponseObjectSerializable {
    var predicateSearchData: [PredicateSearch]? = []
    var code:  String? = nil
    var response: String? = nil

    public init?(response: HTTPURLResponse, representation: AnyObject) {

        if let representationData = representation as? [String: Any] {
            self.code = representationData["code"] as? String
            self.response = representationData["response"] as? String
        }
        if let data = representation["result"] as? [[String: Any]] {

            self.predicateSearchData = PredicateSearch.collection(response: response, representation: data as AnyObject )
        }


    }
}

struct PredicateSearch: ResponseObjectSerializable, ResponseCollectionSerializable {
    var item_id: Int? = nil
    var search_name: String? = nil
    var search_type: Int? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.item_id = representation["item_id"] as? Int
            self.search_name = representation["search_name"] as? String
            self.search_type = representation["search_type"] as? Int
        }
        
    }
}
struct SearchResultData: ResponseObjectSerializable {
    var searchResultData: [ServiceProvider]? = []
    var code:  String? = nil
    var response: String? = nil

    public init?(response: HTTPURLResponse, representation: AnyObject) {

        if let representationData = representation as? [String: Any] {
            self.code = representationData["code"] as? String
            self.response = representationData["response"] as? String
        }
        if let data = representation["result"] as? [[String: Any]] {

            self.searchResultData = ServiceProvider.collection(response: response, representation: data as AnyObject )
        }


    }
}

struct QfindOfTheDayData: ResponseObjectSerializable {
    var qfindOfTheDayData: QFindOfTheDay?
    var code:  String? = nil
    var response: String? = nil
   
   
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representationData = representation as? [String: Any] {
            self.code = representationData["code"] as? String
            self.response = representationData["response"] as? String
        }
      
        if let data = representation["result"] {
            self.qfindOfTheDayData = QFindOfTheDay.init(response: response, representation: data as AnyObject)
        }
    }
}

struct QFindOfTheDay: ResponseObjectSerializable {
    var id: Int? = nil
    var image: NSArray? = nil

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            self.id = representation["id"] as? Int
            self.image = representation["image"] as? NSArray
            
            
            
        }
    }
}

struct ServiceProviderData: ResponseObjectSerializable {
    var serviceProviderData: [ServiceProvider]? = []
    var code:  String? = nil
    var response: String? = nil
    
    public init?(response: HTTPURLResponse, representation: AnyObject) {
        
        if let representationData = representation as? [String: Any] {
            self.code = representationData["code"] as? String
            self.response = representationData["response"] as? String
        }
        if let data = representation["result"] as? [[String: Any]] {
            
            self.serviceProviderData = ServiceProvider.collection(response: response, representation: data as AnyObject )
        }
        
        
    }
}

struct ServiceProvider: ResponseObjectSerializable, ResponseCollectionSerializable {
    var service_provider_name: String? = nil
   
    var service_provider_address: String? = nil
    var service_provider_location: String? = nil
    var service_provider_category: String? = nil
    var service_provider_logo: String? = nil
    var id: Int? = nil
    var service_provider_mail_account: String? = nil
    var service_provider_website: String? = nil
    var service_provider_mobile_number: String? = nil
    var service_provider_map_location: String? = nil
    var service_provider_opening_time: String? = nil
    var service_provider_opening_time_arabic: String? = nil
    var service_provider_closing_time: String? = nil
    var service_provider_closing_time_arabic: String? = nil
    var service_provider_opening_title: String? = nil
    var service_provider_opening_title_arabic: String? = nil
    var service_provider_closing_title_arabic: String? = nil
    var service_provider_closing_title: String? = nil
    var service_provider_facebook_page: String? = nil
    var service_provider_linkdin_page: String? = nil
    var service_provider_instagram_page: String? = nil
    var service_provider_twitter_page: String? = nil
    var service_provider_snapchat_page: String? = nil
    var service_provider_googleplus_page: String? = nil
    var created_on: String? = nil
    var service_provider_name_arabic: String? = nil
    var service_provider_address_arabic: String? = nil
    var service_provider_location_arabic: String? = nil
    var service_provider_category_arabic: String? = nil
    var image : NSArray? = nil

    public init?(response: HTTPURLResponse, representation: AnyObject) {
        if let representation = representation as? [String: Any] {
            
            self.service_provider_name = representation["service_provider_name"] as? String
             self.service_provider_address = representation["service_provider_address"] as? String
            self.service_provider_location = representation["service_provider_location"] as? String
            self.service_provider_category = representation["service_provider_category"] as? String
            self.service_provider_logo = representation["service_provider_logo"] as? String
            self.id = representation["id"] as? Int
            self.service_provider_mail_account = representation["service_provider_mail_account"] as? String
            self.service_provider_website = representation["service_provider_website"] as? String
            self.service_provider_mobile_number = representation["service_provider_mobile_number"] as? String
            self.service_provider_map_location = representation["service_provider_map_location"] as? String
            self.service_provider_opening_time = representation["service_provider_opening_time"] as? String
            self.service_provider_opening_time_arabic = representation["service_provider_opening_time_arabic"] as? String
            self.service_provider_closing_time = representation["service_provider_closing_time"] as? String
            self.service_provider_closing_time_arabic = representation["service_provider_closing_time_arabic"] as? String
            self.service_provider_opening_title = representation["service_provider_opening_title"] as? String
            
            
            
            self.service_provider_opening_title_arabic = representation["service_provider_opening_title_arabic"] as? String
            self.service_provider_closing_title = representation["service_provider_closing_title"] as? String
            self.service_provider_closing_title_arabic = representation["service_provider_closing_title_arabic"] as? String
            self.service_provider_facebook_page = representation["service_provider_facebook_page"] as? String
            self.service_provider_linkdin_page = representation["service_provider_linkdin_page"] as? String
            self.service_provider_instagram_page = representation["service_provider_instagram_page"] as? String
            self.service_provider_twitter_page = representation["service_provider_twitter_page"] as? String
            self.service_provider_snapchat_page = representation["service_provider_snapchat_page"] as? String
            self.service_provider_googleplus_page = representation["service_provider_googleplus_page"] as? String
            self.created_on = representation["created_on"] as? String
            self.service_provider_name_arabic = representation["service_provider_name_arabic"] as? String
            self.service_provider_address_arabic = representation["service_provider_address_arabic"] as? String
            self.service_provider_location_arabic = representation["service_provider_location_arabic"] as? String
            self.service_provider_category_arabic = representation["service_provider_category_arabic"] as? String
            self.image = representation["image"] as? NSArray
        }
        
    }
}
