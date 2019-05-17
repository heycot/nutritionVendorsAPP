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
import CoreLocation
import UIKit

class AuthServices {
    static let instance = AuthServices()
        
    let defaults = Foundation.UserDefaults.standard
    var currentLocation : CLLocation? // = CLLocation(latitude: 16.056214, longitude:  108.217154)
    
    
    var listitem = [ItemF]()
    var listshop = [ShopF]()
    var cate = [Cate]()
    
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
    
    
    func registerUser(user: User, image: UIImage, completion: @escaping (UserResponse?) -> Void) {
        var urlStr = BASE_URL + UserAPI.register.rawValue
        
        let body = ["id": 0,
                    "user_name": user.name,
                    "email": user.email,
                    "phone": user.phone,
                    "password": user.password,
                    "birthday": nil,
                    "address": "",
                    "avatar": user.avatar,
                    "create_date": nil,
                    "status": 1,
                    "token": ""
            ] as [String : Any?]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let imgDataEncode = imgData.base64EncodedData()
        
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "POST", jsonBody: jsonData, parameters: nil) { (data) in
            guard let data = data else {return}
            do {
                
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                
                DispatchQueue.main.async {
                    urlStr = BASE_URL + "/user/upload"
                    NetworkingClient.shared.uploadImage(urlStr: urlStr, method: "POST", jsonBody: nil, fileData: imgDataEncode, parameters: nil) { (data) in
                        
                        guard data != nil else {return}
                        
                        DispatchQueue.main.async {
                            completion(userResponse)
                        }
                    }
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (UserResponse?) -> Void) {
        
        let lowerCaseEmail = email.lowercased()
        let urlStr = BASE_URL + UserAPI.login.rawValue
        
        let body = ["id": 0,
                    "user_name": "",
                    "email": lowerCaseEmail,
                    "phone": "",
                    "password": password,
                    "birthday": nil,
                    "address": "",
                    "avatar": "",
                    "create_date": nil,
                    "status": 1,
                    "token": ""] as [String : Any?]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "POST", jsonBody: jsonData, parameters: nil) { (data ) in

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
    }
    
    func getInforUser( completion: @escaping (UserResponse?) -> Void) {
        
        let urlStr = BASE_URL + UserAPI.getInfor.rawValue
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            do {
                
                let decoder = JSONDecoder()
                let userResponse = try decoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(userResponse)
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }
    }
    
    func editInfor(user: User, dateStr: String, completion: @escaping (UserResponse?) -> Void) {
        
        let urlStr = BASE_URL + UserAPI.editInfor.rawValue + "/\(dateStr)"
        
        let body = ["id": 0,
                    "name": user.name,
                    "email": "",
                    "phone": user.phone,
                    "password": "",
                    "birthday": dateStr,
                    "address": user.address,
                    "avatar": "",
                    "create_date": nil,
                    "status": 1,
                    "token": ""] as [String : Any?]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "POST", jsonBody: jsonData, parameters: nil) { (data ) in
            
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
    }
    
    func checkPassword(pass: String, completion: @escaping (Int?) -> Void) {
        
        let urlStr = BASE_URL + UserAPI.checkPass.rawValue + "/" + pass
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            DispatchQueue.main.async {
                
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let inStr = stringInt ?? "0"
                let int = Int.init(inStr)
                
                completion(int)
            }
        }
    }
    
    func changePassword(pass: String, completion: @escaping (Int?) -> Void) {
        
        let urlStr = BASE_URL + UserAPI.changePass.rawValue + "/" + pass
        
        NetworkingClient.shared.requestJson(urlStr: urlStr, method: "GET", jsonBody: nil, parameters: nil) { (data ) in
            
            guard let data = data else {return}
            DispatchQueue.main.async {
                
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                let inStr = stringInt ?? "0"
                let int = Int.init(inStr)
                
                completion(int)
            }
        }
    }
    
    func saveUserLogedIn(user : UserResponse?) {
        isLoggedIn = true
        authToken = user!.token ?? ""
        authToken = user!.email ?? ""
    }
    
}
