//
//  Utils.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import Foundation
import Combine

class Utils {
    public static var subscriptions = Set<AnyCancellable>()

    public static func isArticle(url: URL) -> Bool {
        let components = url.pathComponents
        
        guard components.count == 2 else {
            return false
        }
        
        let component = components.last
        
        guard component != "latest" && component != "opinion" else {
            return false
        }
        
        return true
    }

    public static func getLoginModelFromString(_ jsonString: String) -> LoginModel? {
        if let data = jsonString.data(using: .utf8),
           let json = try? JSONDecoder().decode(LoginModel.self, from: data) {
            return json
        }
        
        return nil
    }
    
    public static func getCookiesFromLoginModel(_ model: LoginModel) -> [HTTPCookie] {
        var cookies = [HTTPCookie]()
        
        let json = getDataStringFromLoginModel(model)
        
        if let cookie = HTTPCookie(properties: [
            .domain: ".jns.org",
            .path: "/",
            .name: Constants.CRMUSER_COOKIE,
            .value: json,
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 365 * 10)// ten years
        ]) {
            cookies.append(cookie)
        }

        if let cookie = HTTPCookie(properties: [
            .domain: ".jns.org",
            .path: "/",
            .name: Constants.USERID_COOKIE,
            .value: String(model.id ?? -1),
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 365 * 10)// ten years
        ]) {
            cookies.append(cookie)
        }

        return cookies
    }
    
    public static func getDataStringFromLoginModel(_ model: LoginModel) -> String {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(model)
            let json = String(data: jsonData, encoding: .utf8)
            
            if let json = json {
                return json
            }
        } catch {
            print("Utils.getDataStringFromLoginModel - Error encoding login data to JSON: \(error)")
        }
        
        return "{}"
    }
}
