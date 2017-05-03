//
//  BSnap.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 19/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import ChatSDKCore

class BSnap: NSObject {
    
    static let imageType: String = "image"
    static let videoType: String = "video"
    
    var data: [String: String]?
    var user: PUser?
    
    convenience init (theData: [String: String]) {
        self.init()
        data = theData
    }
    
    override init () {
        super.init()
        data = [String: String]()
    }
    
    func setPath (path: String?) {
        data?["path"] = path
    }
    
    func path () -> String? {
        return data?["path"]
    }
    
    func setType (type: String) {
        data?["type"] = type
    }
    
    func type () -> String? {
        return data?["type"]
    }
    
    func setId (id: String) {
        data?["id"] = id
    }
    
    func id () -> String? {
        return data?["id"]
    }

    func setSenderId (id: String) {
        data?["sender-id"] = id
    }
    func setTimestamp (timestamp: String) {
        data?["timestamp"] = timestamp
    }
    
    func timestamp () -> String? {
        return data?["timestamp"]
    }
    
    func senderId () -> String? {
        return data?["sender-id"]
    }

    func value() -> [String: String]? {
        return data
    }
    
}
