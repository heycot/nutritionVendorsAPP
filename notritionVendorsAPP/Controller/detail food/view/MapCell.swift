//
//  MapCell.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/19/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps

class MapCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(item: ShopItemResponse) {
        view.setBorderRadious(radious: 15)
        
        address.text = item.address ?? ""
        let shop = ShopResponse(name: item.shop_name ?? "", longitude: item.longitude ?? 0, latitude: item.latitude ?? 0)
        distance.text = shop.getDistance(currlocation: AuthServices.instance.currentLocation) + NSLocalizedString(" (From current location)", comment: "") 
        let location = CLLocation(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0)
        
        viewMapFunc(location)
    }
    
    func viewMapFunc(_ location : CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
        
        mapView.camera = camera
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let marker = GMSMarker(position: currentLocation)
        marker.map = mapView
        
    }
    
}
