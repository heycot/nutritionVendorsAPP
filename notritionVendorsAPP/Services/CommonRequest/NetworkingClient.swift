//
//  Requets.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient {

    public static let shared = NetworkingClient()
    
    func getDataImage(from url: URL, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: url){ data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong with url")
                return
            }
            
            completion(data)
        }.resume()
    }
    
    func requestJson(urlStr: String, method: String, authToken: String?, jsonBody: Data?, parameters: Parameters?, completion: @escaping (Data?) -> Void) {
        
        let url = URL(string: urlStr)
        guard let urlRequest = url else { return }
        
        var request = URLRequest(url: urlRequest)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if authToken != nil {
            request.addValue(authToken!, forHTTPHeaderField: "Authorization")
        }
        
        if jsonBody != nil {
            
            request.httpBody = jsonBody!
                        
//            do {
////                 let jsonBody = try JSONEncoder().encode(newpost)
//                request.httpBody = jsonBody!
////               print(jsonBody)
//            } catch let error{
//                print("some error with josn body: \(error)")
//            }
        }
        
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong with url")
                return
            }
            
            completion(data)
            }.resume()
    }
    
//    func request(urlStr: String, parameters: Parameters?, completion: @escaping ([Data]?) -> Void) {
//        print("url : \(urlStr)")
//        guard let url = URL(string: urlStr) else {
//            completion(nil)
//            return
//        }
//        
//        Alamofire.request(url,
//                          method: .get,
//                          parameters: parameters)
//            .responseJSON { response in
//                guard response.result.isSuccess else {
//                    completion(nil)
//                    return
//                }
//                guard let data = response.result.value  as! [Data]? else {
//                    completion(nil)
//                    return
//                }
//
//                completion(data)
//        }
//    }
    
}
