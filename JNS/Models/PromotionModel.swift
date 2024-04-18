//
//  PromotionModel.swift
//  JNS
//
//  Created by Adrian Picui on 03.04.2024.
//

struct PromotionModel: Decodable {
    let img_full_url: String
    let title: String
    let registed_user_url: String
    let button_text: String?
    let button_color: String?
}
