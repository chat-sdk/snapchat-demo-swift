//
//  BFirebaseQueueHandler.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 19/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import RXPromise

protocol BFirebaseQueueDelegate {
    
}

/*
 * A queue handler
 */
class BFirebaseQueueHandler  {
    
    var deleteWhenRead: Bool = false
    
    init () {
        
    }
    
    func add (queue: String, item: [Any]) -> RXPromise {
        let promise = RXPromise.init()
        
        
        
        
        return promise
    }
    
    func on (queue: String) {
        
    }

    func off (queue: String) {
        
    }
    
}
