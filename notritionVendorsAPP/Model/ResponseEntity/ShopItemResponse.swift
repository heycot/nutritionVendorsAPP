//
//  ShopResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct ShopItemResponse: Decodable{
    var id: Int?
    var price: Double?
    var status: Int?
    var rating: Double?
    var comment_number: Int?
    var favorites_number: Int?
    var name: String?
    var avatar: String?
    var shop: ShopResponse?
    var documents: [Document]?
    var comments: [Comment]?
    
    // Constructor.
    init(id: Int, price: Double, status: Int, rating: Double, comment_number: Int, favorites_number: Int, name: String, avatar: String, shop: ShopResponse, documents: [Document], comments: [Comment]) {
        self.id = id
        self.price = price
        self.status = status
        self.rating = rating
        self.comment_number = comment_number
        self.favorites_number = favorites_number
        self.name = name
        self.avatar = avatar
        self.shop = shop
        self.documents = documents
        self.comments = comments
    }
    
    init() {
        self.init(id: 0, price: 0.0, status: 1, rating: 0, comment_number: 0, favorites_number: 0, name: "", avatar: "", shop: ShopResponse(), documents: [], comments: [])
    }
}


//class ShopItemResponse : Decodable {
//    var id: Int?
//    var price: Double?
//    var status: Int?
//    var rating: Double?
//    var comment_number: Int?
//    var favorites_number: Int?
//    var name: String?
//    var avatar: String?
//    var shop: ShopResponse?
//    var documents: [Document]?
//    var comments: [Comment]?
//
//    // Constructor.
//    init(id: Int, price: Double, status: Int, rating: Double, comment_number: Int, favorites_number: Int, name: String, avatar: String, shop: ShopResponse, documents: [Document], comments: [Comment]) {
//        self.id = id
//        self.price = price
//        self.status = status
//        self.rating = rating
//        self.comment_number = comment_number
//        self.favorites_number = favorites_number
//        self.name = name
//        self.avatar = avatar
//        self.shop = shop
//        self.documents = documents
//        self.comments = comments
//    }
//
//    init() {
//        self.init(id: 0, price: 0.0, status: 1, rating: 0, comment_number: 0, favorites_number: 0, name: "", avatar: "", shop: ShopResponse(), documents: [], comments: [])
//    }
//}
//
