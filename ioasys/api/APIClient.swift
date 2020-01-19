//
//  APIClient.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya
import RxSwift

struct APIClientHost {
    
    static let apiVersion = "v1/"
    static let baseURL = URL(string: "https://empresas.ioasys.com.br/api/\(apiVersion)")!
}

protocol APIClientProtocol {
    
    func loginWith(email: String, password: String) -> Single<Void>
}

class APIClient: APIClientProtocol {
    
    func loginWith(email: String, password: String) -> Single<Void> {
        return provider.rx
            .request(.login(email: email, password: password))
            .processResponse()
            .createSession()
            .map { _ in}
    }
}

extension APIClient {
    
    static let errorDomain = "APIClient"
    
    static func error(description: String, code: Int = 0) -> NSError {
        
        return NSError(domain: errorDomain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: description])
    }
}
