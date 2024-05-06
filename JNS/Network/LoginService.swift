//
//  LoginService.swift
//  JNS
//
//  Created by Adrian Picui on 02.05.2024.
//

import Foundation
import Alamofire
import Combine

protocol LoginServiceProtocol {
    func sendLogin(email: String, password: String) -> AnyPublisher<DataResponse<LoginModel, AFError>, Never>
}

class LoginService {
    static let shared: LoginServiceProtocol = LoginService()
    private init() { }
}

extension LoginService: LoginServiceProtocol {
    func sendLogin(email: String, password: String) -> AnyPublisher<DataResponse<LoginModel, AFError>, Never> {
        let url = URL(string: Constants.LOGIN_URL)!
        
        let headers: HTTPHeaders? = ["app-secret": Constants.APP_SECRET]
        let parameters: Parameters? = ["email": email, "password": password]

        return AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: LoginModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
