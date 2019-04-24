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
    
    func editComment(comment: Comment, completion: @escaping (CommentResponse?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.edit.rawValue
        
        let body = ["id": comment.id,
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
    
    func getComments(shopitemId: Int, offset: Int, completion: @escaping ([CommentResponse]?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.getByShopItem.rawValue + "/" + String(shopitemId) + "/" + String(offset)
        
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let comment = try JSONDecoder().decode([CommentResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(comment)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func getReviewOfUser(shopitemId: Int, completion: @escaping (CommentResponse?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.getUserComment.rawValue  + "/" + String(shopitemId)
        
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
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
    
    func getReviewsDTOOfUser(offset: Int, completion: @escaping ([CommentDTOResponse]?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.getUserCommentDTO.rawValue  + "/" + String(offset)
        
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let comment = try JSONDecoder().decode([CommentDTOResponse].self, from: data)
                DispatchQueue.main.async {
                    completion(comment)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func deleteOne(id: Int, completion: @escaping (Int?) -> Void) {
        let urlStr = BASE_URL + CommentAPI.deleteOne.rawValue  + "/" + String(id)
        
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            DispatchQueue.main.async {
                
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let intStr = stringInt ?? "0"
                let int = Int.init(intStr)
                
                completion(int)
            }
        }
    }
        
}

