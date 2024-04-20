//
//  SubscribeView.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import SwiftUI
import Combine

struct SubscribeView: View {
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
    
    @State private var showAlert    = false
    @State private var alertMessage = ""
    
    func signupTapped() {
        BrevoService.shared.registerEmail(email: textObserver.searchText)
            .sink { dataResponse in
                showAlert = true
                
                var result = dataResponse.value
                if result == nil, let data = dataResponse.data {
                    result = try? JSONDecoder().decode(BrevoModel.self, from: data)
                }

                if result?.id != nil {
                    alertMessage = "Newsletter subscription was successful!"
                } else if let message = result?.message {
                    alertMessage = message
                } else {
                    alertMessage = "An error has occured. Please try again later."
                }
            }.store(in: &Utils.subscriptions)

        showMenu.value = false
    }

    var body: some View {
        HStack {
            ZStack {
                if textObserver.searchText.isEmpty {
                    Text("Your Email")
                        .font(Font.custom("FreightSansProBook-Regular", size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(hex: 0x646464))
                }
                
                TextField("", text: $textObserver.searchText)
                    .onSubmit {
                        signupTapped()
                    }
                    .font(Font.custom("FreightSansProBold-Regular", size: 16))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.jnsBlack)
                    .submitLabel(.send)
            }

            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                signupTapped()
            }) {
                Text("FREE SIGN UP")
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Newsletter"),
                message: Text(alertMessage)
            )
        }
    }
}
