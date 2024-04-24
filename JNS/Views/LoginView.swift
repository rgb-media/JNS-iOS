//
//  LoginView.swift
//  JNS
//
//  Created by Adrian Picui on 24.04.2024.
//

import SwiftUI

struct LoginView: View {
    private let welcomeTextFont = Font.custom("UtopiaStd-BoldDisp", size: 36)
    private let fieldsTextFont  = Font.custom("FreightSansProBook-Regular", size: 16)
    private let registerFont    = Font.custom("FreightSansProBold-Regular", size: 16)

    @EnvironmentObject var showMenu: ShowMenuObservable
    @EnvironmentObject var showLoginPopup: LoginPopupObservable
    
    @State private var email    = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 0) {
            Color(red: 0, green: 0, blue: 0, opacity: 0.7)

            VStack(spacing: 0) {
                Color(hex: 0xA5181B).frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10)
                
                HStack {
                    Spacer()
                    Button(action: {
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
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)
                        .background(Color(hex: 0xF8F8F8))
                        .border(Color.jnsBlack)

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

                    TextField("", text: $password)
                        .frame(height: 42)
                        .font(fieldsTextFont)
                        .foregroundColor(.jnsBlack)
                        .background(Color(hex: 0xF8F8F8))
                        .border(Color.jnsBlack)

                    Spacer().frame(width: 40)
                }
                
                Spacer().frame(height: 10)

                HStack(spacing: 0) {
                    Spacer().frame(width: 40)
                    
                    Text("Forgot your password?")
                        .font(fieldsTextFont)
                        .foregroundColor(Color(hex: 0x3399FF))
                    
                    Spacer()
                }
                
                Spacer().frame(height: 40)
                
                Button(action: {
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
                
                Spacer().frame(height: 80)
            }
            .background(.white)
        }
        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.7))
    }
}
