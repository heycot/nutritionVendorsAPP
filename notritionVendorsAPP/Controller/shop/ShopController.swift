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
    
    // variables
    var listItem = [ShopResponse]()
    var currentList = [ShopResponse]()
    var isNewest = false
    
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
        
        if isNewest {
            ShopServices.shared.getNewestShop(offset: offset) { data in
                guard let data = data else {return }

                if isLoadMore {
                    for shop in data {
                        self.listItem.append(shop)
                    }
                } else {
                    self.listItem = data
                }

                self.currentList = self.listItem
                self.tableView.reloadData()
            }
        } else {
            guard let location = AuthServices.instance.currentLocation else { return }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            ShopServices.shared.getNearestShop(latitude: latitude, longitude: longitude, offset: offset) { data in
                guard let data = data else {return }
                
                if isLoadMore {
                    for shop in data {
                        
                        self.listItem.append(shop)
                    }
                } else {
                    self.listItem = data
                }
                
                self.updateDistance(shops: self.listItem)
                self.currentList = self.listItem
                self.tableView.reloadData()
            }
        }
    }
    
    func updateDistance(shops: [ShopResponse]) {
        guard let location = AuthServices.instance.currentLocation else { return }
        
        for i in 0 ..< listItem.count {
            listItem[i].distance = ShopServices.shared.getDistance(shop: listItem[i], currlocation: location)
        }
    }
    
    @IBAction func searchBarPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.shopToSearch.rawValue, sender: nil)
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
            let index = sender as! Int
            vc?.shop = listItem[index]
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
        performSegue(withIdentifier: SegueIdentifier.shopToItemInShop.rawValue, sender: indexPath.row)
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


