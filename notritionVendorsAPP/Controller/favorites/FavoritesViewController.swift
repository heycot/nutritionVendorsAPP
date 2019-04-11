//
//  FavoritesViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/6/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultSearchNotification: UILabel!
    
    var listItem = [ShopItemResponse]()
    var currentListItem = [ShopItemResponse]()
    
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
        
        if !AuthServices.instance.isLoggedIn {
            let alert = UIAlertController(title: Notification.notLogedIn.rawValue, message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.performSegueFunc(identifier: SegueIdentifier.favoritesToLogIn.rawValue, sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                self.resultSearchNotification.text = Notification.notLogedIn.rawValue
            }))
            self.present(alert, animated: true)
            
            tableView.tableFooterView = UIView()
        } else {
            loadDataFromAPI(offset: 0, isLoadMore: false)
        }
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 80
    }
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = " Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func loadDataFromAPI(offset: Int, isLoadMore: Bool) {
        
        ShopItemService.shared.findAllLoved(offset: offset) { data in
            guard let data = data else {return }
            
            // check listitem is already have
            if data.count == 0, self.listItem.count == 0{
                self.resultSearchNotification.isHidden = false
                self.resultSearchNotification.text = Notification.notHaveAnyFavorite.rawValue
            } else {
                //if load more data => add to listItem else replace listItem
                if isLoadMore {
                    for i in 0 ..< data.count {
                        self.listItem.append(data[i])
                    }
                } else {
                    self.listItem = data
                }
                
                self.resultSearchNotification.isHidden = true
            }
            self.currentListItem = self.listItem
            self.tableView.reloadData()
        }
    }
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: listItem.count, isLoadMore: true)
        refresher.endRefreshing()
    }
    
    func performSegueFunc(identifier: String, sender: Any?) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = currentListItem[index]
            
        }  else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
        }
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

    
    func checkItemInArray(array: [ShopItemResponse], item: ShopItemResponse) -> Bool {
        for arr in array {
            if item.id! == arr.id! {
                return true
            }
        }
        return false
    }
}

// handle UISearchBar
extension FavoritesViewController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultSearchNotification.isHidden = true
        guard !(searchBar.text!.isEmpty) else {
            currentListItem = listItem
            tableView.reloadData()
            return
        }
        
        currentListItem = listItem.filter({ (item) -> Bool in
            item.name!.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(searchText.folding(options: .diacriticInsensitive, locale: .current).lowercased())
        })
        
        let filterShopName = listItem.filter({ (item) -> Bool in
            item.shop_name!.folding(options: .diacriticInsensitive, locale: .current).lowercased().contains(searchText.folding(options: .diacriticInsensitive, locale: .current).lowercased())
        })
        
        for item in filterShopName {
            if !self.checkItemInArray(array: currentListItem, item: item) {
                currentListItem.append(item)
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}



extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentListItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favoritesItem.rawValue) as! FavoritesCell
        
        cell.updateView(item: currentListItem[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        loadDataFromAPI(offset: currentListItem.count, isLoadMore: false)
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension FavoritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegueFunc(identifier: SegueIdentifier.favoriteToDetail.rawValue, sender: indexPath.row)
    }
    
    
}
