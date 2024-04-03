//
//  ContentView.swift
//  JNS
//
//  Created by Adrian Picui on 21.03.2024.
//

import SwiftUI

struct ContentView: View {
    private let headerHeight = 61.0
    
    private let promotionTextFont   = Font.custom("FreightSansProBlack-Regular", size: 20)
    private let promotionButtonFont = Font.custom("FreightSansProBlack-Regular", size: 16)
    private let bottomBarFont       = Font.custom("FreightSansProBook-Regular", size: 12)

    @State var webViewContentOffset = CGPoint(x: 0, y: 0)
    @State var selectedBottomIndex  = 0

    @StateObject var webViewModel   = WebViewModel()
    @StateObject var showMenu       = ShowMenuObservable()
    @StateObject var showLoginPopup = LoginPopupObservable()
    
    @ObservedObject var promotionViewModel = PromotionViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: headerHeight + 6)
                        
                        if webViewContentOffset.y == 0 {
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
                            .transition(.move(edge: .top))
                        }
                    }

                    VStack(spacing: 0) {
                        Colors.jnsRed.frame(height: 4)
                        Colors.jnsBlue.frame(height: 2)
                        
                        HStack(spacing: 0) {
                            if webViewModel.isArticle {
                                HStack(spacing: 0) {
                                    Button(action: {
                                        webViewModel.goBack()
                                    }) {
                                        Image("Back")
                                    }
                                    .frame(width: 32, height: headerHeight)
                                    
                                    Image("Logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 44)
                                }
                            }

                            Spacer()
                            
                            if webViewModel.isArticle {
                                Color(.lightGray).frame(width: 1, height: headerHeight)
                                Button(action: {
                                    guard let url = webViewModel.webView.url else {
                                        return
                                    }
                                    
                                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

                                    UIApplication.shared.connectedScenes
                                            .filter({$0.activationState == .foregroundActive})
                                            .map({$0 as? UIWindowScene})
                                            .compactMap({$0})
                                            .first?.windows
                                            .filter({$0.isKeyWindow})
                                            .first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                                }) {
                                    Image("Share")
                                }
                                .frame(width: headerHeight, height: headerHeight)
                            }

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
                    }
                    .background(.white)
                }
                
                WebView(webViewModel: webViewModel, contentOffset: $webViewContentOffset)
                
                Color(hex: 0x969696).frame(height: 1)
                
                HStack(spacing: 0) {
                    VStack {
                        Image("Home")
                            .renderingMode(.template)
                            .foregroundColor(selectedBottomIndex == 0 ? Colors.jnsRed: .black)
                        
                        Text("HOME")
                            .font(bottomBarFont)
                            .foregroundColor(selectedBottomIndex == 0 ? Colors.jnsRed: .black)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedBottomIndex = 0

                        webViewModel.urlString = Constants.HOMEPAGE_URL
                    }
                    
                    VStack {
                        Image("Latest")
                            .renderingMode(.template)
                            .foregroundColor(selectedBottomIndex == 1 ? Colors.jnsRed: .black)

                        Text("LATEST")
                            .font(bottomBarFont)
                            .foregroundColor(selectedBottomIndex == 1 ? Colors.jnsRed: .black)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedBottomIndex = 1
                        
                        webViewModel.urlString = Constants.LATEST_URL
                    }

                    VStack {
                        Image("Opinion")
                            .renderingMode(.template)
                            .foregroundColor(selectedBottomIndex == 2 ? Colors.jnsRed: .black)

                        Text("OPINION")
                            .font(bottomBarFont)
                            .foregroundColor(selectedBottomIndex == 2 ? Colors.jnsRed: .black)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedBottomIndex = 2
                        
                        webViewModel.urlString = Constants.OPINION_URL
                    }

                    VStack {
                        Image("Media")
                            .renderingMode(.template)
                            .foregroundColor(selectedBottomIndex == 3 ? Colors.jnsRed: .black)

                        Text("MEDIA")
                            .font(bottomBarFont)
                            .foregroundColor(selectedBottomIndex == 3 ? Colors.jnsRed: .black)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        selectedBottomIndex = 3
                        
                        webViewModel.urlString = Constants.MEDIA_URL
                    }
                }
                .frame(height: 60)
                .background(.white)
            }
            .animation(.linear(duration: Constants.PROMOTION_ANIMATION_DURATION), value: webViewContentOffset.y == 0)

            if !webViewModel.isArticle {
                HStack {
                    Image("LogoFrame").padding(.leading, 8)
                    Spacer()
                }
            }
        }
        .environmentObject(showLoginPopup)
//        .ignoresSafeArea(edges: .bottom)
    }
}

//#Preview {
//    ContentView()
//}
