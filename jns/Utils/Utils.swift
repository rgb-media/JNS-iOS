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
}
