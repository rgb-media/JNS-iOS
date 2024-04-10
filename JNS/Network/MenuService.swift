//
//  MenuService.swift
//  JNS
//
//  Created by Adrian Picui on 04.04.2024.
//

import Foundation
import Alamofire
import Combine

protocol MenuServiceProtocol {
    func fetchMenu() -> AnyPublisher<DataResponse<MenuModel, AFError>, Never>
}

class MenuService {
    static let shared: MenuServiceProtocol = MenuService()
    private init() { }
}

extension MenuService: MenuServiceProtocol {
    func fetchMenu() -> AnyPublisher<DataResponse<MenuModel, AFError>, Never> {
        let url = URL(string: Constants.MENU_URL)!
        
        let headers: HTTPHeaders? = ["app-secret": "e6f8bc2ceaa3206dc0ccc671326727db"]
        
        return AF.request(url, method: .get, headers: headers)
            .validate()
            .publishDecodable(type: MenuModel.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
