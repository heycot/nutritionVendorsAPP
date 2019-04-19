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
    case getRating = "shop-item/rating"
    case findByShop = "shop-item/shop"
    case getOneDTO = "shop-item/dto"
}

enum FavoritesAPI: String {
    case loveOne = "favorites/love"
    case getAllByUser = "favorites/user"
    case checkStatus = "favorites/check"
    case countByShopItem = "favorites/count"
}

enum CommentAPI: String {
    case addNew = "comment/add"
    case getByShopItem = "comment/shopitem"
    case countByShopItem = "comment/count"
}

enum CategoryAPI: String {
    case findAll = "category"
}

enum ShopAPI: String {
    case newest = "shop/newest"
    case nearest = "shop/nearest"
    case getOne = "shop"
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
    case addCommentBtn = "AddCommentBtnCell"
    case actionCell = "ActionCell"
    case mapCell = "MapCell"
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
    case shop = "ShopCell"
    case searchCell = "SearchCell"
    case categoryShopItemCell = "CategoryShopItemCell"
    case addCommentBtn = "AddCommentBtn"
    case actionCell = "ActionCell"
    case itemInShop = "ItemInShopCell"
    case mapCell = "MapCell"
}

enum SegueIdentifier: String {
    //detail storyboard
    case detailItem = "ViewDetalFoodID"
    case detailFoodToPhoto = "DetailFoodToPhoto"
    case photosToDetailPhoto = "PhotosToDetailPhoto"
    case detailFoodToLogin = "DetailFoodToLogin"
    case detailToLocation = "DetailToLocation"
    case detailToComment = "DetailToComment"
    case detailToShop = "DetailToItemInShop"
    case detailToDelivery = "DetailToDelivery"
    
    // hight rating
    case highRatingToCategory = "HaighRatingToCategory"
    case categoryToDetail = "CategoryToDetail"
    case highRatingToSearch = "HighRatingSearch"
    case highRatingToDetail = "HighRatingToDetail"
    
    //search
    case searchToDetaild = "SearchToDetaild"
    case searchToShop = "SearchToItemInShop"
    
    
    // shop
    case shopToSearch = "ShopSeachVC"
    case shopToGoogleMap = "ShopToGoogleMap"
    case shopToItemInShop = "ShopToItemInShop"
    
    case favoriteToDetail = "FavoritesToDetailSegue"
    case favoritesToLogIn = "FavoritesToLogInID"
    case favoritesToSearch = "FavoritesSearchVC"
}

enum StoryboardID : String {
    case loginLogout = "LoginLogoutStoryboardID"
}

// google map API key
//let GOOGLE_API_KEY = "AIzaSyAgIJ_N3H3LVx_afClZancU_0Ec6gjpUVA"
let GOOGLE_API_KEY = "AIzaSyDgqjGBtos0e_O0vVwlJ8jI8Fa-9eYAJz8"



enum Icon : String{
    case price_icon = "price-tag"
    case time_icon = "alarm-clock"
    case phone_icon = "call"
    case shop_icon = "shop"
    case address_icon = "placeholder"
    case category_icon = "grid"
    case picture = "picture"
}
