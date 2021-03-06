//
//  StringLibrary.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/12/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    // check username is valid or not
    //    No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
    //    Only letters, underscores and numbers allowed
    //    Length should be 20 characters max and 6 characters minimum
    func isValidUserName() -> Bool {
        let RegEx = "\\w{4,20}"
        let regex = try! NSRegularExpression(pattern: RegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    //check phone number is valid or not
    //only number and must 10 digital
    func isValidPhone() -> Bool {
        let PHONE_REGEX = "^[0][1-9]\\d{8}$|^[+84][1-9]\\d{8}$"
        let regex = try! NSRegularExpression(pattern: PHONE_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    // check password
    // Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character
//    func isValidPassword(input: String) {
//        let PASS_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
//        let passTest = NSPredicate(format: "SELF MATCHES %@", PASS_REGEX)
//        let result =  passTest.evaluateWithObject(value)
//        return result
//    }
    
    func isValidPassword() -> Bool {
        let PASS_REGEX  = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let regex = try! NSRegularExpression(pattern: PASS_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        
    }
    
    // check username is valid or not
    //    No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
    //    Only letters, underscores and numbers allowed
    func isValidString() -> Bool {
        let RegEx = "\\w"
        let regex = try! NSRegularExpression(pattern: RegEx, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func formatPrice(price: Double) -> String {
       return ""
    }
    
    
    
    static func generateNameForImage() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "AVATAR_hh.mm.ss.dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    
    
    static func getImageFormatFromUrl(url : URL) -> String {
        
        if url.absoluteString.hasSuffix("JPG") {
            return"JPG"
        }
        else if url.absoluteString.hasSuffix("PNG") {
            return "PNG"
        }
        else if url.absoluteString.hasSuffix("GIF") {
            return "GIF"
        }
        else {
            return "jpg"
        }
    }
    
    // wrong with đ -> ?
//    static func convertVietNam(text: String) -> String {
//        guard let data = text.data(using: .ascii, allowLossyConversion: true) else { return text }
//        guard let searchText = String(data: data, encoding: .ascii) else { return text }
//        return searchText
//    }
    static func gennerateKeywordsMod( name: String, address: String) -> [String] {
        
        
        let nameConvert = self.convertVietNam(text: name.lowercased())
        let addressConvert = self.convertVietNam(text: address.lowercased())
        
        //1. first remove "," from address
        let nameArr = nameConvert.split(separator: ",")
        var addressArr = addressConvert.split(separator: ",")
        
        //2. Then generate permutations from newArray
        var permutations = [String]()
        for string in nameArr {
            //2.1. get list of words by seperate string with space character
            let subStrings = string.split(separator: " ")
            
            //2.2. Then double loop for generate permutations
            for index in 0..<subStrings.count {
                var word = subStrings[index].lowercased()
                permutations.append(String(word))
                
                for nextIndex in 0..<addressArr.count{
                    let nextWords = addressArr[nextIndex].lowercased()
                    var subWord = ""
                    if nextIndex == 0 {
                        subWord = subStrings[index].lowercased() + " " + nextWords
                    } else {
                        subWord = subStrings[index].lowercased() + nextWords
                    }
                    permutations.append(String(subWord))
                }
                
                for nextIndex in index+1..<subStrings.count{
                    let nextWords = subStrings[nextIndex].lowercased()
                    word += " " + nextWords
                    permutations.append(String(word))
                    
                    for i in 0..<addressArr.count {
                        
                        let addressWord = addressArr[i].lowercased()
                        let anotherWord = word + " " + addressWord
                        permutations.append(String(anotherWord))
                    }
                }
            }
        }
        
        for index in 0..<addressArr.count {
            permutations.append(String(addressArr[index]).lowercased())
        }
        
        return permutations
    }
    
    
    static func convertVietNam(text: String) -> String {
        return text.folding(options: .diacriticInsensitive, locale: .current)
    }
    
}

//
//class ConverHelper {
//    private static let arrCoDau: [Character] =
//        ["á","à","ả","ã","ạ",
//         "ă","ắ","ằ","ẳ","ẵ","ặ",
//         "â","ấ","ầ","ẩ","ẫ","ậ",
//         "đ",
//         "é","è","ẻ","ẽ","ẹ",
//         "ê","ế","ề","ể","ễ","ệ",
//         "í","ì","ỉ","ĩ","ị",
//         "ó","ò","ỏ","õ","ọ",
//         "ô","ố","ồ","ổ","ỗ","ộ",
//         "ơ","ớ","ờ","ở","ỡ","ợ",
//         "ú","ù","ủ","ũ","ụ",
//         "ư","ứ","ừ","ử","ữ","ự",
//         "ý","ỳ","ỷ","ỹ","ỵ",
//
//         "Á","À","Ả","Ã","Ạ",
//         "Ă","Ắ","Ằ","Ẳ","Ẵ","Ặ",
//         "Â","Ấ","Ầ","Ẩ","Ẫ","Ậ",
//         "Đ",
//         "É","È","Ẻ","Ẽ","Ẹ",
//         "Ê","Ế","Ề","Ể","Ễ","Ệ",
//         "Í","Ì","Ỉ","Ĩ","Ị",
//         "Ó","Ò","Ỏ","Õ","Ọ",
//         "Ô","Ố","Ồ","Ổ","Ỗ","Ộ",
//         "Ơ","Ớ","Ờ","Ở","Ỡ","Ợ",
//         "Ú","Ù","Ủ","Ũ","Ụ",
//         "Ư","Ứ","Ừ","Ử","Ữ","Ự",
//         "Ý","Ỳ","Ỷ","Ỹ","Ỵ"]
//
//    private static let arrKhongDau: [Character] =
//        ["a","a","a","a","a",
//         "a","a","a","a","a","a",
//         "a","a","a","a","a","a",
//         "d",
//         "e","e","e","e","e",
//         "e","e","e","e","e","e",
//         "i","i","i","i","i",
//         "o","o","o","o","o",
//         "o","o","o","o","o","o",
//         "o","o","o","o","o","o",
//         "u","u","u","u","u",
//         "u","u","u","u","u","u",
//         "y","y","y","y","y",
//
//         "A","A","A","A","A",
//         "A","A","A","A","A","A",
//         "A","A","A","A","A","A",
//         "D",
//         "E","E","E","E","E",
//         "E","E","E","E","E","E",
//         "I","I","I","I","I",
//         "O","O","O","O","O",
//         "O","O","O","O","O","O",
//         "O","O","O","O","O","O",
//         "U","U","U","U","U",
//         "U","U","U","U","U","U",
//         "Y","Y","Y","Y","Y"
//    ]
//
//    class func convertVietNam(text: String) -> String {
//        var arr = Array(text.characters)
//        for i in 0 ..< arr.count {
//            for j in 0 ..< arrCoDau.count {
//                if (arr[i] == arrCoDau[j]) {
//                    arr[i] = arrKhongDau[j]
//                    break
//                }
//            }
//        }
//        return String(arr)
//    }
//
//
//}
