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
    var shop_name: String?
    var avatar: String?
    var love_status: Int?
    var address: String?
    var distance: String?
    var shop: ShopResponse?
    var documents: [DocumentResponse]?
    var comments: [CommentResponse]?
    
    // Constructor.
    init(id: Int, price: Double, status: Int, rating: Double, comment_number: Int, favorites_number: Int, name: String, shop_name: String, avatar: String, love_status: Int, address: String, distance: String, shop: ShopResponse, documents: [DocumentResponse], comments: [CommentResponse]) {
        self.id = id
        self.price = price
        self.status = status
        self.rating = rating
        self.comment_number = comment_number
        self.favorites_number = favorites_number
        self.name = name
        self.shop_name = shop_name
        self.avatar = avatar
        self.love_status = love_status
        self.address = address
        self.distance = distance
        self.shop = shop
        self.documents = documents
        self.comments = comments
    }
    
    init() {
        self.init(id: 0, price: 0.0, status: 1, rating: 0, comment_number: 0, favorites_number: 0, name: "", shop_name: "", avatar: "", love_status: 0, address: "", distance: "", shop: ShopResponse(), documents: [], comments: [])
    }
}
