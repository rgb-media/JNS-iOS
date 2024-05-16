//
//  JNSApp.swift
//  JNS
//
//  Created by Adrian Picui on 21.03.2024.
//

import SwiftUI

@main
struct JNSApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    init() {
        Config.loadFromFile()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
