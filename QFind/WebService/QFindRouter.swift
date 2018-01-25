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
//    case Compare(String)
//    case GetTopThreeTarget(String, [String: Any])
//    case GetPlayerDetail(String)
//    case Logout(String)
//    case SendMessageToTarget(String, [String: Any])
//    case Strikes(String)
//    case UpdateUserProfile(String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAccessToken:
            return .get
//        case .Compare:
//            return .post
//        case .GetTopThreeTarget:
//            return .post
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
            return "api-clients/oauth-token"
//        case .Compare(let userId):
//            return "/compare/\(userId)"
//        case .GetTopThreeTarget(let userId, _):
//            return "/topthree/\(userId)"
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
//            return URLEncoding.httpBody
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
            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: parameters)
//        case .Compare(_):
//            return mutableURLRequest
//        case .GetTopThreeTarget( _, let parameters):
//            return try! Alamofire.JSONEncoding.default.encode(mutableURLRequest,
//                                                              with: parameters)
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
