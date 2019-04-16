//
//  SearchController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/13/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    let searchBar = UISearchBar()
    var listItem = [SearchResponse] ()
    var searchDelayer: Timer!
    var priorSearchText = ""
    
    var shopitem = ShopItemResponse()
    var shop = ShopResponse()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = APP_COLOR
        createSearchBar()
        setupTableView()
    }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = " Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
    }
    
    func startSpinnerActivity() {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        spinnerActivity.isUserInteractionEnabled = false;
        
        DispatchQueue.main.async {
            spinnerActivity.hide(animated: true);
        }
    }
    
    
    func stopSpinnerActivity() {
        MBProgressHUD.hide(for: self.view, animated: true);
    }
    
    @objc func doDelayedSearch(_ t: Timer) {
        assert(t == searchDelayer)
        search()
        searchDelayer = nil
    }
    
    @objc func search() {
        print("call api search")
        ShopItemService.shared.searchItem(searchText: searchBar.text!.lowercased()) { data in
            guard let data = data else {return }
            
            if data.count == 0 {
                self.notification.textColor = APP_COLOR
                self.notification.text = "There is no suitable food"
                self.notification.isHidden = false
                
            } else {
                self.listItem = data
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    func getShopItemResponse(id: Int) {
        ShopItemService.shared.getOneDTOItem(id: id) { (data) in
            self.shopitem = data!
            self.performSegue(withIdentifier: SegueIdentifier.searchToDetaild.rawValue, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            vc?.item = shopitem
            navigationItem.backBarButtonItem = backItem
        } else {
            
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
        if listItem[indexPath.row].isShop == 1 {
            self.performSegue(withIdentifier: SegueIdentifier.searchToShop.rawValue, sender: indexPath.row)

        } else {
            getShopItemResponse(id: listItem[indexPath.row].id!)
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search), object: nil)
        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
