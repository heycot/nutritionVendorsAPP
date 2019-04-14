//
//  CategoryController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/14/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class CategoryController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    
    var listItem = [ShopItemResponse]()
    var currentListItem = [ShopItemResponse]()
    
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
    
    @IBAction func searchBarPressed(_ sender: Any) {
        performSegueFunc(identifier: SegueIdentifier.favoritesToSearch.rawValue, sender: nil)
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
            
        } else if segue.destination is SearchController {
            let vc = segue.destination as? SearchController
            vc?.listItem = currentListItem
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


extension CategoryController : UITableViewDataSource {
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

extension CategoryController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegueFunc(identifier: SegueIdentifier.favoriteToDetail.rawValue, sender: indexPath.row)
    }
    
    
}
