//
//  ShopServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import CoreLocation



class ShopServices {
    
    public static let shared = ShopServices()
    
    func getNewestShop(offset: Int, completion: @escaping ([ShopResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopAPI.newest.rawValue + "/\(offset)"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shops = try JSONDecoder().decode([ShopResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shops)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func getNearestShop(latitude: Double, longitude: Double, offset: Int, completion: @escaping ([ShopResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopAPI.nearest.rawValue + "/" + String(latitude) + "/" + String(longitude) + "/\(offset)"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shops = try JSONDecoder().decode([ShopResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shops)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func getOne(id: Int, completion: @escaping (ShopResponse?) -> Void) {
        let urlStr = BASE_URL + ShopAPI.getOne.rawValue + "/" + String(id)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shop = try JSONDecoder().decode(ShopResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(shop)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func getDistance(shop: ShopResponse, currlocation: CLLocation) -> String {
        var distance =  ""
        guard let location = shop.location else { return "" }
        
        let coordinate₀ = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
        
        let distanceInMeters = coordinate₀.distance(from: currlocation)
        if distanceInMeters < 1000 {
            distance = String(format: " Distance : %.2f ", distanceInMeters.inMiles()) + " M"
        } else {
            distance = String(format: " Distance : %.2f ", distanceInMeters.inKilometers()) + " KM"
        }
        
        return distance
    }
        
}
