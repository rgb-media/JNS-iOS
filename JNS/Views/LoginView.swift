//
//  LoginView.swift
//  JNS
//
//  Created by Adrian Picui on 24.04.2024.
//

import SwiftUI
import Combine

struct LoginView: View {
    private let welcomeTextFont = Font.custom("UtopiaStd-BoldDisp", size: 36)
    private let fieldsTextFont  = Font.custom("FreightSansProBook-Regular", size: 16)
    private let registerFont    = Font.custom("FreightSansProBold-Regular", size: 16)

    @EnvironmentObject var showLoginPopup: LoginPopupObservable
    @EnvironmentObject var showAlert: LoginAlertObservable
    @EnvironmentObject var showLoadingOverlay: LoadingOverlayObservable
    @EnvironmentObject var webViewModel: WebViewModel
    @EnvironmentObject var hasComments: HasCommentsObservable

    @State private var email    = ""
    @State private var password = ""
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                Color(hex: 0xA5181B).frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                        showLoginPopup.value = false
                    }) {
                        Image("Close")
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 30)
                }
                
                Spacer().frame(height: 26)
                
                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Text("Welcome to JNS")
                        .font(welcomeTextFont)
                        .foregroundColor(.jnsBlack)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 30)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Text("Email Address *")
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)

                    TextField("", text: $email)
                        .frame(height: 42)
                        .padding(.horizontal, 10)
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)
                        .background(Color(hex: 0xF8F8F8))
                        .border(Color.jnsGray)
                        .onAppear() {
                            showLoginPopup.$value.sink {
                                if !$0 {
                                    email = ""
                                }
                            }
                            .store(in: &Utils.subscriptions)
                        }

                    Spacer().frame(width: 40)
                }

                Spacer().frame(height: 30)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Text("Password *")
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)

                    Spacer()
                }
                
                Spacer().frame(height: 10)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)

                    SecureField("", text: $password)
                        .frame(height: 42)
                        .padding(.horizontal, 10)
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)
                        .background(Color(hex: 0xF8F8F8))
                        .border(Color.jnsGray)
                        .onAppear() {
                            showLoginPopup.$value.sink {
                                if !$0 {
                                    password = ""
                                }
                            }
                            .store(in: &Utils.subscriptions)
                        }

                    Spacer().frame(width: 40)
                }
                
                Spacer().frame(height: 10)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://crm.jns.org/log-in?referral=aHR0cHM6Ly93d3cuam5zLm9yZw==#ForgotPassword")!)
                    }) {
                        Text("Forgot your password?")
                            .font(fieldsTextFont)
                            .foregroundColor(Color(hex: 0x3399FF))
                    }

                    Spacer()
                }
                
                Spacer().frame(height: 40)
                
                Button(action: {
                    showLoadingOverlay.value = true
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                    LoginService.shared.sendLogin(email: email, password: password)
                        .sink { dataResponse in
                            showLoadingOverlay.value = false
                            showAlert.show = true

                            var result = dataResponse.value
                            if result == nil, let data = dataResponse.data {
                                result = try? JSONDecoder().decode(LoginModel.self, from: data)
                            }

                            if let userId = result?.id {
                                if let loginModel = result {
                                    LoginState.shared.userId = userId
                                    LoginState.shared.isPremiumUser = loginModel.status?.lowercased() == "premium"

                                    webViewModel.loginCookies = Utils.getCookiesFromLoginModel(loginModel)
                                    
                                    hasComments.value = loginModel.hasComments ?? false
                                    
                                    let json = Utils.getDataStringFromLoginModel(loginModel)
                                    _ = KeyChain.save(key: Constants.USER_DATA, value: json)
                                    
                                    LoginState.shared.isLoggedIn = true
                                    
                                    webViewModel.reload()
                                }
                                
                                showAlert.title = "Success!"
                                showAlert.body = "You are now logged in to JNS"
                                showAlert.isOk = true
                            } else if let error = result?.error, error == "auth_fail" || error == "unknown_email" {
                                showAlert.title = error == "auth_fail" ? "Incorrect password": "Incorrect email address"
                                showAlert.body = "Please check your credentials and try again"
                                showAlert.isOk = false
                            } else {
                                showAlert.title = "Login error"
                                showAlert.body = "Something went wrong and we couldn’t log you in. Please try again later"
                                showAlert.isOk = false
                            }
                        }.store(in: &Utils.subscriptions)
                }) {
                    Text("LOG IN")
                        .font(Font.custom("FreightSansProBold-Regular", size: 20))
                }
                .frame(height: 50)
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                .background(Capsule()
                    .strokeBorder(Color.jnsBlack, lineWidth: 1)
                    .background(Color.jnsBlack))
                .clipShape(Capsule())
                
                Spacer().frame(height: 20)
                
                HStack(spacing: 0) {
                    Text("Don't have an account?")
                        .font(registerFont)
                        .foregroundColor(.jnsBlack)
                    
                    Spacer().frame(width: 4)

                    Text("Register now")
                        .font(registerFont)
                        .foregroundColor(Color(hex: 0x3399FF))
                }
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://crm.jns.org/sign-up")!)
                }
                
                Spacer().frame(height: 40 + UIScreen.bottomSafeArea)
            }
            .background(.white)
        }
        .offset(y: -keyboardHeight + (keyboardHeight == 0 ? 0: 60))
        .ignoresSafeArea(.all)
        .onReceive(Publishers.keyboardHeight) {
            keyboardHeight = $0
        }
    }
}
