//
//  LoadingOverlayView.swift
//  JNS
//
//  Created by Adrian Picui on 15.05.2024.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color(hex: 0x000000, alpha: 0.7)
            
            ProgressView()
                .scaleEffect(x: 4, y: 4)
        }
    }
}
