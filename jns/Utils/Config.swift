//
//  Config.swift
//  JNS
//
//  Created by Adrian Picui on 07.05.2024.
//

import Foundation

class Config {
    public static var APP_SECRET    = ""
    public static var BREVO_API_KEY = ""
    
    public static func loadFromFile() {
        if let url = Bundle.main.url(forResource: "config", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = jsonResult as? [String: String] {
                    APP_SECRET = dictionary["APP_SECRET"]!
                    BREVO_API_KEY = dictionary["BREVO_API_KEY"]!
                }
            } catch {
                fatalError("Error reading config.json file")
            }
        } else {
            fatalError("config.json file does not exist")
        }
    }
}
