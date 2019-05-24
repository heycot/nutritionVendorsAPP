//
//  Message.swift
//  notritionVendorsAPP
//
//  Created by Tu (Callie) T. NGUYEN on 5/24/19.
//  Copyright © 2019 Tu (Callie) T. NGUYEN. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
//    var kind: MessageKind
    
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: Sender
    
    var data: MessageKind {
        if let image = image {
            return .photo(image as! MediaItem)
        } else {
            return .text(content)
        }
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: UserResponse, content: String) {
        sender = Sender(id: user.id ?? "", displayName: AppSettings.displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: UserResponse, image: UIImage) {
        sender = Sender(id: user.id ?? "", displayName: AppSettings.displayName)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
    
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
