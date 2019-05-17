

//
//  ImageFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase


class ImageFirebase {
    static let instance = ImageFirebase()
    
//    func uploadMedia(image: UIImage, reference: String, completion: @escaping (_ url: String?) -> Void) {
//        // Points to the root reference
//        let storageRef = Storage.storage().reference()
//
//        let data = image.jpeg(UIImage.JPEGQuality.lowest)
//
//        // Create a reference to the file you want to upload
//        let riversRef = storageRef.child("images/" + reference)
//
//        // Upload the file to the path "images/rivers.jpg"
//        _ = riversRef.putData(data!, metadata: nil) { (metadata, error) in
//            guard metadata != nil else {
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//
//                return
//            }
//            // Metadata contains file metadata such as size, content-type.
//            //            let size = metadata.size
//            // You can also access to download URL after upload.
//            riversRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    completion(downloadURL.absoluteString)
//                }
//
//            }
//        }
//
//    }
}
