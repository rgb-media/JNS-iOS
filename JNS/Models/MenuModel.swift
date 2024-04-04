//
//  MenuModel.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import Foundation

struct MenuItem: Decodable, Identifiable {
    let id = UUID()
    
    let name: String
    let link: String
    let secondary_items: [String: MenuItem]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case link
        case secondary_items
    }
}

typealias MenuModel = [String: [String: MenuItem]]
