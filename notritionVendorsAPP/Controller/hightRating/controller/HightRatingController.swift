//
//  HightRatingController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import CCBottomRefreshControl

class HightRatingController: UIViewController {

    // outlets
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultSearchNotification: UILabel!
    
    
    // variables
    var listItem = [ShopItemResponse] ()
    var currentListItem = [ShopItemResponse]()
    var listCategory = [CategoryResponse]()
    
    let headerId = "HeaderID"
    var categoryId = 0
    private var lastContentOffset: CGFloat = 0
    
    let searchBar = UISearchBar()
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        registerHeader()
        
        resultSearchNotification.isHidden = true
        activityIndicator.color = APP_COLOR
        activityIndicator.startAnimating()
        
        navigationController?.navigationBar.barTintColor = APP_COLOR
        createSearchBar()
        findAllCategory()
        loadDataFromAPI(offset: 0)
    }
    
    func registerHeader() {
        itemCollection.register(UINib(nibName: CellClassName.category.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.category.rawValue)

    }
    
    func setUpCollectionView() {
        
        itemCollection.delegate = self
        itemCollection.dataSource = self
        itemCollection.bottomRefreshControl = refresher
    }
    
    
    func createSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = " Search here"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func findAllCategory() {
        CategoryService.shared.findAll() { data in
            guard let data = data else {return }
            
            self.listCategory = data
        }
    }
    
    func loadDataFromAPI(offset: Int) {
        ShopItemService.shared.getHighRatingItem(offset: offset) { data in
            guard let data = data else {return }
            
            for item in data {
                self.listItem.append(item)
            }
            self.currentListItem = self.listItem
            self.activityIndicator.stopAnimating()
            self.itemCollection.reloadData()
        }
    }
    
    @objc
    func loadMoreData() {
        if categoryId == 0 {
            loadDataFromAPI(offset: listItem.count)
        } else {
            findAllByCategory(categoryId: categoryId, offset: currentListItem.count)
        }
        refresher.endRefreshing()
    }
    
    func findAllByCategory(categoryId: Int, offset: Int) {
        
        
        ShopItemService.shared.findAllByCategory(categoryId: categoryId, offset: offset) { data in
            guard let data = data else {return }
    
            // if current list is the same category => add more alse replace
            if self.categoryId == categoryId {
                for item in data {
                    self.currentListItem.append(item)
                }
                
            } else {
                self.currentListItem = data
                self.categoryId = categoryId
            }
            
            self.activityIndicator.stopAnimating()
            self.itemCollection.reloadData()
        }
        
        func scrollViewDidScroll(scrollView: UIScrollView!) {
            if (self.lastContentOffset > scrollView.contentOffset.y) {
                // move up
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y) {
                // move down
                print("move down")
                loadMoreData()
            }
            
            // update the new position acquired
            self.lastContentOffset = scrollView.contentOffset.y
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = currentListItem[index]
        } else if segue.destination is SearchController {
            let vc = segue.destination as? SearchController
            vc?.listItem = currentListItem
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

extension HightRatingController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? listCategory.count : currentListItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.category.rawValue, for: indexPath) as! CategoryCell
                cell.updateView(Category: listCategory[indexPath.row])
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.highRatingItem.rawValue, for: indexPath) as! CollectionItemCell
            cell.updateView(shopItemRe: currentListItem[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            findAllByCategory(categoryId: listCategory[indexPath.row].id!, offset: 0)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            performSegue(withIdentifier: SegueIdentifier.detailItem.rawValue, sender: indexPath.row)
        }
    }
}


extension HightRatingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellWidth = (UIScreen.main.bounds.size.width - 50)/3
            return CGSize(width: cellWidth, height: 60)
        } else {
            let cellWidth = (UIScreen.main.bounds.size.width - 30)/2
            return CGSize(width: cellWidth, height: 175)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderCollectionCell
        if indexPath.section == 0 {
            headerView.updateView(titleStr: "Categories")
        } else {
            
            headerView.updateView(titleStr: "Foods")
        }
        
       return headerView
  }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}



// handle UISearchBar
extension HightRatingController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: SegueIdentifier.highRatingToSearch.rawValue, sender: nil)
    }
    
}


