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
        
        if !AuthServices.instance.isLoggedIn {
            let alert = UIAlertController(title: Notification.notLogedIn.rawValue, message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.performSegueFunc(identifier: SegueIdentifier.favoritesToLogIn.rawValue, sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            resultSearchNotification.text = Notification.notLogedIn.rawValue
            tableView.tableFooterView = UIView()
        } else {
            setupView()
            createSearchBar()
            loadDataFromAPI(offset: 0)
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
    
    func loadDataFromAPI(offset: Int) {
        
//        ShopItemService.shared.findAllLoved() { data in
//            guard let data = data else {return }
//            
//            self.listItem = data
//            self.currentListItem = self.listItem
//            self.resultSearchNotification.isHidden = true
//            self.tableView.reloadData()
//        }
    }
    
    @objc
    func loadMoreData() {
//        loadDataFromAPI(offset: listItem.count)
        refresher.endRefreshing()
    }
    
    func performSegueFunc(identifier: String, sender: Any?) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = listItem[index]
            
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
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}



extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favoritesItem.rawValue) as! FavoritesCell
        
        cell.updateView(item: listItem[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromAPI(offset: 0)
    }
}

extension FavoritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegueFunc(identifier: SegueIdentifier.favoriteToDetail.rawValue, sender: indexPath.row)
    }
    
    
}
