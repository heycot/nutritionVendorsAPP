//
//  NewestShopController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import GoogleMaps
import PKHUD

class ShopController: UIViewController {
    
    // oulets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewInMapBtn: UIButton!
    @IBOutlet weak var searchBar: UIButton!
    
    // variables
    var currentList = [ShopResponse]()
    
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
        loadDataFromAPI(offset: 0, isLoadMore: false)
    }
    
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        viewInMapBtn.boderRadiousWithoutCollor()
        searchBar.adjustsImageWhenHighlighted = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
        tableView.bottomRefreshControl = refresher
    }
    
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: currentList.count, isLoadMore: true)
        refresher.endRefreshing()
    }
    
    func loadDataFromAPI(offset: Int, isLoadMore: Bool) {
        HUD.show(.progress)
       
        ShopService.instance.getListShop() {  data in
            guard var data = data else {return }
            data.sort(by: {$0.distance! < $1.distance! })

            if isLoadMore {
                for shop in data {

                    self.currentList.append(shop)
                }
            } else {
                self.currentList = data
            }

            HUD.hide()
            self.tableView.reloadData()
        }
        
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
            vc?.listShop = currentList
            vc?.isFromShop = true
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ItemInShopController {
            let vc = segue.destination as? ItemInShopController
            let index = sender as! Int
            vc?.shop = currentList[index]
        }
    }
    
    @objc func viewInMapPressed() {
        performSegue(withIdentifier: SegueIdentifier.shopToGoogleMap.rawValue, sender: nil)
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
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: SegueIdentifier.shopToItemInShop.rawValue, sender: indexPath.row)
    }
}

extension ShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shop.rawValue, for: indexPath) as! ShopCell
        
        
        cell.updateView(shop: currentList[indexPath.row])
        cell.viewInMapBtn.addTarget(self, action: #selector(viewInMapPressed), for: UIControl.Event.touchDown)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

