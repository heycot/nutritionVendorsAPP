//
//  NewestShopController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/11/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class ShopController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // variables
    var listItem = [ShopResponse]()
    var currentList = [ShopResponse]()
    var isNewest = true
    
    let searchBar = UISearchBar()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        createSearchBar()
        loadDataFromAPI(offset: listItem.count, isLoadMore: true, isNewest: isNewest)
    }
    
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 90
    }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = " Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
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
            let latitude = 0.0
            let longitude = 0.0
            
            ShopServices.shared.getNearestShop(latitude: latitude, longitude: longitude, offset: offset) { data in
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
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    }
}

extension ShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.shop.rawValue, for: indexPath) as! ShopCell
        cell.updateView(shop: currentList[indexPath.row], isNewest: isNewest)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        loadDataFromAPI(offset: currentList.count, isLoadMore: false, isNewest: isNewest)
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}

// handle UISearchBar
extension ShopController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        resultSearchNotification.isHidden = true
        guard !(searchBar.text!.isEmpty) else {
            currentList = listItem
            tableView.reloadData()
            return
        }
        
        currentList = listItem.filter({ (item) -> Bool in
            item.name!.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(searchText.folding(options: .diacriticInsensitive, locale: .current).lowercased())
        })
        
        let filterShopAddress = listItem.filter({ (item) -> Bool in
            (item.location?.address!.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(searchText.folding(options: .diacriticInsensitive, locale: .current).lowercased()))!
        })
        
        for item in filterShopAddress {
            if !self.checkItemInArray(array: currentList, item: item) {
                currentList.append(item)
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

