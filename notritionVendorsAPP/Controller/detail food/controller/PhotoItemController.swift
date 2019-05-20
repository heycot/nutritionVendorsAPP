//
//  PhotoItemController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 3/29/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class PhotoItemController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoNotification: UILabel!
    
    var images = [String]()
    var shopItemID = ""
    var imgArr = [CustomImageView]()
    var indexForShow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        self.title = "Photos \(images.count )"
        self.navigationItem.backBarButtonItem?.title = "Back"
        setupData()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    func setupNotification() {
        if images.count == 0 {
            photoNotification.textColor = APP_COLOR
            photoNotification.text = "No photo!"
            photoNotification.isHidden = false
        }
    }
    
    func setupData() {
        for item in images {
            let image = CustomImageView()
            let folder = ReferenceImage.shopItem.rawValue + shopItemID + "/\(item)"
            image.displayImage(folderPath: folder)
            imgArr.append(image)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailPhotoController {
            let vc = segue.destination as? DetailPhotoController
//            let arr = showImage()
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            vc?.imgArr = imgArr
            vc?.indexWillShow = indexForShow
        }
        
    }
    
    func showImage() -> [CustomImageView] {
        
        var arr = [CustomImageView]()
        arr.append(imgArr[indexForShow])
        
        for i in 0 ..< imgArr.count {
            if indexForShow != i {
                arr.append(imgArr[i])
            }
        }
        
        return arr
    }
    
}

extension PhotoItemController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.photoItem.rawValue, for: indexPath) as! PhotoItemCell
        
        cell.updateView(image: imgArr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        indexForShow = indexPath.row
       performSegue(withIdentifier: SegueIdentifier.photosToDetailPhoto.rawValue, sender: nil)
    }
}

extension PhotoItemController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.size.width - 50)/3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
}

