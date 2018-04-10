//
//  Router.swift
//  QFind
//
//  Created by Exalture on 25/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Alamofire
import Foundation

enum QFindRouter: URLRequestConvertible {
    case getAccessToken([String: Any])
    case getCategory([String :Any])
    case getSubCategory([String :Any])
    case getPredicateSearch([String: Any])
    case getSearchResult([String: Any])
    case getQFindOfTheDay([String: Any])
    case getServiceProvider([String: Any])
    case getServiceProviderData([String: Any])

    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAccessToken:
            return .get
        case .getCategory:
            return .get
        case .getSubCategory:
            return .get
        case .getPredicateSearch:
            return .get
        case .getSearchResult:
            return .get
        case .getQFindOfTheDay:
            return .get
        case .getServiceProvider:
            return .get
        case .getServiceProviderData:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAccessToken( _):
           // return "api-clients/oauth-token?clientid=80581B4C-C060-D166-7893-A4424C15A63D&clientsecret=0488AFF2-BCE0-BC87-F614-10F055107FEB"
            return "api-clients/oauth-token"
            
        case .getCategory( _):
            return "api/get-category"
        case .getSubCategory( _):
            return "api/get-sub-category"
        case .getPredicateSearch( _):
            return "api/search"
        case .getSearchResult( _):
            return "api/search-result"
        case .getQFindOfTheDay( _):
           return "api/q-find"
        case .getServiceProvider( _):
            return "api/get-service-provider"
        case .getServiceProviderData( _):
            return "api/get-service-provider-inner"

        }
    }
    
//    var parameterEncoding: ParameterEncoding {
//        switch self {
//        case .getAccessToken:
//            return URLEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
    
    // MARK:- URLRequestConvertible
    public var request: URLRequest {
        let URL = NSURL(string: Config.baseURL)!
        var mutableURLRequest = URLRequest(url: URL.appendingPathComponent(path)!)
        mutableURLRequest.httpMethod = method.rawValue
//        if let accessToken = UserDefaults.standard.value(forKey: "accessToken")
//            as? String {
//            mutableURLRequest.setValue("Bearer " + accessToken,
//                                       forHTTPHeaderField: "Authorization")
//        }
        switch self {
        case .getAccessToken(let parameters):
          
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .getCategory(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .getSubCategory(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest,with: parameters)
        case .getPredicateSearch(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest,with: parameters)
        case .getSearchResult(let parameters):
           return try! Alamofire.URLEncoding.default.encode(mutableURLRequest,with: parameters)
        case .getQFindOfTheDay( let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest,
                                                              with: parameters)
        case .getServiceProvider(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)
        case .getServiceProviderData(let parameters):
            return try! Alamofire.URLEncoding.default.encode(mutableURLRequest, with: parameters)

        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        return request
    }
}
