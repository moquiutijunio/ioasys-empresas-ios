//
//  APITarget.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya

let provider = MoyaProvider<APITarget>( endpointClosure: { (target) -> Endpoint in
    
    return Endpoint(url: "\(target.baseURL)\(target.path)",
        sampleResponseClosure: {.networkResponse(200, target.sampleData)},
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    
}, plugins: [NetworkLoggerPlugin(verbose: true)])

enum APITarget {
    
    case login(email: String, password: String)
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        return APIClientHost.baseURL as URL
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/auth/sign_in"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    
    var headers: [String: String]? {
        var httpHeaderFields: [String: String] = [
            "Content-Type": "application/json"
        ]
        
        if let session = SessionManager.shared.retrieveUserSession() {
            httpHeaderFields["uid"] = session.uid
            httpHeaderFields["client"] = session.client
            httpHeaderFields["access-token"] = session.accessToken
        }
        
        return httpHeaderFields
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .login(let params):
            let bodyParams: [String: Any] = [
                "email": params.email,
                "password": params.password
            ]
            
            return Task.requestParameters(parameters: bodyParams, encoding: JSONEncoding())
        }
    }
}
