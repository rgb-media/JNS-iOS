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

    private class TextFieldObserver : ObservableObject {
        @Published var debouncedText = ""
        @Published var searchText = ""
        
        private var subscriptions = Set<AnyCancellable>()
        
        init() {
            $searchText
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                .sink(receiveValue: { [weak self] t in
                    self?.debouncedText = t
                } )
                .store(in: &subscriptions)
        }
    }
    
    @StateObject private var textObserver = TextFieldObserver()
    
    var body: some View {
        HStack {
            ZStack {
                if textObserver.searchText.isEmpty {
                    Text("Type to search")
                        .font(Font.custom("FreightSansProBook-Regular", size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(hex: 0x646464))
                }
                
                TextField("", text: $textObserver.searchText)
                    .onSubmit {
                        webViewModel.urlString = "https://www.jns.org/?s=\(textObserver.searchText)"
                        
                        showMenu.value = false
                    }
                    .font(Font.custom("FreightSansProBold-Regular", size: 16))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(hex: 0x282828))
                    .submitLabel(.search)
            }

            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                webViewModel.urlString = "https://www.jns.org/?s=\(textObserver.searchText)"
                
                showMenu.value = false
            }) {
                Text("SEARCH")
                    .font(Font.custom("FreightSansProBold-Regular", size: 16))
            }
            .frame(height: 46)
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(Capsule()
                .background(Color(hex: 0x252525)))
            .clipShape(Capsule())
            
            Spacer().frame(width: 2)
        }
        .frame(height: 50)
        .padding(.leading, 20)
        .background(Capsule()
            .strokeBorder(Color(hex: 0x252525), lineWidth: 1)
            .background(.white))
        .clipShape(Capsule())
    }
}
