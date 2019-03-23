//
//  LocationResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/20/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

struct LocationResponse: Decodable {
    var id : Int?
    var name: String?
    var address: String?
    var longitude: Double?
    var latitude: Double?
    
    init(id: Int, name: String, address: String, longitude: Double, latitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init() {
        self.init(id: 0, name: "", address: "", longitude: 0.0, latitude: 0.0)
    }
}
