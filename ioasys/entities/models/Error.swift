//
//  Error.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

struct Error: Codable {
    
    private var errors: [String]?
    var localizedDescription: String {
        guard let errors = errors else { return NSLocalizedString("generic.error", comment: "") }
        return errors.joined(separator: "\n")
    }
    
    enum CodingKeys: String, CodingKey {
        case errors
    }
}

extension Error {
    
    static func map(json: [String: Any]) -> Error? {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
            let error = try? JSONDecoder().decode(Error.self, from: data) else {
            return nil
        }
        
        return error
    }
}
