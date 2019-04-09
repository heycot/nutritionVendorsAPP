//
//  FavoritesService.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

class FavoritesService {
    
    public static let shared = FavoritesService()
    
    
//    var favorites : [FavoritesResponse] = [FavoritesResponse]()
    
    func getAllByUser(completion: @escaping ([FavoritesResponse]?) -> Void) {
        let urlStr = BASE_URL + FavoritesAPI.getAllByUser.rawValue
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in

            guard let data = data else {return}
            do {

                let favorites = try JSONDecoder().decode([FavoritesResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(favorites)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
        
    }
    
    func checkStatus(shopItemId: Int, completion: @escaping (FavoritesResponse?) -> Void) {
        let urlStr = BASE_URL + FavoritesAPI.checkStatus.rawValue + "/" + String(shopItemId)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            
            
            do {

                let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(favorite)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
        
    }
    
    
    func loveOne(shopItemId: Int, completion: @escaping (FavoritesResponse?) -> Void) {
        let urlStr = BASE_URL + FavoritesAPI.loveOne.rawValue + "/" + String(shopItemId)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(favorite)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    
//
//    func isFavoriteShopItem(shopitem_id: Int) -> Int {
//        for i in 0 ..< favorites.count {
//            if shopitem_id == favorites[i].shopitem_id {
//                return favorites[i].status!
//            }
//        }
//
//        return 0
//    }
//
//    func updateFavoriteItem(shopitem_id: Int, status: Int) -> Bool {
//        for i in 0 ..< favorites.count {
//            if shopitem_id == favorites[i].shopitem_id {
//                favorites[i].status = status
//                return true
//            }
//        }
//
//        return false
//    }
//
//    func addNewFavorite(fa: FavoritesResponse) {
//        favorites.append(fa)
//    }
}
