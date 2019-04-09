//
//  CommentServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/9/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


class CommentServices {
    
    public static let shared = CommentServices()
    
    
    //    var favorites : [FavoritesResponse] = [FavoritesResponse]()
    
    func addNewComment(completion: @escaping ([CommentResponse]?) -> Void) {
//        let urlStr = BASE_URL + FavoritesAPI.getAllByUser.rawValue
//        
//        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
//            
//            guard let data = data else {return}
//            do {
//                
//                let favorites = try JSONDecoder().decode([FavoritesResponse].self, from: data)
//                DispatchQueue.main.async {
//                    completion(favorites)
//                }
//            } catch let jsonError {
//                print("Error serializing json:", jsonError)
//            }
//        }
    }
        
}

