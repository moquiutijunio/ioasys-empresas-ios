//
//  UserDB.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

class UserDB: NSObject, NSCoding {
    
    var id: Int
    var name: String
    var email: String
    
    init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let email = aDecoder.decodeObject(forKey: "email") as? String,
            let name = aDecoder.decodeObject(forKey: "name") as? String {
            
            self.init(id: aDecoder.decodeInteger(forKey: "id"),
                      name: name,
                      email: email)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
    }
}

extension UserDB {
    
    static func map(user: User) -> UserDB? {
        if let id = user.id,
            let name = user.name,
            let email = user.email {
            
            return UserDB(id: id,
                          name: name,
                          email: email)
        }
        
        return nil
    }
}
