//
//  UIImageLibrary.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Photos


extension UIImageView {
    
    
//    struct myBackgroundImage {
//
//        static var firstImage: UIImage { return UIImage(named: "firstBKImage")!  }
//
//        static var secondImage: UIImage { return UIImage(named: "secondBKImage")! }
//
//        static var thirdImage: UIImage { return UIImage(named: "thirdBKImage")! }
//
//        static var fourthImage: UIImage { return UIImage(named: "fourthBKImage.jpg")! }
//    }

//    func randomBackgroudImage() -> UIImage{
//        let index = Int.random(in: 0...3)
//        switch index {
//        case 0:
//            return myBackgroundImage.firstImage
//        case 1:
//            return myBackgroundImage.secondImage
//        case 2:
//            return myBackgroundImage.thirdImage
//        default:
//            return myBackgroundImage.fourthImage
//        }
//    }
    
    func setRounded(color: UIColor) {
        self.layer.cornerRadius = (self.frame.size.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    func setShadown() {
        //        self.layer.cornerRadius = (self.frame.size.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.size.width / 2).cgPath
        
    }
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
