//
//  PushAlertModel.swift
//  JNS
//
//  Created by Adrian Picui on 22.05.2024.
//

import Foundation

class PushAlertModel: ObservableObject {
    @Published var showAlert = false
    @Published var title = ""
    @Published var message = ""
    @Published var url = ""
}
