//
//  LoginModel.swift
//  JNS
//
//  Created by Adrian Picui on 02.05.2024.
//

struct LoginModel: Decodable {
    let error: String?
    let message: String?
    let id: Int?
    let status: String?
    let hasSubscription: Bool?
    let firstName: String?
    let lastName: String?
}
