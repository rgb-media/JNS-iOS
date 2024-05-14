//
//  SearchView.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var showMenu: ShowMenuObservable
    @EnvironmentObject var webViewModel: WebViewModel
    
    @State var searchText = ""

    var body: some View {
        HStack {
            ZStack {
                if searchText.isEmpty {
                    Text("Type to search")
                        .font(Font.custom("FreightSansProBook-Regular", size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(hex: 0x646464))
                }
                
                TextField("", text: $searchText)
                    .onAppear() {
                        showMenu.$value.sink {
                            if !$0 {
                                searchText = ""
                            }
                        }
                        .store(in: &Utils.subscriptions)
                    }
                    .onSubmit {
                        webViewModel.urlString = "https://www.jns.org/?s=\(searchText)"
                        
                        showMenu.value = false
                    }
                    .font(Font.custom("FreightSansProBook-Regular", size: 16))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.jnsBlack)
                    .submitLabel(.search)
            }

            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                webViewModel.urlString = "https://www.jns.org/?s=\(searchText)"
                
                showMenu.value = false
            }) {
                Text("SEARCH")
                    .font(Font.custom("FreightSansProBold-Regular", size: 16))
            }
            .frame(height: 46)
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(Capsule()
                .strokeBorder(Color.jnsBlack, lineWidth: 1)
                .background(Color.jnsBlack))
            .clipShape(Capsule())
            
            Spacer().frame(width: 2)
        }
        .frame(height: 50)
        .padding(.leading, 20)
        .background(Capsule()
            .strokeBorder(Color.jnsBlack, lineWidth: 1)
            .background(.white))
        .clipShape(Capsule())
    }
}
