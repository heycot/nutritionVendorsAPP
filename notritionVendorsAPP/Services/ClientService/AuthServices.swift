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
        
    let defaults = Foundation.UserDefaults.standard
    
    
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
        
    }
    
    func loginUser(email: String, password: String, completion: @escaping (UserResponse?) -> Void) {
        
        let lowerCaseEmail = email.lowercased()
        let urlStr = BASE_URL + UserAPI.login.rawValue
        
//        do {
            let user = User()
            user.email = lowerCaseEmail
            user.password = password
            let jsonBody = NSKeyedArchiver.archivedData(withRootObject: user)
            
            NetworkingClient.shared.requestJson(urlStr: urlStr, method: "POST", authToken: nil, jsonBody: jsonBody, parameters: nil) { (data ) in
                
                guard let data = data else {return}
                do {
                    
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(userResponse)
                    }
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                }
            }
//        } catch let encoderError {
//            print(encoderError)
//        }
        
    }
    
    func createUser(email: String, password: String, completion: @escaping CompletionHander) {
        
    }
    
//    func getUserJsonBody(user: User) -> Data? {
//        let body = [
//            "id" : user.id,
//            "username" : user.username,
//            "email" : user.email,
//            "phone" : user.phone,
//            "password" : user.password,
//            "birthday" : user.birthday,
//            "avatar" : user.avatar,
//            "address": user.address,
//            "create_date": user.create_date,
//            "status": user.status
//            ] as [String : Any]
//
//        do {
//            let jsonBody = try JSONEncoder().encode(body)
//            return jsonBody
//        } catch  let jsonError {
//            print(jsonError)
//        }
//
//    }

    
}
