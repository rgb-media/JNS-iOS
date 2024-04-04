//
//  MenuView.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import SwiftUI

struct MenuView: View {
    private let itemTextFont   = Font.custom("FreightSansProBold-Regular", size: 28)

    @ObservedObject var menuViewModel = MenuViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 32)
                
                SearchView()
                
                Spacer().frame(height: 20)

                Color(hex: 0x252525).frame(height: 1)

                Spacer().frame(height: 12)

                ForEach(menuViewModel.menu) { menuItem in
                    HStack {
                        Text(menuItem.name.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(itemTextFont)
                        
                        if menuItem.secondary_items != nil && menuItem.secondary_items?.isEmpty == false {
                            Image("ArrowDown")
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 12)
                }
                
                Color(hex: 0x252525).frame(height: 1)
            }
            .padding(.horizontal, 18)
        }
        .background(.white)
    }
}
