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
                            Image(showMenu.value ? "Close" : "Menu")
                        }
                        .frame(width: headerHeight, height: headerHeight)
                    }
                    
                    Colors.jnsRed.frame(height: 1)
                    
                    HStack {
                        Text("Support Jewish News Syndicate")
                            .foregroundColor(.white)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                        }) {
                            Text("DONATE")
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .foregroundColor(.white)
                        .background(Capsule().strokeBorder(.white, lineWidth: 1).background(.blue))
                        .clipShape(Capsule())
                    
                        Spacer().frame(width: 12)
                    }
                    .background(Colors.jnsRed)
                }
                
//                WebView(url: URL(string: "about:blank")!)
                WebView(url: URL(string: "https://www.jns.org")!)
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
