//
//  PromotionViewModel.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import Combine

class PromotionViewModel: ObservableObject {
    @Published var promotion = PromotionModel(img_full_url: "", title: "", registed_user_url: "", button_text: "", button_color: "")
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: PromotionServiceProtocol
    
    init(dataManager: PromotionServiceProtocol = PromotionService.shared) {
        self.dataManager = dataManager
        
        getPromotion()
    }
    
    func getPromotion() {
        PromotionService.shared.fetchPromotion()
            .sink { dataResponse in
                if dataResponse.error != nil {
                    print(dataResponse.error!)
                } else {
                    self.promotion = dataResponse.value!
                }
            }.store(in: &cancellableSet)
    }
}
