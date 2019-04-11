//
//  Constant.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionHander = (_ Success: Bool) -> ()

// Base url
//let BASE_URL        = "https://nutrition-vendors.herokuapp.com/api/"
//let BASE_URL        = "http://192.168.21.59:3001/api/"
//let BASE_URL_IMAGE  = "http://192.168.21.59:3001/images/"
let BASE_URL          = "http://192.168.21.59:3000/api/"
let BASE_URL_IMAGE    = "http://192.168.21.59:3000/images/"
//let BASE_URL        = "http://192.168.137.1:3001/api/"
//let BASE_URL_IMAGE  = "http://192.168.137.1:3001/images/"

// User URL enum
enum UserAPI: String {
    case register    = "user/signup"
    case login       = "user/login"
}

enum ShopItemAPI: String {
    case getHighRating = "shop-item/high-rating/offset"
    case getOneById = "shop-item"
    case searchOne = "shop-item/search"
    case getAllLoved = "shop-item/love"
    case findByCategory = "shop-item/category"
}

enum FavoritesAPI: String {
    case loveOne = "favorites/love"
    case getAllByUser = "favorites/user"
    case checkStatus = "favorites/check"
}

enum CommentAPI: String {
    case addNew = "comment/add"
}

enum CategoryAPI: String {
    case findAll = "category"
}


//user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "email"


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

let APP_COLOR_35 = UIColor(red: CGFloat(44/255.0), green: CGFloat(166/255.0), blue: CGFloat(172/255.0), alpha: CGFloat(0.15))


enum CellClassName: String {
    case generalInfor   = "GeneralInforItemCell"
    case generalValue   = "GeneralValueCell"
    case listComment    = "ViewCommentCell"
    case addNewComment  = "AddNewCommentCell"
    case category       = "CategoryCell"
    case headerCollection = "HeaderView"
}

enum CellIdentifier: String {
    case generalInfor = "GeneralInforItemCell"
    case generalvalue = "GeneralValueCell"
    case listComment = "ListCommentCell"
    case newComment = "NewCommentCell"
    case imageCollectionCell = "ImageCollectionCell"
    case photoItem = "PhotoCell"
    case DetailPhoto = "DetailPhotoCell"
    case favoritesItem = "FavoritesCellID"
    case category = "CategoryCellID"
    case highRatingItem = "ItemCell"
    case headerCollection = "HeaderCellID"
}

enum SegueIdentifier: String {
    case detailItem = "ViewDetalFoodID"
    case photosItem = "ViewPhotosItemID"
    case shopLocation = "ShopLocationID"
    case viewDetailPhoto = "ViewDetailPhoto"
    case loginLogout = "LoginLogoutSegueID"
    case favoriteToDetail = "FavoritesToDetailSegue"
    case favoritesToLogIn = "FavoritesToLogInID"
}

enum StoryboardID : String {
    case loginLogout = "LoginLogoutStoryboardID"
}

// google map API key
let GOOGLE_API_KEY = "AIzaSyAgIJ_N3H3LVx_afClZancU_0Ec6gjpUVA"


