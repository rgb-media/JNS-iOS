//
//  LoginState.swift
//  JNS
//
//  Created by Adrian Picui on 07.05.2024.
//

import Foundation

class LoginState {
    @Published public var isLoggedIn = false
    @Published public var isPremiumUser = false

    public var userId = -1
    
    static let shared: LoginState = LoginState()
    private init() { }
    
    public func logout() {
        isLoggedIn = false
        isPremiumUser = false
        userId = -1
    }
}
