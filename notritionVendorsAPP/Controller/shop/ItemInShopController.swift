//
//  ItemInShopController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/14/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import CoreLocation

class ItemInShopController: UIViewController {
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopAddress: UILabel!
    @IBOutlet weak var shopTimeOpen: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var shop = ShopResponse()
    var listItem = [ShopItemResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShopInfor()
        setupView()
        loadDataFromAPI(offset: 0)
    }
    
    func viewShopInfor() {
        shopName.text = shop.name!
        shopAddress.text = shop.location?.address!
        shopTimeOpen.text = shop.time_open! + " - " + shop.time_close!
    }
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
    }
    
    func loadDataFromAPI(offset: Int) {
        
        ShopItemService.shared.findAllByShop(shopId: shop.id!, offset: offset) { data in
            guard let data = data else {return }
            
            for item in data {
                self.listItem.append(item)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: listItem.count)
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
            
        } else if segue.destination is SearchController {
            let vc = segue.destination as? SearchController
//            vc?.listItem = listItem
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

extension ItemInShopController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.itemInShop.rawValue) as! ItemInShopCell
        
        cell.updateView(item: listItem[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension ItemInShopController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegueFunc(identifier: SegueIdentifier.favoriteToDetail.rawValue, sender: indexPath.row)
    }
    
    
}
