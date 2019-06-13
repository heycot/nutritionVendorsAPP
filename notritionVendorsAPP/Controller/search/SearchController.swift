//
//  SearchController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import PKHUD

class SearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var searchTextNote: UILabel!
    @IBOutlet weak var heightForSearchNote: NSLayoutConstraint!
    
    let searchBar = UISearchBar()
    var listItem = [SearchResponse] ()
    var searchDelayer: Timer!
    var priorSearchText = ""
    
    var shopitem = ShopItemResponse()
    var recentList = [RecentResponse]()
    var shop = ShopResponse()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = APP_COLOR
        searchTextNote.isHidden = true
        createSearchBar()
        setupTableView()
        getRecentSearch(offset: 0)
    }
    
    func getRecentSearch(offset: Int) {
        HUD.show(.progress)
        
        AuthServices.instance.checkLogedIn(completion: { (data) in
            guard let data = data else { return }
            
            if data {
                RecentService.instance.getListRecent { (data) in
                    guard var data = data else {
                        HUD.hide()
                        return
                    }
                    data.sort(by: {$0.update_date! > $1.update_date! })
                    
                    for item in data {
                        self.listItem.append(item.convertToSearchResponse())
                    }
                    
                    HUD.hide()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = NSLocalizedString(" Search here", comment: "")
        searchBar.delegate = self
        searchBar.tintColor = .black 
        
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 80
    }
    
    
    
    @objc func doDelayedSearch(_ t: Timer) {
        assert(t == searchDelayer)
        search()
        searchDelayer = nil
    }
    
    @objc func search() {
        HUD.show(.progress)
        
        SearchServices.instance.search(searchText: searchBar.text!.lowercased()) { (data) in
            guard var data = data else {return }
            data.sort(by: {$0.distance! < $1.distance! })
            self.listItem = data
            
            HUD.hide()
            self.tableView.reloadData()
        }
    }
    
    
    func getShopItemResponse(id: String) {
        ShopItemService.instance.getOneById(shop_item_id: id) { (data) in
            guard let data = data else { return }
            
            self.shopitem = data
            self.performSegue(withIdentifier: SegueIdentifier.searchToDetaild.rawValue, sender: nil)
        }
    }
    
    func getShopResponse(id: String) {
        ShopService.instance.getOneById(shopId: id) { (data) in
            guard let data = data else { return }
            
            self.shop = data
            self.performSegue(withIdentifier: SegueIdentifier.searchToShop.rawValue, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            vc?.item = shopitem
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is ItemInShopController{
            let vc = segue.destination as? ItemInShopController
            vc?.shop = shop
            navigationItem.backBarButtonItem = backItem
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellID") as! SearchCell
        
        cell.updateView(item: listItem[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if listItem[indexPath.row].is_shop! == 1 {
            getShopResponse(id: listItem[indexPath.row].entity_id ?? "")
        } else {
            getShopItemResponse(id: listItem[indexPath.row].entity_id ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
}


// handle UISearchBar
extension SearchController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
        
        searchBar.endEditing(true)
    }
    
    // seach after 0.5s delay
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: nil)
//        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
//    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
