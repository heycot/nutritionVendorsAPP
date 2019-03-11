//
//  User.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/27/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

public class User {
    var id: Int
    var username: String
    var email: String
    var phone: String
    var password: String
    var birthday: Date
    var avatar: String
    var address: String
    var create_date: Date
    var status: Int
    
    
    init(id: Int, username: String, email: String, phone: String, password: String, birthday: Date, avatar: String, address: String, create_date: Date, status: Int) {
        self.id = id
        self.username = username
        self.email = email
        self.phone = phone
        self.password = password
        self.birthday = birthday
        self.avatar = avatar
        self.address = address
        self.create_date = create_date
        self.status = status
    }
    
    convenience init() {
        self.init(id: 0, username: "", email: "", phone: "", password: "", birthday: Date(), avatar: "", address: "", create_date: Date(), status: 0)
    }
}
