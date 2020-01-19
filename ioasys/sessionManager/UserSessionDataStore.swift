//
//  UserSessionDataStore.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

protocol UserSessionDataStoreProtocol {
    
    func deleteUserSession()
    func retrieveUserSession() -> UserSessionDB?
    func creatUserSession(uid: String, client: String, accessToken: String, currentUserDB: UserDB) -> UserSessionDB
    func updateSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) throws -> UserSessionDB
}

class UserSessionDataStore {
    
    private let currentSessionKey = "current_session_key"
    
    private func saveCurrentSessionWith(userSession: UserSessionDB?) {
        KeyedArchiverManager.saveObjectWith(key: currentSessionKey, object: userSession)
    }
}

extension UserSessionDataStore: UserSessionDataStoreProtocol {
    
    func deleteUserSession() {
        saveCurrentSessionWith(userSession: nil)
    }
    
    func retrieveUserSession() -> UserSessionDB? {
        return KeyedArchiverManager.retrieveObjectWith(key: currentSessionKey, type: UserSessionDB.self)
    }
    
    func creatUserSession(uid: String, client: String, accessToken: String, currentUserDB: UserDB) -> UserSessionDB {
        let newUserSession = UserSessionDB(uid: uid, client: client, accessToken: accessToken, currentUser: currentUserDB)
        saveCurrentSessionWith(userSession: newUserSession)
        return newUserSession
    }
    
    func updateSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) throws -> UserSessionDB {
        guard let userSession = retrieveUserSession() else {
            throw AuthManagerError.noSession
        }
        
        let updatedUserSession = UserSessionDB(uid: uid ?? userSession.uid,
                                               client: client ?? userSession.client,
                                               accessToken: accessToken ?? userSession.accessToken,
                                               currentUser: currentUser ?? userSession.currentUser)
        saveCurrentSessionWith(userSession: updatedUserSession)
        
        return updatedUserSession
    }
}
