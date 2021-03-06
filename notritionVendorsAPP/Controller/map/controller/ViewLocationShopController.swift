//
//  ViewLocationShopControllerViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/18/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps

struct DistanceDurationItem {
    var distance: Double
    var duration: Double

    var durationDescription: String {
        if duration == 1 {
            return String(format: NSLocalizedString("%.0f mins", comment: "") , duration)
        } else {
            return String(format: NSLocalizedString("%.0f mins", comment: "") , duration)
//            return String(format: "%.0f mins", duration)
        }
    }

    var distanceDescription: String {
        return String(format: "%.1f km", distance)
    }
}

class ViewLocationShopController: UIViewController {
    
    // Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var distance: UILabel!
    //    @IBOutlet weak var direction: UIButton!
    @IBOutlet weak var shopInforHeightConstraint: NSLayoutConstraint!

    var locationManager = CLLocationManager()
    var zoomLevel: Float = 15.0
    var didUpdateLocation: Bool = false

    // Directions
    var routePolyline: GMSPolyline!
    var markersArray: [GMSMarker] = []

    var selectedRoute: MapResponseRoute?
    var currentLocation: CLLocation?

    var originCoordinate: CLLocationCoordinate2D!
    var originAddress: String!

    // MARK - markers

    var shopMarkers: [GMSMarker]!
    var currentShopMarker: GMSMarker?

