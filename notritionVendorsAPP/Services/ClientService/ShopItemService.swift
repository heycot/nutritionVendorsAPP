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
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
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
        let urlStr = BASE_URL + ShopItemAPI.getOneById.rawValue + "/\(id)"  + "/1" 
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET",  jsonBody: nil, parameters: nil) { (data ) in
            
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
    
    func searchItem(searchText: String, completion: @escaping ([SearchResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.searchOne.rawValue  + "/" + searchText
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let shopItems = try JSONDecoder().decode([SearchResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(shopItems)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    

    func findAllLoved(offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.getAllLoved.rawValue + "/" + String(offset)

        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
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
    
    func findAllByCategory(categoryId: Int, offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.findByCategory.rawValue + "/" + String(categoryId) + "/" + String(offset)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
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
    
    func findAllByShop(shopId: Int, offset: Int, completion: @escaping ([ShopItemResponse]?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.findByShop.rawValue + "/" + String(shopId) + "/" + String(offset) + "/1"
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
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
    
    func getOneDTOItem(id: Int, completion: @escaping (ShopItemResponse?) -> Void) {
        let urlStr = BASE_URL + ShopItemAPI.getOneDTO.rawValue + "/" + String(id)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
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
    
    
}
