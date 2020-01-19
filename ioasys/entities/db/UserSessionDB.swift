//
//  UserSessionDB.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

class UserSessionDB: NSObject, NSCoding {
    
    private(set) var uid: String
    private(set) var client: String
    private(set) var accessToken: String
    private(set) var currentUser: UserDB
    
    init(uid: String, client: String, accessToken: String, currentUser: UserDB) {
        self.uid = uid
        self.client = client
        self.accessToken = accessToken
        self.currentUser = currentUser
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: "uid") as? String,
            let client = aDecoder.decodeObject(forKey: "client") as? String,
            let accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String,
            let currentUser = aDecoder.decodeObject(forKey: "currentUser") as? UserDB else {
                return nil
        }
        
        self.init(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(client, forKey: "client")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(currentUser, forKey: "currentUser")
    }
}
