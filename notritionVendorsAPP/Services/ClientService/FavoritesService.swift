//
//  FavoritesService.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/4/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase

class FavoritesService {
    
    public static let shared = FavoritesService()
    
    func checkLoveStatus(shopItemID: String, completion: @escaping (Bool?) -> Void) {
        var result  = false
        let userID = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        let docRef = db.collection("favorites").whereField("shop_item_id", isEqualTo: shopItemID)
                                                .whereField("user_id", isEqualTo: userID as Any)
        
        docRef.getDocuments(completion: { (document, error) in
            if let document = document {
                
                for favoriteDoct in document.documents{
                    let jsonData = try? JSONSerialization.data(withJSONObject: favoriteDoct.data() as Any)
                    
                    do {
                        let favorite = try JSONDecoder().decode(FavoritesResponse.self, from: jsonData!)
                        
                        result = favorite.status == 0 ? false : true
                    }
                    catch let jsonError {
                        print("Error serializing json:", jsonError)
                    }
                }
                DispatchQueue.main.async {
                    completion(result)
                }
                
            } else {
                print("User have no profile")
            }
        })
    }
    
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
    
    
}
