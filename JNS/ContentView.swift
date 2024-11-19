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
    private let loginMenuFont       = Font.custom("FreightSansProBook-Regular", size: 18)
    
    private let menuView = MenuView()
    
    @State var webViewContentOffset = CGPoint(x: 0, y: 0)
    @State var selectedBottomIndex  = 0
    @State var showLoggedInMenu     = false
    
    @StateObject var webViewModel   = WebViewModel()
    @StateObject var showMenu       = ShowMenuObservable()
    @StateObject var showLoginPopup = LoginPopupObservable()
    @StateObject var loginAlert     = LoginAlertObservable()
    @StateObject var hasComments    = HasCommentsObservable()
    @StateObject var showLoading    = LoadingOverlayObservable()
    @StateObject var pushAlert      = PushAlertModel()

    @ObservedObject var promotionViewModel = PromotionViewModel()
    
    var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Color.jnsRed.frame(height: 4)
                        Color.jnsBlue.frame(height: 2)
                        
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
                                        .onTapGesture {
                                            webViewModel.urlString = Constants.HOMEPAGE_URL
                                        }
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
                            
                            if hasComments.value {
                                Color(.lightGray).frame(width: 1, height: headerHeight)
                                Button(action: {
                                    webViewModel.urlString = "\(Constants.COMMENT_URL)\(LoginState.shared.userId)"
                                }) {
                                    Image("Comment")
                                }
                                .frame(width: headerHeight, height: headerHeight)
                            }
                            
                            Color(.lightGray).frame(width: 1, height: headerHeight)
                            Button(action: {
                                if LoginState.shared.isLoggedIn {
                                    showLoggedInMenu = !showLoggedInMenu
                                } else {
                                    showLoginPopup.value = true
                                }
                            }) {
                                Image("User")
                            }
                            .frame(width: headerHeight, height: headerHeight)
                            
                            Color(.lightGray).frame(width: 1, height: headerHeight)
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                showMenu.value.toggle()
                                
