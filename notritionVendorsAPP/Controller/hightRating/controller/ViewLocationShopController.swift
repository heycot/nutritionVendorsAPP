//
//  ViewLocationShopControllerViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/18/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewLocationShopController: UIViewController {
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // variables
    var location = LocationResponse()
    var shopName = ""
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
    }

    @IBAction func mapDirectionPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMap()
        }
    }
}

extension ViewLocationShopController : MKMapViewDelegate {
    func centerMap() {
        guard let coordinate = locationManager.location?.coordinate else { return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: location.latitude!, longitudinalMeters: location.longitude!)
        
        mapView.setRegion(coordinateRegion, animated: true)
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
        centerMap()
    }
}
