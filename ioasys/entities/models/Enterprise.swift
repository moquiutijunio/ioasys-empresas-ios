//
//  Enterprise.swift
//  ioasys
//
//  Created by Junio Moquiuti on 20/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct Enterprise: Decodable {
    
    var id: Int
    var name: String
    var description: String?
    var typeName: String?
    var country: String?
    var photo: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "enterprise_name"
        case description
        case country
        case photo
        case enterpriseType = "enterprise_type"
        case typeName = "enterprise_type_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try? container.decode(String.self, forKey: .description)
        self.country = try? container.decode(String.self, forKey: .country)
        let enterpriseType = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .enterpriseType)
        self.typeName = try? enterpriseType?.decode(String.self, forKey: .typeName)
        self.photo = try? container.decode(URL.self, forKey: .photo)
    }
}

extension Enterprise {
    
    static func map(json: Any) -> Enterprise? {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let enterprise = try? JSONDecoder().decode(Enterprise.self, from: data) else {
                return nil
        }
        
        return enterprise
    }
    
    static func map(data: Data) -> Enterprise? {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let enterpriseJson = jsonObj.value(forKey: "enterprises") as? NSArray else {
            return nil
        }
        
        return map(json: enterpriseJson)
    }
    
    static func mapArray(data: Data) -> [Enterprise]? {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let enterprisesJson = jsonObj.value(forKey: "enterprises") as? NSArray else {
            return nil
        }
        
        return enterprisesJson
            .compactMap { Enterprise.map(json: $0) }
    }
}
