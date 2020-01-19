//
//  SessionManager.swift
//  ioasys
//
//  Created by Junio Moquiuti on 19/01/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation
import RxSwift

enum UserSessionState: Equatable {
    
    case hasSession(session: UserSessionDB)
    case notHaveSession
    case sessionExpired
}

enum AuthManagerError: Swift.Error {
    
    case noSession
    case errorToCreateSession
}

protocol SessionManagerProtocol {
    
    var currentUserObserver: Observable<UserDB?> { get }
    var sessionState: Observable<UserSessionState> { get }
    
    func logout()
    func expireSession()
    func retrieveUserSession() -> UserSessionDB?
    func createUserSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) throws
    func updateSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) throws
}

class SessionManager {
    
    static let shared: SessionManagerProtocol = SessionManager()
    
    private lazy var sessionDataStore = UserSessionDataStore()
    
    private var cachedSession: UserSessionDB? {
        didSet {
            if let cachedSession = cachedSession {
                stateSubject.onNext(.hasSession(session: cachedSession))
            }
        }
    }
    
    private lazy var stateSubject: BehaviorSubject<UserSessionState> = {
        if let sessionDB = self.retrieveUserSession() {
            return BehaviorSubject<UserSessionState>(value: .hasSession(session: sessionDB))
        } else {
            return BehaviorSubject<UserSessionState>(value: .notHaveSession)
        }
    }()
    
    private func deleteUserSession() {
        sessionDataStore.deleteUserSession()
        cachedSession = nil
    }
}

extension SessionManager: SessionManagerProtocol {
    
    var currentUserObserver: Observable<UserDB?> {
        return stateSubject
            .map { (state) -> UserDB? in
                switch state {
                case .hasSession(let userSessionDB):
                    return userSessionDB.currentUser
                case .notHaveSession,
                     .sessionExpired:
                    return nil
                }
        }
    }
    
    var sessionState: Observable<UserSessionState> {
        return stateSubject
    }
    
    func updateSession(uid: String?, client: String?, accessToken: String? = nil, currentUser: UserDB? = nil) throws {
        cachedSession = try? sessionDataStore.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
    }
    
    func createUserSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) throws {
        if let uid = uid, let client = client, let accessToken = accessToken, let currentUser = currentUser {
            cachedSession = sessionDataStore.creatUserSession(uid: uid, client: client, accessToken: accessToken, currentUserDB: currentUser)
        } else {
            throw AuthManagerError.errorToCreateSession
        }
    }
    
    func retrieveUserSession() -> UserSessionDB? {
        if let cachedSession = cachedSession {
            return cachedSession
        }
        
        return sessionDataStore.retrieveUserSession()
    }
    
    func expireSession() {
        deleteUserSession()
        stateSubject.onNext(.sessionExpired)
    }
    
    func logout() {
        deleteUserSession()
        stateSubject.onNext(.notHaveSession)
    }
}
