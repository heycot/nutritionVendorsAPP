//
//  ShopResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct ShopItemResponse : Decodable{
    let id: Int?
    let price: Double?
    let status: Int?
    let rating: Double?
    let comment_number: Int?
    let favorites_number: Int?
    let name: String?
    let avatar: String?
    
//    init(json: [String: Any]) {
//        id = json["id"] as? Int ?? -1
//        price = json["price"] as? Double ?? 0
//        status = json["status"] as? Int ?? 1
//        rating = json["rating"] as? Double ?? 3.0
//        comment_number = json["comment_number"] as? Int ?? 0
//        favorites_number = json["favorites_number"] as? Int ?? 0
//        name = json["name"] as? String ?? ""
//        avatar = json["avatar"] as? String ?? ""
//    }
}
