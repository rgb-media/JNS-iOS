//
//  ShowAlertObservable.swift
//  JNS
//
//  Created by Adrian Picui on 06.05.2024.
//

import Foundation

class LoginAlertObservable: ObservableObject {
    @Published var show  = false
    @Published var isOk  = false
    @Published var title = ""
    @Published var body  = ""
}
