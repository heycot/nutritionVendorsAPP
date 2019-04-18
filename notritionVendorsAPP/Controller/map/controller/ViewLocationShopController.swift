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
            return String(format: "%.0f mins", duration)
        } else {
            return String(format: "%.0f mins", duration)
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
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    var isFromShop = false
    var zoomLevelListShop: Float = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var location = (currentShop?.location!)!
//        GMSServices.provideAPIKey(GOOGLE_API_KEY)
//        let latitude =  Double(location.latitude!).roundTo(places: 6)
//        let logitude =  Double(location.longitude!).roundTo(places: 6)
//
//        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: logitude, zoom: 12)
//        let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: logitude)
//
//        let camera = GMSCameraPosition.camera(withLatitude: location.latitude!, longitude: location.longitude!, zoom: 12)
//
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        let currentLocation = CLLocationCoordinate2D(latitude: location.latitude!, longitude: location.longitude!)
//
//        let marker = GMSMarker(position: currentLocation)
//        marker.map = mapView
        configs()
    }
    
    func configs() {
        addMap()
        configLocationManager()
        displayCurrentShop()
    }

    func addMap() {
        guard let location = currentShop?.location else { return }
        
        mapView.delegate = self
        
        
        //check show controller from shopController
        if isFromShop {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude!, longitude: location.longitude!, zoom: zoomLevelListShop)
            mapView.camera = camera
        } else {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude!, longitude: location.longitude!, zoom: zoomLevel)
            mapView.camera = camera
        }
        mapView.isMyLocationEnabled = true
    }

    func configCamera(location: CLLocation) {
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
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
        let currentShopMarker = self.getMarker(shop)
    }
    
    func getMarker(_ shop: ShopResponse) -> GMSMarker {
        let locationCoordinate2D = shop.location?.locationCoordinate2D()
        let marker = GMSMarker(position: locationCoordinate2D!)
        marker.map = self.mapView
        let shopMarkerView = ShopMarkerView()
        shopMarkerView.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        marker.iconView = shopMarkerView
        marker.userData = shop
        marker.title = shop.name

        return marker
    }

    func configShopInfo(_ shop: ShopResponse) {
        shopName.text = shop.name

        // TODO: update more info if needed here
    }

    func showShopInfo(_ isShown: Bool) {
        let value = isShown ? 150 : 0
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
        if let locationCoordinate2D = self.currentShop?.location?.locationCoordinate2D() {
            createRoute(locationCoordinate2D)
        }
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

        origin = String.locationCoordinate(lat: self.currentLocation?.coordinate.latitude
            , lng: self.currentLocation?.coordinate.longitude)
        destinationString = String.locationCoordinate(lat: destination.latitude, lng: destination.longitude)

        Mapmanager.getDirections(origin, destination: destinationString, success: { (response) in
            if let routes = response?.routes, let selectedRoute = routes.first {
                self.handleGetDirectionsSuccessfully(selectedRoute: selectedRoute)
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

        let route = self.selectedRoute?.overviewPolyline?.points ?? ""

        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5
        routePolyline.strokeColor = UIColor.green
        routePolyline.map = mapView
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
        
        print( "latitude \(location.coordinate.latitude) , \(location.coordinate.longitude)")

//        if isFromShop {
            configCamera(location: location)
//        }
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
