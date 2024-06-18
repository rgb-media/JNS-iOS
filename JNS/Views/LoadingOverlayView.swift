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
            Color.jnsOverlay
            
            ProgressView()
                .scaleEffect(x: 4, y: 4)
        }
    }
}
