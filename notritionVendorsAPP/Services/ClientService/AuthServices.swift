//
//  AuthServices.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices {
    static let instance = AuthServices()
    
    let defaults = UserDefaults.standard
    
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(user: User, completion: @escaping CompletionHander) {
        
//        let lowerCaseEmail = user.email
        
        let body: [String: Any] = [
            "user": user
        ]
        
//        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER) .responseString {
//            (response) in
//
//            if response.result.error == nil {
//                completion(true)
//            } else {
//                completion(false)
//
//                debugPrint(response.result.error as Any)
//            }
//        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHander) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email" : lowerCaseEmail,
            "password": password
        ]
        
//
//        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON {
//            (response) in
//
////            do {
//                if response.result.error == nil {
//                    guard let data = response.data else { return }
//                    let json = try? JSON(data: data)
//                    self.userEmail = json!["username"].stringValue
//                    self.authToken = json!["token"].stringValue
//
//
//                    self.isLoggedIn = true
//                    completion(true)
//                } else {
//                    completion(false)
//                    debugPrint(response.result.error as Any)
//                }
////            } catch let error as NSError{
////                print("exception error swiftJson log-in: \(error)")
////            }
//        }
    }
    
    func createUser(email: String, password: String, completion: @escaping CompletionHander) {
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
//        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_AUTH).responseJSON {
//            (response) in
//
//            if response.result.error == nil {
//                completion(true)
//            } else{
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//        }
    }

    
}
