//
//  ContentView.swift
//  JNS
//
//  Created by Adrian Picui on 21.03.2024.
//

import SwiftUI

struct ContentView: View {
    private let headerHeight = 61.0
    
    @StateObject var showMenu = ObservableBoolean()
    
    @ObservedObject var promotionViewModel = PromotionViewModel()
    
    private let promotionTextFont   = Font.custom("FreightSansProBlack-Regular", size: 20)
    private let promotionButtonFont = Font.custom("FreightSansProBlack-Regular", size: 16)

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Colors.jnsRed.frame(height: 4)
                    Colors.jnsBlue.frame(height: 2)
                    
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Color(.lightGray).frame(width: 1, height: headerHeight)
                        Button(action: {
                        }) {
                            Image("User")
                        }
                        .frame(width: headerHeight, height: headerHeight)
                        
                        Color(.lightGray).frame(width: 1, height: headerHeight)
                        Button(action: {
                            showMenu.value.toggle()
                        }) {
                            Image(showMenu.value ? "CloseMenu" : "Menu")
                        }
                        .frame(width: headerHeight, height: headerHeight)
                    }
                    
                    Colors.jnsRed.frame(height: 1)
                    
                    HStack {
                        Text(promotionViewModel.promotion.title)
                            .font(promotionTextFont)
                            .foregroundColor(.white)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: promotionViewModel.promotion.signup_url)!)
                        }) {
                            Text(promotionViewModel.promotion.button_text)
                                .font(promotionButtonFont)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Capsule()
                            .strokeBorder(.white, lineWidth: 1)
                            .background(Color(hex: promotionViewModel.promotion.button_color)))
                        .clipShape(Capsule())
                        
                        Spacer().frame(width: 12)
                    }
                    .background(AsyncImage(url: URL(string: promotionViewModel.promotion.img_full_url))
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame([.horizontal, .vertical]))
                    .clipped()
                    .contentShape(Rectangle())
//                    .offset(x: 0, y: showMenu.value ? -64: 0)
//                    .animation(.linear(duration: Constants.PROMOTION_ANIMATION_DURATION), value: showMenu.value)
                }
                
                WebView(url: URL(string: Constants.HOMEPAGE_URL)!)
            }
            
            HStack {
                Image("LogoFrame").padding(.leading, 8)
                Spacer()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
