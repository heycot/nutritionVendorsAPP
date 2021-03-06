//
//  HightRatingController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 2/26/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit
import CCBottomRefreshControl
import GoogleMaps
import Firebase
import PKHUD
import YPImagePicker

class HightRatingController: UIViewController {

    // outlets
    @IBOutlet weak var itemCollection: UICollectionView!
    @IBOutlet weak var resultSearchNotification: UILabel!
    @IBOutlet weak var searchBar: UIButton!
    
    // location manager
    var locationManager = CLLocationManager()
    var didUpdateLocation: Bool = false
    
    // variables
    var listItem = [ShopItemResponse] ()
    var listCategory = [CategoryResponse]()
    
    let headerId = "HeaderID"
    var categoryId = 0
    private var lastContentOffset: CGFloat = 0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = APP_COLOR
        refreshControl.addTarget(self, action: #selector(loadMoreData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCurrentLocation()
        setUpCollectionView()
        registerHeader()

        resultSearchNotification.isHidden = true

        navigationController?.navigationBar.barTintColor = APP_COLOR
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
        
        searchBar.adjustsImageWhenHighlighted = false
    }
    
    func findAllCategory() {
        HUD.show(.progress)
        CategoryService.instance.findAll { (data) in
            guard let data = data else { return }
            
            self.listCategory = data
            self.itemCollection.reloadData()
            HUD.hide()
        }
    }
    
    func loadDataFromAPI(offset: Int) {
        HUD.show(.progress)
        ShopItemService.instance.getHighRatingItem(offset: offset) { data in
            guard let data = data else {return }
            
            self.listItem = data
            HUD.hide()
            self.showData()
        }
    }
    
    func showData() {
        
        listItem.sort {
            if $0.comment_number == $1.comment_number { // first, compare by last names
                return $0.rating! > $1.rating!
            }
            else {
                return $0.comment_number! > $1.comment_number!
            }
        }
        
        
        self.itemCollection.reloadData()
    }
    
    @objc
    func loadMoreData() {
        loadDataFromAPI(offset: listItem.count)
        refresher.endRefreshing()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewItemController {
            let vc = segue.destination as? ViewItemController
            let index = sender as! Int
            vc?.item = listItem[index]
            
        } else if segue.destination is SearchController {
            _ = segue.destination as? SearchController
            
        } else if segue.destination is CategoryController {
            let vc = segue.destination as? CategoryController
            let index = sender as! Int
            vc?.category = listCategory[index]
        }
    }
    
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.highRatingToSearch.rawValue, sender: nil)
    }
}

extension HightRatingController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? listCategory.count : listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.category.rawValue, for: indexPath) as! CategoryCell
                cell.updateView(category: listCategory[indexPath.row])
                return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.highRatingItem.rawValue, for: indexPath) as! CollectionItemCell
            cell.updateView(shopItemRe: listItem[indexPath.row])
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: SegueIdentifier.highRatingToCategory.rawValue, sender: indexPath.row)
        } else {
            performSegue(withIdentifier: SegueIdentifier.highRatingToDetail.rawValue, sender: indexPath.row)
        }
    }
}



extension HightRatingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let cellWidth = (UIScreen.main.bounds.size.width - 50)/3
            return CGSize(width: cellWidth, height: 90)
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
            headerView.updateView(titleStr: NSLocalizedString("Categories", comment: ""))
        } else {
            
            headerView.updateView(titleStr: NSLocalizedString("Foods", comment: "") )
        }
        
       return headerView
  }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
}

// extention for handle user's location
extension HightRatingController {
    
    // MARK - Map, Location
    func setupCurrentLocation() {
        
        // User Location
        locationManager.delegate = self
        
        // Start Location
        accessLocationServices()
    }
    
    func startUpdateLocation() {
        didUpdateLocation = false
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        didUpdateLocation = true
        locationManager.stopUpdatingLocation()
    }
}

extension HightRatingController: CLLocationManagerDelegate {
    
    func handleDidUpdateLocation(location: CLLocation) {
        guard !didUpdateLocation else {
            stopUpdateLocation()
            return
        }
        
        stopUpdateLocation()
        AuthServices.instance.currentLocation = location
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        handleDidUpdateLocation(location: location)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

extension HightRatingController : LocationServicesProtocol {
    func authorizedLocationServices() {
        startUpdateLocation()
    }
}

