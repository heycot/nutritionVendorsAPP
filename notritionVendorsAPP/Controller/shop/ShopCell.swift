//
//  ShopCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation

class ShopCell: UITableViewCell {
    
    @IBOutlet weak var shopImage: CustomImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var infor: UILabel!
    @IBOutlet weak var viewInMapBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(shop: ShopResponse, isNewest: Bool, location: CLLocation) {
        
        viewInMapBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(19.0))
        
        shopImage.loadImageUsingUrlString(urlString: BASE_URL_IMAGE + shop.avatar!)
        shopName.text = shop.name!
        shopAddress.text = shop.location?.address!
        if isNewest {
            infor.text = shop.create_date?.timeAgoDisplay()
        } else {
            infor.text = shop.distance ?? "500 m"
//            countDistance(shop: shop, currlocation: location)
        }
    }
    
//    func countDistance(shop: ShopResponse, currlocation: CLLocation) {
//        
//        guard let location = shop.location else {
//            return
//        }
//        
//        let coordinate₀ = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
////        let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
//        
//        let distanceInMeters = coordinate₀.distance(from: currlocation)
//        if distanceInMeters < 1000 {
//            infor.text = String(format: " Distance : %.2f ", distanceInMeters.inMiles()) + " M"
//        } else {
//            infor.text = String(format: " Distance : %.2f ", distanceInMeters.inKilometers()) + " KM"
//        }
//    }
    

}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
