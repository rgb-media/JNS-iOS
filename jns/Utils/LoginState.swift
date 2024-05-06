//
//  LoginState.swift
//  JNS
//
//  Created by Adrian Picui on 07.05.2024.
//

import Foundation

class LoginState {
    @Published public var isLoggedIn = false
    
    static let shared: LoginState = LoginState()
    private init() { }
}
