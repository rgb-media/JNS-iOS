//
//  LoginModel.swift
//  JNS
//
//  Created by Adrian Picui on 02.05.2024.
//

struct LoginModel: Codable {
    let error: String?
    let message: String?
    let id: Int?
    let status: String?
    let hasSubscription: Bool?
    let hasComments: Bool?
    let firstName: String?
    let lastName: String?
    let crmSession: String?
    
    private enum CodingKeys : String, CodingKey {
      case crmSession = "CRMSESSION", error, message, id, status, hasSubscription, hasComments, firstName, lastName
    }
}
