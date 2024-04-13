//
//  MenuListCell.swift
//  JNS
//
//  Created by Adrian Picui on 13.04.2024.
//

import SwiftUI

struct MenuListCell: View {
    private let itemTextFont    = Font.custom("FreightSansProBold-Regular", size: 28)
    private let subItemTextFont = Font.custom("FreightSansProBook-Regular", size: 18)

    @State private var expanded = false

    @EnvironmentObject var webViewModel: WebViewModel
    @EnvironmentObject var showMenu: ShowMenuObservable
    
    private let menuItem: MenuItem
    private let subItems: [MenuItem]
    
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        
        subItems = menuItem.secondary_items?.sorted(by: { $0.0 < $1.0 }).map({ $0.1 }) ?? []
    }

    var body: some View {
        HStack {
            Text(menuItem.name.trimmingCharacters(in: .whitespacesAndNewlines))
                .font(itemTextFont)
                .foregroundColor(.jnsBlack)
            
            if let subItems = menuItem.secondary_items, !subItems.isEmpty {
                Image(expanded ? "ArrowUp": "ArrowDown")
            }
            
            Spacer()
        }
        .onTapGesture {
            if subItems.isEmpty {
                webViewModel.urlString = menuItem.link
                
                showMenu.value = false
            } else {
                withAnimation(.easeInOut(duration: Constants.PROMOTION_ANIMATION_DURATION)) {
                    expanded.toggle()
                }
            }
        }
        
        if !subItems.isEmpty {
            if expanded {
                ForEach(subItems) { subItem in
                    Spacer().frame(height: 12)

                    Text(subItem.name.trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(subItemTextFont)
                        .foregroundColor(.jnsBlack)
                        .onTapGesture {
                            webViewModel.urlString = subItem.link
                            
                            showMenu.value = false
                        }
                }
            }
        }
        
        Spacer().frame(height: 12)
    }
}
