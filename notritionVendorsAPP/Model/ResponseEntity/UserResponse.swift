//
//  UserResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/23/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
class UserResponse:Decodable {
    var id: Int?
    var user_name: String?
    var email: String?
    var phone: String?
    var password: String?
    var birthday: Date?
    var avatar: String?
    var address: String?
    var create_date: Date?
    var status: Int?
    var shops: [ShopResponse]?
    
    
    init(id: Int, username: String, email: String, phone: String, password: String, birthday: Date, avatar: String, address: String, create_date: Date, status: Int, shops: [ShopResponse]) {
        self.id = id
        self.user_name = username
        self.email = email
        self.phone = phone
        self.password = password
        self.birthday = birthday
        self.avatar = avatar
        self.address = address
        self.create_date = create_date
        self.status = status
        self.shops = shops
    }
    
    convenience init() {
        self.init(id: 0, username: "", email: "", phone: "", password: "", birthday: Date(), avatar: "", address: "", create_date: Date(), status: 0, shops: [])
    }
}
