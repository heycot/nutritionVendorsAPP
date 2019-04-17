//
//  ShopResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
struct ShopResponse: Decodable {
    var id: Int?
    var name: String?
    var rating: Double?
    var time_open: String?
    var time_close: String?
    var create_date: Date?
    var status: Int?
    var phone: String?
    var avatar: String?
    var sell: String?
    var distance: String?
    var location: LocationResponse?
    
    init(id: Int, name: String, rating: Double, time_open: String, time_close: String, create_date: Date, status: Int, phone: String, avatar: String, sell: String, distance: String, location: LocationResponse) {
        self.id = id
        self.name = name
        self.rating = rating
        self.time_open = time_open
        self.time_close = time_close
        self.create_date = create_date
        self.status = status
        self.phone = phone
        self.avatar = avatar
        self.sell = sell
        self.distance = distance
        self.location = location
    }
    
    init(){
        self.init(id: 0, name: "", rating: 0.0, time_open: "", time_close: "", create_date: Date(), status: 1, phone: "", avatar: "", sell: "", distance: "", location: LocationResponse())
    }
    
    init(name: String, longitude: Double, latitude: Double) {
        self.init()
        self.location = LocationResponse(longitude: longitude, latitude: latitude)
        self.name = name
    }
}
