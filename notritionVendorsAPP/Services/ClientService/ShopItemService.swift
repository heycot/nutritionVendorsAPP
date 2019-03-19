//
//  ShopItemService.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class ShopItemService {
    
    public static let shared = ShopItemService()
    
    func getHighRatingItem(offset: Int) {
//        let bodyPara: [String : Any]    = [ "content": ""]
        let urlStr = BASE_URL + ShopItemAPI.getHighRating.rawValue
        
        NetworkingClient.shared.request(urlStr: urlStr, parameters: nil) { (data ) in
//            print("total data : \(data?.count)")
            
//            guard let myData = data else {return}
//            print(data)
//
            do {
                print(data)
//                let string = data["Optiona"]
//                print(string)
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let jsonString = String(data: jsonData, encoding: .utf8)
                
//                print(jsonString["Optional"])
                
//                let shopitems = try! JSONDecoder().decode(ShopItemResponse.self, from: myData)
                let shopItems = try! JSONDecoder().decode(ShopItemResponse.self, from: jsonData)
                print(shopItems)
                
//                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]?
            } catch let jsonError {
                print(jsonError)
            }
//
//            if let myData = data {
//                let shopitems = try JSONDecoder().decode(ShopItemResponse.self, from: data)
//            }
        }
    
    }
    
}
