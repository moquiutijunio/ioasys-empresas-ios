//
//  User.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct User: Decodable {

    var id: Int?
    var name: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case investor
        case id
        case name = "investor_name"
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let investor = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .investor)
        self.id = try investor.decode(Int.self, forKey: .id)
        self.name = try investor.decode(String.self, forKey: .name)
        self.email = try investor.decode(String.self, forKey: .email)
    }
}

extension User {
    
    static func map(data: Data) -> User? {
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        
        return user
    }
}
