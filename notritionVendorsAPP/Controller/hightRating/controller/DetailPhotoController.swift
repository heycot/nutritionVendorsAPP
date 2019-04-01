//
//  DetailPhotoController.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 4/1/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import UIKit

class DetailPhotoController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgArr = [CustomImageView]()
    var indexWillShow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos (" + String(imgArr.count) + ")"

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension DetailPhotoController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.DetailPhoto.rawValue, for: indexPath) as! DetailPhotoCell
        
        cell.updateView(image: imgArr[indexPath.row])
        
        return cell
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //auto selected 1st item
        let indexPathForFirstRow = IndexPath(row: indexWillShow, section: 0)
        self.collectionView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.indexWillShow, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        }
    }
}


extension DetailPhotoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.size.width - 20)
        let cellHeight = UIScreen.main.bounds.size.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
}
