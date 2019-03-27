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
//let BASE_URL        = "https://nutrition-vendors.herokuapp.com/api/"
let BASE_URL        = "http://192.168.21.59:3001/api/"
let BASE_URL_IMAGE  = "http://192.168.21.59:3001/images/"
//let BASE_URL        = "http://192.168.137.1:3001/api/"
//let BASE_URL_IMAGE  = "http://192.168.137.1:3001/images/"

// User URL enum
enum UserAPI: String {
    case register    = "user/register"
    case login       = "user/login"
}

enum ShopItemAPI: String {
    case getHighRating = "shop-item/high-rating/offset"
    case getOneById = "shop-item"
    case searchOne = "shop-item/search"
}


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

let APP_COLOR = UIColor(red: CGFloat(44/255.0), green: CGFloat(166/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(0.75))


enum CellClassName: String {
    case generalInfor   = "GeneralInforItemCell"
    case generalValue   = "GeneralValueCell"
    case listComment    = "ViewCommentCell"
    case addNewComment  = "AddNewCommentCell"
    
}

enum CellIdentifier: String {
    case generalInfor = "GeneralInforItemCell"
    case generalvalue = "GeneralValueCell"
    case listComment = "ListCommentCell"
    case newComment = "NewCommentCell"
    case imageCollectionCell = "ImageCollectionCell"
}



