//
//  UserFirebase.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/17/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserFireBase {
    func signup(name: String, email: String, password: String, completion: @escaping (Bool?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
            }
            else{
                let date = Date().timeIntervalSince1970
                let userProfile = ["name": name,
                                   "email": email,
                                   "phone": "",
                                   "birthday": 0,
                                   "create_date": date,
                                   "address": "" ] as [String : Any]
                
                let db = Firestore.firestore()
                db.collection("user_profile").document(authResult!.user.uid).setData(userProfile) { err in
                    var result = true
                    if let err = err {
                        result = false
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        //Đoạn này em có thể lưu user profile vào user default rồi nhảy tiếp qua home screen
                        //Ở bước này thì em có thể lưu user email, user name, user avatar. Hết. Ko đc lưu mật khẩu nha
                    }
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
            }
        }
    }
    
    func signin(email: String, password: String, completion: @escaping (Bool?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
            } else {
                if let user = authResult?.user {
                    let uid = user.uid
                    
                    //Truy cập vào user_profile để lấy user profile với uid
                    let db = Firestore.firestore()
                    let docRef = db.collection("user_profile").document(uid)
                    
                    docRef.getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            //                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            //
                            //                            print("Document data: \(dataDescription)")
                            //                            print(document.data())
                            //                            //Đoạn này em maping cái profile thành User object của em nha, hoặc lưu vào
                            //em thử map Data vào như em làm bên app kia coi có đc ko:
                            let jsonData = try? JSONSerialization.data(withJSONObject: document.data() as Any)
                            do {
                                _ = try JSONDecoder().decode(UserResponse.self, from: jsonData!)
                            } catch let jsonError {
                                print("Error serializing json:", jsonError)
                            }
                            
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        } else {
                            print("User have no profile")
                        }
                    })
                }
            }
        }
    }
}
