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
                
                let shopItems = try JSONDecoder().decode([ShopItemResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shopItems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    
    }
    
    func getOneItem(id: Int, completion: @escaping (ShopItemResponse?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.getOneById.rawValue + "/\(id)"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", authToken: nil, jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopItem = try JSONDecoder().decode(ShopItemResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(shopItem)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func searchItem(searchText: String, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.searchOne.rawValue
        let body = ["text" : searchText]
        do {
            let jsonBody = try JSONEncoder().encode(body)
            
            NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", authToken: nil, jsonBody: jsonBody, parameters: nil) { (data ) in
                
                guard let data = data else {return}
                do {
                    
                    let shopItems = try JSONDecoder().decode([ShopItemResponse].self, from: data)
                    DispatchQueue.main.async {
                        completion(shopItems)
                    }
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
            }
            
        } catch let jsonErr {
            print("exception json: \(jsonErr)")
        }
    }
    
}