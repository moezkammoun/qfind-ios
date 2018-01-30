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
//    case GetPlayerDetail(String)
//    case Logout(String)
//    case SendMessageToTarget(String, [String: Any])
//    case Strikes(String)
//    case UpdateUserProfile(String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAccessToken:
            return .get
        case .getCategory:
            return .get
        case .getSubCategory:
            return .get
//        case .GetPlayerDetail:
//            return .get
//        case .Logout:
//            return .delete
//        case .SendMessageToTarget:
//            return .post
//        case .Strikes:
//            return .get
//        case .UpdateUserProfile:
//            return .put
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
//        case .GetPlayerDetail(let userId):
//            return "/user/\(userId)"
//        case .Logout(let userId):
//            return "/logout/\(userId)"
//        case .SendMessageToTarget(let userId, _):
//            return "/message/\(userId)"
//        case .Strikes(let userId):
//            return "/strikes/\(userId)"
//        case .UpdateUserProfile(let userId):
//            return "/user/\(userId)"
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
//        case .GetPlayerDetail( _):
//            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
//        case .Logout( _):
//            return mutableURLRequest
//        case .SendMessageToTarget( _, let parameters):
//            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest,
//                                                              with: parameters)
//        case .Strikes( _):
//            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest)
//        case .UpdateUserProfile( _):
//            return mutableURLRequest
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        return request
    }
}
