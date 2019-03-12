//
//  Constant.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation

typealias CompletionHander = (_ Success: Bool) -> ()

// Base url
let BASE_URL        = "https://nutrition-vendors.herokuapp.com/api/"

// User URL Constants
let URL_REGISTER    = "\(BASE_URL)user/register"
let URL_LOGIN       = "\(BASE_URL)user/login"


//Item URL Constant
let URL_HIGH_RATING = "\(BASE_URL)shop-item/high-rating"


//user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


// Header
let HEADER = [
    "Content-Type" : "application/json, charset=utf-8"
]


let HEADER_AUTH = [
    "Authorization": "Bearer \(AuthServices.instance.authToken)",
    "Content-Type" : "application/json, charset=utf-8"
]



// Constant color

let appColor = UIColor(red: CGFloat(29/255.0), green: CGFloat(122/255.0), blue: CGFloat(139/255.0), alpha: CGFloat(0.5))

