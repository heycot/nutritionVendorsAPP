//
//  SearchResponse.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/16/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation

struct SearchResponse: Decodable, Hashable{
    var entity_id: String?
    var entity_name: String?
    var address: String?
    var is_shop: Int?
    var avatar: String?
    var longitude: Double?
    var latitude: Double?
    
    var distance: Double? {
        if (AuthServices.instance.currentLocation != nil) {
            let coordinate₀ = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
            return coordinate₀.distance(from: AuthServices.instance.currentLocation!)
        }
        return nil
    }
    
    
    init( entity_id: String, entity_name: String, address: String, is_shop: Int, avatar: String) {
        self.entity_id = entity_id
        self.entity_name = entity_name
        self.address = address
        self.is_shop = is_shop
        self.avatar = avatar
    }
    
    init() {
        self.init(entity_id: "", entity_name: "", address: "", is_shop: 0, avatar: "")
    }
    
    func getDistance(currlocation: CLLocation?) -> String {
        var distance =  ""
        if self.latitude == 0.0, self.longitude == 0.0 { return "Unknown" }
        guard let userLocation = currlocation else {  return "Unknown"  }
        
        let coordinate₀ = CLLocation(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
        
        let distanceInMeters = coordinate₀.distance(from: userLocation)
        if distanceInMeters < 1000 {
            distance = String(format: " %.2f ", distanceInMeters) + " M"
        } else {
            distance = String(format: " %.2f ", distanceInMeters.inKilometers()) + " KM"
        }
        
        return distance
    }
    
}

