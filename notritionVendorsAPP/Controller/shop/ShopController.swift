//
//  NewestShopController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps

class ShopController: UIViewController {
    
    // oulets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewInMapBtn: UIButton!
    @IBOutlet weak var searchBar: UIButton!
    
    // variables
    var listItem = [ShopResponse]()
    var currentList = [ShopResponse]()
    var isNewest = false
    var currentShop = ShopResponse()
    
    // location manager
    var locationManager = CLLocationManager()
    var didUpdateLocation: Bool = false
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        viewInMapBtn.boderRadiousWithoutCollor()
        searchBar.adjustsImageWhenHighlighted = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
        
        tableView.bottomRefreshControl = refresher
    }
    
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: listItem.count, isLoadMore: true, isNewest: isNewest)
        refresher.endRefreshing()
    }
    
    func loadDataFromAPI(offset: Int, isLoadMore: Bool, isNewest: Bool) {
        
        guard let location = AuthServices.instance.currentLocation else {
            setupCurrentLocation()
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
//        ShopServices.shared.getNearestShop(latitude: latitude, longitude: longitude, offset: offset) { data in
//            guard let data = data else {return }
//
//            if isLoadMore {
//                for shop in data {
//
//                    self.listItem.append(shop)
//                }
//            } else {
//                self.listItem = data
//            }
//
////                self.updateDistance(shops: self.listItem)
//            self.currentList = self.listItem
//            self.tableView.reloadData()
//        }
    }
    
//    func updateDistance(shops: [ShopResponse]) {
//        guard let location = AuthServices.instance.currentLocation else { return }
//
//        for i in 0 ..< listItem.count {
//            listItem[i].distance = listItem[i].getDistance(currlocation: location)
//        }
//    }
    
    func getShopInfor(id: Int) {
//        ShopServices.shared.getOne(id: id) { (data) in
//            guard let data = data else { return }
//
//            self.currentShop = data
//            self.performSegue(withIdentifier: SegueIdentifier.shopToItemInShop.rawValue, sender: nil)
//        }
    }
    
    @IBAction func searchBarPressed(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.shopToSearch.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        if segue.destination is SearchController {
             navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ViewLocationShopController {
            let vc = segue.destination as? ViewLocationShopController
            vc?.listShop = listItem
            vc?.isFromShop = true
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ItemInShopController {
            let vc = segue.destination as? ItemInShopController
//            let index = sender as! Int
            vc?.shop = currentShop
        }
    }
    
    @objc func viewInMapPressed() {
        performSegue(withIdentifier: SegueIdentifier.shopToGoogleMap.rawValue, sender: nil)
    }
    
    func stopSpinnerActivity() {
        MBProgressHUD.hide(for: self.view, animated: true);
    }
    
    
    func checkItemInArray(array: [ShopResponse], item: ShopResponse) -> Bool {
        for arr in array {
            if item.id! == arr.id! {
                return true
            }
        }
        return false
    }
    
}

extension ShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        getShopInfor(id: listItem[indexPath.row].id!)
        getShopInfor(id: 0)
    }
}

extension ShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shop.rawValue, for: indexPath) as! ShopCell
        
        
        cell.updateView(shop: currentList[indexPath.row], isNewest: isNewest)
        cell.viewInMapBtn.addTarget(self, action: #selector(viewInMapPressed), for: UIControl.Event.touchDown)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromAPI(offset: 0, isLoadMore: false, isNewest: isNewest)
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    
}

// extention for handle user's location
extension ShopController {
    
    // MARK - Map, Location
    
    func setupCurrentLocation() {
        
        // User Location
        locationManager.delegate = self
        
        // Start Location
        accessLocationServices()
    }
    
    func startUpdateLocation() {
        didUpdateLocation = false
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        didUpdateLocation = true
        locationManager.stopUpdatingLocation()
    }
}

extension ShopController: CLLocationManagerDelegate {
    
    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }
        
        stopUpdateLocation()
        AuthServices.instance.currentLocation = location
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

extension ShopController : LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}

