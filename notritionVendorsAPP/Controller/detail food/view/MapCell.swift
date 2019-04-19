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
    
    func updateView(shop: ShopResponse) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation : CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location!
        }
        
        guard let location = shop.location else { return }
        address.text = location.address!
        distance.text = ShopServices.shared.getDistance(shop: shop, currlocation: currentLocation) + " (From current location)"
        
        
        
        viewMapFunc(lc: shop.location!)
    }
    
    func viewMapFunc(lc : LocationResponse) {
        let location = CLLocation(latitude: lc.latitude!, longitude: lc.longitude!)
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
        
        mapView.camera = camera
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let marker = GMSMarker(position: currentLocation)
        marker.map = mapView
        
    }
    
}
