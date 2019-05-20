//
//  CategoryController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/14/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import PKHUD

class CategoryController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var searchBar: UIButton!
    
    var currentListItem = [ShopItemResponse]()
    var category  = CategoryResponse()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category.name ?? ""
        self.notification.isHidden = true
        setupView()
        loadDataFromAPI(offset: 0)
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegueFunc(identifier: SegueIdentifier.categoryToSearch.rawValue, sender: nil)
    }
    
    
    func setupView() {
        navigationController?.navigationBar.barTintColor = APP_COLOR
        searchBar.adjustsImageWhenHighlighted = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.bottomRefreshControl = refresher
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 100
    }
    
    func loadDataFromAPI(offset: Int) {
        HUD.show(.progress)
        ShopItemService.instance.findAllByCategory(categoryID: category.id ?? "", offset: offset) { (data) in
            guard let data = data else {return }
            
            for item in data {
                self.currentListItem.append(item)
            }
            HUD.hide()
            self.tableView.reloadData()
        }
    }
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: currentListItem.count)
        refresher.endRefreshing()
    }
    
    func performSegueFunc(identifier: String, sender: Any?) {
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = currentListItem[index]
            
            navigationItem.backBarButtonItem = backItem
        }  else if segue.destination is LoginController {
            _ = segue.destination as? LoginController
            
            navigationItem.backBarButtonItem = backItem
            
        } else if segue.destination is SearchController {
            navigationItem.backBarButtonItem = backItem
        }
    }
    
}


extension CategoryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentListItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.categoryShopItemCell.rawValue) as! CategoryUITableCell
        
        cell.updateView(item: currentListItem[indexPath.row])
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.viewDidLoad()
        super.viewWillAppear(true)
        tableView.reloadData()
    }
}

extension CategoryController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegueFunc(identifier: SegueIdentifier.categoryToDetail.rawValue, sender: indexPath.row)
    }
    
    
}
