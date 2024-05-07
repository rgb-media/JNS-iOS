//
//  BrevoService.swift
//  JNS
//
//  Created by Adrian Picui on 20.04.2024.
//

import Foundation
import Alamofire
import Combine

protocol BrevoServiceProtocol {
    func registerEmail(email: String) -> AnyPublisher<DataResponse<BrevoModel, AFError>, Never>
}

class BrevoService {
    static let shared: BrevoServiceProtocol = BrevoService()
    private init() { }
}

extension BrevoService: BrevoServiceProtocol {
    func registerEmail(email: String) -> AnyPublisher<DataResponse<BrevoModel, AFError>, Never> {
        let url = URL(string: Constants.BREVO_URL)!
        
        let headers: HTTPHeaders? = ["content-type": "application/json",
                                     "api-key": Config.BREVO_API_KEY]
        let parameters: Parameters? = ["email": email]

        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: BrevoModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
