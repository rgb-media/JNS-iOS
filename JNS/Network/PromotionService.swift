//
//  PromotionService.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

import Foundation
import Alamofire
import Combine

protocol PromotionServiceProtocol {
    func fetchPromotion() -> AnyPublisher<DataResponse<PromotionModel, AFError>, Never>
}

class PromotionService {
    static let shared: PromotionServiceProtocol = PromotionService()
    private init() { }
}

extension PromotionService: PromotionServiceProtocol {
    func fetchPromotion() -> AnyPublisher<DataResponse<PromotionModel, AFError>, Never> {
        let url = URL(string: Constants.PROMOTION_URL)!
        
        let headers: HTTPHeaders? = ["app-secret": "e6f8bc2ceaa3206dc0ccc671326727db"]

        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: PromotionModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
