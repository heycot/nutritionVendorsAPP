//
//  FavoritesViewController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/6/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import PKHUD

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultSearchNotification: UILabel!
    @IBOutlet weak var searchBar: UIButton!
    
    var favoritesList = [FavoritesResponse]()
    var selectedItem = ShopItemResponse()
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkLogIn() {
        
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
    
    @IBAction func searchBarPressed(_ sender: Any) {
        performSegueFunc(identifier: SegueIdentifier.favoritesToSearch.rawValue, sender: nil)
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        
        searchBar.adjustsImageWhenHighlighted = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
    }
    
    
    func loadDataFromAPI(offset: Int, isLoadMore: Bool) {
        HUD.show(.progress)
        
        FavoritesService.instance.getAllLovedByUser { (data) in
            guard var data = data else {return }
            
            // check listitem is already have
            if data.count == 0, self.favoritesList.count == 0{
                HUD.hide()
                self.resultSearchNotification.isHidden = false
                self.resultSearchNotification.text = Notification.noData.rawValue
            } else {
                data.sort(by: {$0.update_date! > $1.update_date! })
                
                //if load more data => add to listItem else replace listItem
                if isLoadMore {
                    for i in 0 ..< data.count {
                        self.favoritesList.append(data[i])
                    }
                } else {
                    self.favoritesList = data
                }
                
                HUD.hide()
                self.resultSearchNotification.isHidden = true
                self.tableView.reloadData()
            }
            
        }
    }
    
    func getShopItemByID(index: Int) {
        ShopItemService.instance.getOneById(shop_item_id: favoritesList[index].shop_item_id ?? "") { (data) in
            guard let data = data else { return }
            
            self.selectedItem = data
            self.performSegueFunc(identifier: SegueIdentifier.favoriteToDetail.rawValue, sender: nil)
        }
    }
    
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: favoritesList.count, isLoadMore: true)
        refresher.endRefreshing()
    }

    func performSegueFunc(identifier: String, sender: Any?) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            vc?.item = selectedItem
            
        }  else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
        } else if segue.destination is SearchController {
            _ = segue.destination as? SearchController
        }
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

extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.favoritesItem.rawValue) as! FavoritesCell
        
        cell.updateView(item: favoritesList[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkLogIn()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension FavoritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.getShopItemByID(index: indexPath.row)
    }
    
    
}
