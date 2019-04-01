//
//  ViewLocationShopControllerViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/18/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewLocationShopController: UIViewController {
    
    // Outlets
     
    // variables
    var location = LocationResponse()
    var shopName = ""
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
//        let latitude =  Double(location.latitude!).roundTo(places: 6)
//        let logitude =  Double(location.longitude!).roundTo(places: 6)
        
//        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: logitude, zoom: 12)
//        let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude!, longitude: location.longitude!, zoom: 12)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let currentLocation = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
        
        let marker = GMSMarker(position: currentLocation)
        marker.map = mapView
        marker.title = shopName
    }

}


extension ViewLocationShopController : CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