    // variables
    var listShop = [ShopResponse]()
    var currentShop: ShopResponse?
    var selectedShop : ShopResponse?
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    var isFromShop = false
    var zoomLevelListShop: Float = 20.0
    var distanceDuration = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configs()
    }
    
    func configs() {
        addMap()
        configLocationManager()
        
        if AuthServices.instance.currentLocation == nil {
            
        } else {
            if isFromShop {
                displayListShopMarkers()
            } else {
                displayCurrentShop()
            }
        }
    }

    func addMap() {
        mapView.delegate = self
        
        //check show controller from shopController
        // check show list shop or one shop
        if !isFromShop {
            
            let cl_location = CLLocation(latitude: currentShop?.latitude! ?? 0, longitude: currentShop?.longitude! ?? 0)
            
            configCamera(location: cl_location, zoomLevel: zoomLevel)
        }
        mapView.isMyLocationEnabled = true
    }

    func configCamera(location: CLLocation, zoomLevel: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        mapView.camera = camera
    }

    func displayListShopMarkers() {
        let markers = listShop.map { (shop) in
            return self.getMarker(shop)
        }
        shopMarkers = markers
    }
    
    func displayCurrentShop() {
        guard let shop = currentShop else { return }
        _ = self.getMarker(shop)
    }
    
    func getMarker(_ shop: ShopResponse) -> GMSMarker {
        let locationCoordinate2D  = CLLocationCoordinate2D(latitude: shop.latitude ?? 0, longitude: shop.longitude ?? 0)
        let marker = GMSMarker(position: locationCoordinate2D)
        marker.map = self.mapView
        let shopMarkerView = ShopMarkerView()
        shopMarkerView.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        marker.iconView = shopMarkerView
        marker.userData = shop
        marker.title = shop.name

        return marker
    }

    func configShopInfo(_ shop: ShopResponse) {
        shopName.text = shop.name
        distance.text = shop.getDistance(currlocation: AuthServices.instance.currentLocation) + NSLocalizedString(" (From current location)", comment: "") 
        

        // TODO: update more info if needed here
    }

    func showShopInfo(_ isShown: Bool) {
        let value = isShown ? 80 : 0
        updateDetailContainerHeightConstraint(value: CGFloat(value))
    }

    func updateDetailContainerHeightConstraint(value: CGFloat) {
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut], animations: {
            self.shopInforHeightConstraint.constant = value
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func configLocationManager() {
        // User Location
        locationManager.delegate = self

        // Start Location
        accessLocationServices()
    }

    // MARK - Map, Location

    func startUpdateLocation() {
        didUpdateLocation = false
        locationManager.startUpdatingLocation()
    }

    func stopUpdateLocation() {
        didUpdateLocation = true
        locationManager.stopUpdatingLocation()
    }

    @IBAction func getDirectionPressed(_ sender: Any) {
        let locationCoordinate2D = CLLocationCoordinate2D(latitude: self.currentShop?.latitude ?? 0, longitude: self.currentShop?.longitude ?? 0)
        createRoute(locationCoordinate2D)
    }
    // MARK: - APIs call

    func createRoute(_ destination: CLLocationCoordinate2D) {
        self.getDirections(destination: destination, success: {
            self.drawRoute()
        }) { (error) in

        }
    }

    func getDirections(destination: CLLocationCoordinate2D, success:@escaping () -> (),
                       failed:@escaping (_ error: NSError?) -> ()) {
        var origin = ""
        var destinationString = ""

        origin = String.locationCoordinate(lat: AuthServices.instance.currentLocation?.coordinate.latitude
            , lng: AuthServices.instance.currentLocation?.coordinate.longitude)
        destinationString = String.locationCoordinate(lat: destination.latitude, lng: destination.longitude)

        Mapmanager.getDirections(origin, destination: destinationString, success: { (response) in
            if let routes = response?.routes, let selectedRoute = routes.first {
                self.distanceDuration = self.handleGetDirectionsSuccessfully(selectedRoute: selectedRoute).distance
                success()
            } else {
                failed(nil)
            }
        }) { (error) in
            failed(error)
        }
    }

    func handleGetDirectionsSuccessfully(selectedRoute: MapResponseRoute) -> DistanceDurationItem {
        self.selectedRoute = selectedRoute
        let legs = selectedRoute.legs
        self.originCoordinate = legs?.first?.start_location?.locationCoordinate() ?? CLLocationCoordinate2DMake(0,0)
        self.originAddress = legs?.first?.start_address ?? ""
        let distanceDurationItem = self.calculateTotalDistanceAndDuration(legs: selectedRoute.legs ?? [])

        //self.destinationCoordinate = legs?.last?.end_location?.locationCoordinate() ?? CLLocationCoordinate2DMake(0,0)
        //self.destinationAddress = legs?.last?.end_address

        return distanceDurationItem
    }

    func calculateTotalDistanceAndDuration(legs: [MapResponseLeg]) -> DistanceDurationItem {

        var totalDistanceInMeters: UInt = 0
        var totalDurationInSeconds: UInt = 0

        for leg in legs {
            let distance = leg.distance
            let duration = leg.duration
            totalDistanceInMeters += distance?.value ?? 0
            totalDurationInSeconds += duration?.value ?? 0
        }

        let distanceInKilometers: Double = Double(totalDistanceInMeters) / 1000.0
        let mins = Double(totalDurationInSeconds) / 60

        return DistanceDurationItem(distance: distanceInKilometers, duration: mins)
    }

    // MARK: - Helper methods

    func configureMapAndMarkersForRoute() {
        mapView.camera = GMSCameraPosition.camera(withTarget: self.originCoordinate, zoom: zoomLevel)
    }

    func drawRoute() {
        if (self.routePolyline) != nil {
            self.clearRoute()
        }

        //from Google api
        let route = self.selectedRoute?.overviewPolyline?.points ?? ""

        // Draw route
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5
        routePolyline.strokeColor = UIColor.blue
        routePolyline.map = mapView
        
        
        if self.distanceDuration <= 7 {
            configCamera(location: AuthServices.instance.currentLocation ?? CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel: zoomLevel)
        } else {
            configCamera(location: AuthServices.instance.currentLocation ?? CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel: 12)
        }
        
//        if isFromShop {
//            configCamera(location: AuthServices.instance.currentLocation ?? CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel: zoomLevel)
//        } else {
//            configCamera(location: AuthServices.instance.currentLocation ?? CLLocation(latitude: 0.0, longitude: 0.0), zoomLevel: 12)
//        }
    }

    func clearRoute() {
        routePolyline.map = nil

        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }

            markersArray.removeAll(keepingCapacity: false)
        }
    }
}

extension ViewLocationShopController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            showShopInfo(false)
        }
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt position \(position)")
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tap")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker")
        if let shop = marker.userData as? ShopResponse {
            self.currentShop = shop
            configShopInfo(shop)
            showShopInfo(true)
        }

        return false
    }
}

extension ViewLocationShopController: CLLocationManagerDelegate {

    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }

        stopUpdateLocation()
        self.currentLocation = location
        
//        print( "latitude \(location.coordinate.latitude) , \(location.coordinate.longitude)")

        if isFromShop {
            configCamera(location: location, zoomLevel: zoomLevel)
        }
    }

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        handleDidUpdateLocation(location: location)
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }

}

extension ViewLocationShopController: LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}

extension String {
    static func locationCoordinate(lat: Double?, lng: Double?) -> String {
        guard let latitude = lat, let longitude = lng else { return "" }

        return String("\(latitude), \(longitude)")
    }
}
