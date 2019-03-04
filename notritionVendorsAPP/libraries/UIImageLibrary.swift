//
//  UIImageLibrary.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

extension UIImageView {
    struct myBackgroundImage {
    
        static var firstImage: UIImage { return UIImage(named: "firstBKImage")!  }

        static var secondImage: UIImage { return UIImage(named: "secondBKImage")! }

        static var thirdImage: UIImage { return UIImage(named: "thirdBKImage")! }

        static var fourthImage: UIImage { return UIImage(named: "fourthBKImage.jpg")! }
    }

    func randomBackgroudImage() -> UIImage{
        let index = Int.random(in: 0...3)
        switch index {
        case 0:
            return myBackgroundImage.firstImage
        case 1:
            return myBackgroundImage.secondImage
        case 2:
            return myBackgroundImage.thirdImage
        default:
            return myBackgroundImage.fourthImage
        }
    }
    
    func setRounded(color: UIColor) {
        self.layer.cornerRadius = (self.frame.size.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = color.cgColor
    }
}
