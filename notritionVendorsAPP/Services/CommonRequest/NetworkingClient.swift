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
    
//    func requestAPI(url: URLConvertible,  body: Parameters? , header: HTTPHeaders?, completion: (Bool, Any?, Error?) -> Void){
////        let url = URL(string: urlString)
//
////        Alamofire.request(URLConvertible, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: HTTPHeaders?)
//
//        let urlCon = URLConvertible.asURL(url)
//
////        Alamofire.request(url: urlCon, method: .get, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
////            response in
////            if let data = response.result.data {
////                completion(true, data, nil)
////            } else {
////
////                debugPrint(response.result.error as Any)
////                completion(false, nil, error)
////            }
////        }
//
////        Alamofire.request(urlCon, method: HTTPMethod.get, parameters: body, encoding: JSONEncoding.default, headers: header)
//
//    }
    
    func request(urlStr: String, parameters: Parameters?, completion: @escaping ([AnyObject]?) -> Void) {
        print("url : \(urlStr)")
        guard let url = URL(string: urlStr) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url,
                          method: .get,
                          parameters: parameters)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(nil)
                    return
                }
                guard let data = response.result.value  as! [AnyObject]? else {
                    completion(nil)
                    return
                }
                
                completion(data)
        }
    }
    
//    func fetchAllRooms(completion: @escaping ([Any]?) -> Void) {
//        guard let url = URL(string: "http://localhost:5984/rooms/_all_docs?include_docs=true") else {
//            completion(nil)
//            return
//        }
//        Alamofire.request(url,
//                          method: .get,
//                          parameters: ["include_docs": "true"])
//            .validate()
//            .responseJSON { response in
//                guard response.result.isSuccess else {
////                    print("Error while fetching remote rooms: \(String(describing: response.result.error)"))
//                        completion(nil)
//                    return
//                }
//
//                guard let value = response.result.value as? [String: Any],
//                    let rows = value["rows"] as? [[String: Any]] else {
//                        print("Malformed data received from fetchAllRooms service")
//                        completion(nil)
//                        return
//                }
//
////                let rooms = rows.flatMap { roomDict in return RemoteRoom(jsonData: roomDict) }
////                completion(rooms)
//        }
//    }
//    rows

    
//    func requestApiUrlSession(urlStr: String, header: String, completion: @escaping CompletionHander) {
//        guard let url = URL(string: urlStr) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            if err != nil {
//                completion(false)
//            } else {
//                completion(true)
//            }
//
//        }.resume()
//    }
//
//    func getAPI(urlString: String, body: [String], header: String) -> DataResponse<Any>{
//
//        Alamofire.request(url: urlString, method: .get, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
//            response in
//            return response
//        }
//    }
//
//
//    func postAPI(urlString: String, body: String, header: String)  -> DataResponse<Any>{
//
//        Alamofire.request(url: urlString, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
//            response in
//            return response
//        }
//    }
    
}
