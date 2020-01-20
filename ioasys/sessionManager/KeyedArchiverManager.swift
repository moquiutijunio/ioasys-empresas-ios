//
//  KeyedArchiverManager.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

class KeyedArchiverManager {
    
    static func saveObjectWith(key: String, object: NSObject?) {
        let data: Data?
        if let object = object {
            data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) as Data?
        } else {
            data = nil
        }
        
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func retrieveObjectWith<T: NSObject>(key: String, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
            let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as Data) as? T else {
                return nil
        }
        
        return object
    }
}
