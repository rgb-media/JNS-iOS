//
//  MenuViewModel.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import Foundation
import Combine

class MenuViewModel: ObservableObject {
    @Published var menu = [MenuItem]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: MenuServiceProtocol
    
    init(dataManager: MenuServiceProtocol = MenuService.shared) {
        self.dataManager = dataManager
        
        getMenu()
    }
    
    func getMenu() {
        MenuService.shared.fetchMenu()
            .sink { dataResponse in
                if dataResponse.error != nil {
                    print(dataResponse.error!)
                } else {
                    if let dictionary = dataResponse.value, let menu2 = dictionary["menu_id_2"] {
                        self.menu = menu2.sorted(by: { $0.0 < $1.0 }).map({ $0.1 })
                    }
                }
            }.store(in: &cancellableSet)
    }
}
