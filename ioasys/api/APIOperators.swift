//
//  APIOperators.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Moya
import RxSwift

struct SessionCredentials {
    
    var accessToken: String
    var client: String
    var uid: String
}

extension Data {
    var asJSON: Result<[String: Any], NSError> {
        do {
            guard let JSONDict = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
                return Result.failure(APIClient.error(description: NSLocalizedString("generic.error", comment: "")))
            }
            
            return Result.success(JSONDict)
            
        } catch let error as NSError {
            return Result.failure(error)
        }
    }
}

extension Moya.Response {
    
    var sessionCredentails: SessionCredentials? {
        
        if let httpURLResponse = response,
            let accessToken = httpURLResponse.allHeaderFields["access-token"] as? String,
            let client = httpURLResponse.allHeaderFields["client"] as? String,
            let uid = httpURLResponse.allHeaderFields["uid"] as? String {
            return SessionCredentials(accessToken: accessToken, client: client, uid: uid)
        }
        
        return nil
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    func processResponse() -> Single<Moya.Response> {
        return flatMap({ (response) -> Single<Moya.Response> in

            if response.statusCode >= 200 && response.statusCode <= 299 {
                return Single.just(response)

            } else {
                if response.statusCode == 401 {
                    SessionManager.shared.expireSession()
                }

                switch response.data.asJSON {
                case .success(let json):

                    if let error = Error.map(json: json) {
                        return Single.error(APIClient.error(description: error.localizedDescription, code: response.statusCode))

                    } else {
                        return Single.error(APIClient.error(description: NSLocalizedString("generic.error", comment: ""), code: response.statusCode))
                    }

                case .failure(let error):
                    return Single.error(error)
                }
            }
        })
    }

    func createSession() -> Single<Moya.Response> {
        return flatMap { (response) -> Single<Moya.Response> in

            if let user = User.map(data: response.data),
                let userDB = UserDB.map(user: user),
                let sessionCredentails = response.sessionCredentails {

                do {
                    try SessionManager.shared.createUserSession(uid: sessionCredentails.uid,
                                                                client: sessionCredentails.client,
                                                                accessToken: sessionCredentails.accessToken,
                                                                currentUser: userDB)
                    return Single.just(response)

                } catch(let error) {
                    return Single.error(error)
                }

            } else {
                return Single.error(APIClient.error(description: NSLocalizedString("generic.error", comment: ""), code: response.statusCode))
            }
        }
    }
}
