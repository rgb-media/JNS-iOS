//
//  MenuView.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import SwiftUI

struct MenuView: View {
    private let extraItemTextFont       = Font.custom("FreightSansProBold-Regular", size: 18)
    private let estraSubItemTextFont    = Font.custom("FreightSansProBook-Regular", size: 18)
    private let pushSubItemTextFont     = Font.custom("FreightSansProBook-Regular", size: 16)

    @ObservedObject var menuViewModel = MenuViewModel()
    
    @State private var pushNotificationsActive = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 32)
                
                SearchView()
                
                Spacer().frame(height: 20)

                Color.jnsBlack.frame(height: 1)

                Spacer().frame(height: 12)

                ForEach(menuViewModel.menu) { menuItem in
                    MenuListCell(menuItem: menuItem)
                }
                
                Color.jnsBlack.frame(height: 1)

                Spacer().frame(height: 16)

                HStack {
                    Text("More from JNS")
                        .font(extraItemTextFont)
                        .foregroundColor(.jnsBlack)
                    
                    Image("ArrowDown")
                }

                Spacer().frame(height: 16)

                Color.jnsBlack.frame(height: 1)
                
                Spacer().frame(height: 16)

                HStack {
                    Text("Subscribe to The Newsletter")
                        .font(extraItemTextFont)
                        .foregroundColor(.jnsBlack)
                    
                    Image("ArrowDown")
                }

                Spacer().frame(height: 16)

                HStack() {
                    Spacer().frame(width: 18)

                    VStack(alignment: .leading) {
                        Spacer().frame(height: 20)

                        Text("Push Notifications")
                            .font(extraItemTextFont)
                            .foregroundColor(.white)
                        
                        Text("Never miss a breaking story")
                            .font(pushSubItemTextFont)
                            .foregroundColor(.white)

                        Spacer().frame(height: 20)
                    }
                    
                    Toggle("", isOn: $pushNotificationsActive)
                        .tint(.jnsBlack)
                    
                    Spacer().frame(width: 18)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x3E98FA), Color(hex: 0x1D3268), Color(hex: 0x1D3268)]),
                                           startPoint: .trailing, endPoint: .leading))
                .padding(.horizontal, -18)
            }
            .padding(.horizontal, 18)
        }
        .background(.white)
    }
}
