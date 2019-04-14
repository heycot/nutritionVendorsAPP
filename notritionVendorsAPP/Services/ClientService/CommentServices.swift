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
    
    
    func addNewComment(comment: Comment, completion: @escaping (CommentResponse?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.addNew.rawValue
        
        let body = ["id": 0,
                    "title": comment.title,
                    "content": comment.content,
                    "rating": comment.rating,
                    "create_date": nil,
                    "status": 1,
                    "shopitem_id": comment.shopItem_id,
                    "user_id": 0] as [String : Any?]
        
//        let josn = try? JSONSerialization.jsonObject(with: body, options: [])
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "POST", jsonBody: jsonData, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let comment = try JSONDecoder().decode(CommentResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(comment)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
        
}