//                                webViewModel.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
//                                    for cookie in cookies {
//                                        print("\(cookie)\n")
//                                    }
//                                }
                            }) {
                                Image(showMenu.value ? "CloseMenu" : "Menu")
                                    .animation(.none)
                            }
                            .frame(width: headerHeight, height: headerHeight)
                        }
                        
                        Color.jnsRed.frame(height: 1)
                    }
                    .background(.white)
                    .zIndex(1)
                    
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            if !LoginState.shared.isPremiumUser {
                                if webViewContentOffset.y == 0 {
                                    HStack {
                                        Text(promotionViewModel.promotion.title)
                                            .font(promotionTextFont)
                                            .foregroundColor(.white)
                                            .padding(20)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Button(action: {
                                            var url = promotionViewModel.promotion.registed_user_url
                                            if url.starts(with: "/") {
                                                url = "https://www.jns.org" + url
                                            }
                                            
                                            UIApplication.shared.open(URL(string: url)!)
                                        }) {
                                            Text(promotionViewModel.promotion.button_text ?? "DONATE")
                                                .font(promotionButtonFont)
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 8)
                                        .foregroundColor(Color(hex: promotionViewModel.promotion.button_color ?? "#0000FF"))
                                        .background(Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                            .background(Color(hex: promotionViewModel.promotion.button_bg_color ?? "#FFFFFF")))
                                        .clipShape(Capsule())
                                        
                                        Spacer().frame(width: 12)
                                    }
                                    .background(AsyncImage(url: URL(string: promotionViewModel.promotion.img_full_url))
                                        .aspectRatio(contentMode: .fill))
                                    .clipped()
                                    .contentShape(Rectangle())
                                    .transition(.move(edge: .top))
                                }
                            }
                            
                            WebView(webViewModel: webViewModel, contentOffset: $webViewContentOffset)
                        }
                    }
                    
                    Color.jnsGray.frame(height: 1)
                    
                    HStack(spacing: 0) {
                        VStack {
                            Image("Home")
                                .renderingMode(.template)
                                .foregroundColor(selectedBottomIndex == 0 ? .jnsRed: .jnsBlack)
                            
                            Text("HOME")
                                .font(bottomBarFont)
                                .foregroundColor(selectedBottomIndex == 0 ? .jnsRed: .jnsBlack)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedBottomIndex = 0
                            
                            webViewModel.urlString = Constants.HOMEPAGE_URL
                        }
                        
                        VStack {
                            Image("Latest")
                                .renderingMode(.template)
                                .foregroundColor(selectedBottomIndex == 1 ? .jnsRed: .jnsBlack)
                            
                            Text("LATEST")
                                .font(bottomBarFont)
                                .foregroundColor(selectedBottomIndex == 1 ? .jnsRed: .jnsBlack)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedBottomIndex = 1
                            
                            webViewModel.urlString = Constants.LATEST_URL
                        }
                        
                        VStack {
                            Image("Opinion")
                                .renderingMode(.template)
                                .foregroundColor(selectedBottomIndex == 2 ? .jnsRed: .jnsBlack)
                            
                            Text("OPINION")
                                .font(bottomBarFont)
                                .foregroundColor(selectedBottomIndex == 2 ? .jnsRed: .jnsBlack)
                        }
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selectedBottomIndex = 2
                            
                            webViewModel.urlString = Constants.OPINION_URL
                        }
                        
                        VStack {
                            Image("Media")
                                .renderingMode(.template)
                                .foregroundColor(selectedBottomIndex == 3 ? .jnsRed: .jnsBlack)
                            
                            Text("MEDIA")
                                .font(bottomBarFont)
                                .foregroundColor(selectedBottomIndex == 3 ? .jnsRed: .jnsBlack)
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
                
                VStack {
                    Spacer().frame(height: headerHeight + 7)
                    
                    menuView
                        .frame(maxHeight: showMenu.value ? .infinity : 0)
                        .animation(.linear(duration: Constants.MENU_ANIMATION_DURATION), value: showMenu.value)
                }
                
                if showLoggedInMenu {
                    HStack {
                        Spacer()
                        
                        VStack() {
                            VStack() {
                                Spacer().frame(height: 15)
                                
                                HStack {
                                    Spacer().frame(width: 15)
                                    
                                    Button(action: {
                                        UIApplication.shared.open(URL(string: "https://crm.jns.org/profile")!)
                                        
                                        showLoggedInMenu = false
                                    }) {
                                        Text("My Profile")
                                            .font(loginMenuFont)
                                            .foregroundColor(.jnsBlack)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 8)
                                
                                HStack {
                                    Spacer().frame(width: 15)
                                    
                                    Button(action: {
                                        UIApplication.shared.open(URL(string: "https://crm.jns.org/support")!)
                                        
                                        showLoggedInMenu = false
                                    }) {
                                        Text("Support")
                                            .font(loginMenuFont)
                                            .foregroundColor(.jnsBlack)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 8)
                                
                                HStack {
                                    Spacer().frame(width: 15)
                                    
                                    Button(action: {
                                        LoginState.shared.logout()
                                        
                                        showLoggedInMenu = false
                                        
                                        hasComments.value = false
                                        
                                        webViewModel.loginCookies = []
                                        
                                        _ = KeyChain.save(key: Constants.USER_DATA, value: "")
                                    }) {
                                        Text("Log out")
                                            .font(loginMenuFont)
                                            .foregroundColor(.jnsBlack)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 15)
                            }
                            .frame(width: 2 * headerHeight + 2)
                            .background(.white)
                            .border(Color.jnsRed)
                            
                            Spacer()
                        }
                    }
                    .background(Color.jnsOverlay)
                    .padding(.top, headerHeight + 6)
                    .onTapGesture {
                        showLoggedInMenu = false
                    }
                }
                
                if !webViewModel.isArticle {
                    HStack {
                        Image("LogoFrame").padding(.leading, 8)
                            .onTapGesture {
                                webViewModel.urlString = Constants.HOMEPAGE_URL
                            }
                        
                        Spacer()
                    }
                }
                
                if showLoginPopup.value {
                    Color(red: 0, green: 0, blue: 0, opacity: 0.7)
                        .ignoresSafeArea(edges: .top)
                }
                
                LoginView()
                    .transition(.move(edge: .bottom))
                    .offset(y: showLoginPopup.value ? 0 : UIScreen.main.bounds.height)
                    .animation(.linear(duration: Constants.MENU_ANIMATION_DURATION), value: showLoginPopup.value)
                    .environmentObject(hasComments)
                
                if showLoading.value {
                    LoadingOverlayView()
                }
            }
            .padding(.bottom, 13)
            .ignoresSafeArea(edges: .bottom)
            .environmentObject(webViewModel)
            .environmentObject(showMenu)
            .environmentObject(showLoginPopup)
            .environmentObject(showLoading)
            .environmentObject(loginAlert)
            .alert(loginAlert.title, isPresented: $loginAlert.show, actions: {
                Button("OK", role: nil, action: {
                    if loginAlert.isOk {
                        showLoginPopup.value = false
                        
                        webViewModel.reload()
                    }
                })
            }, message: {
                Text(loginAlert.body)
            })
            .alert(pushAlert.title, isPresented: $pushAlert.showAlert, actions: {
                Button("Cancel", role: .cancel, action: {})
                Button("OPEN", role: nil, action: { webViewModel.urlString = pushAlert.url })
            }, message: {
                Text(pushAlert.message)
            })
            .onReceive(NotificationCenter.default.publisher(for: Constants.PUSH_NOTIFICATION_ALERT)) { msg in
                let payload = msg.object as! PushAlertModel
                pushAlert.title = payload.title
                pushAlert.message = payload.message
                pushAlert.url = payload.url
                pushAlert.showAlert = payload.showAlert
                
                if !pushAlert.showAlert {
                    webViewModel.urlString = pushAlert.url
                }
            }
            .onAppear() {
                if let json = KeyChain.load(key: Constants.USER_DATA), let loginModel = Utils.getLoginModelFromString(json) {
                    LoginState.shared.isLoggedIn = true
                    LoginState.shared.userId = loginModel.id ?? -1
                    LoginState.shared.isPremiumUser = loginModel.status?.lowercased() == "premium"
                    
                    hasComments.value = loginModel.hasComments ?? false
                    
                    let cookies = Utils.getCookiesFromLoginModel(loginModel)
                    webViewModel.loginCookies = cookies
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
