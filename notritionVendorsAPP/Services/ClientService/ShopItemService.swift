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
    
    func getHighRatingItem(offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.getHighRating.rawValue + "/\(offset)"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", authToken: nil, jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopitems = try JSONDecoder().decode([ShopItemResponse].self, from: data)
                for item in shopitems {
                    print(item.name!)
                }

                DispatchQueue.main.async {
                    completion(shopitems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    
    }
    
}
