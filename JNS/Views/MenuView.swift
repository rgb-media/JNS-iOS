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
    private let copyrightTextFont       = Font.custom("FreightSansProBook-Regular", size: 13)

    @ObservedObject var menuViewModel = MenuViewModel()
    
    @State private var pushNotificationsActive = false

    init() {
       UIScrollView.appearance().bounces = false
    }
    
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

                MenuListCell(menuItem: .init(name: "More from JNS",
                                             link: "",
                                             secondary_items: menuViewModel.more))

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
                
                VStack {
                    Spacer().frame(height: 20)

                    Text("Follow Us")
                        .font(extraItemTextFont)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            UIApplication.shared.open(URL(string: "whatsapp://send?text=https://apps.apple.com/us/app/the-times-of-israel/id1006406749")!)
                        }) {
                            Image("Whatsapp")
                        }
                        
                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.facebook.com/JNS.org")!)
                        }) {
                            Image("Facebook")
                        }
                        
                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://twitter.com/JNS_org")!)
                        }) {
                            Image("X")
                        }
                        
                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.instagram.com/JNS_org/")!)
                        }) {
                            Image("Instagram")
                        }
                        
                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.youtube.com/@JNS_TV")!)
                        }) {
                            Image("Youtube")
                        }
                        
                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.linkedin.com/company/jns.org")!)
                        }) {
                            Image("LinkenIn")
                        }
                        
//                        Spacer().frame(width: 12)

                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://www.jns.org/feed/")!)
                        }) {
                            Image("RSS")
                        }
                    }
                    
                    Spacer().frame(height: 20)

                    Color.init(hex: 0xFFFFFF, alpha: 0.25)
                        .frame(height: 1)
                        .padding(.horizontal, 18)

                    Spacer().frame(height:16)

                    Text("© 2024 JNS, All Rights Reserved")
                        .font(copyrightTextFont)
                        .foregroundColor(.white)

                    Text("Concept, design & development by RGB Media.\nPowered by Salamandra")
                        .font(copyrightTextFont)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.init(hex: 0xFFFFFF, alpha: 0.6))
                    
                    Spacer().frame(height:16)
                }
                .frame(maxWidth: .infinity)
                .background(Color.jnsBlack)
                .padding(.horizontal, -18)
            }
            .padding(.horizontal, 18)
        }
        .background(.white)
    }
}
