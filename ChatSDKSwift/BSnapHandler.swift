//
//  BSnapHandler.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 19/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import RXPromise
import ChatSDKCore
import ChatSDKFirebaseAdapter

class BSnapHandler {
    
    static let BSnapAddedNotification = NSNotification.Name(rawValue: "BSnapAddedNotification")
    
    let snapPath: String = "snaps"
    var snaps = [BSnap]()
    var isOn: Bool = false
    
    static let shared = BSnapHandler.init()
    
    init () {
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: bNotificationAuthenticationComplete),
                                               object: nil,
                                               queue: nil,
                                               using: ({(n: Notification) -> Void in
            self.on()
        }))
        
    }
    
    func sendSnap (image: UIImage, users: [PUser]) -> RXPromise {
        
        let imageData: Data? = UIImageJPEGRepresentation(image, 0.5)
        
        // First we need to upload the image
        let block = BNetworkManager.shared().a.upload().uploadFile(imageData, withName: "snap.jpg", mimeType: "image/jpg").thenOnMain
        
        // Once it's uploaded we can get the image path
        return block!({(response: Any) -> Any? in

            var promises = [RXPromise]()

            if let dict = response as? Dictionary<String, String> {
                
                let path = dict[bFilePath]
                
                let snap = BSnap.init()
                
                snap.setPath(path: path)
                snap.setType(type: BSnap.imageType)
                
                for user: PUser in users {
                    promises.append(self.sendSnap(snap: snap, user: user))
                }

            }
            
            return RXPromise.all(promises)
        }, {(error: Error?) -> Any? in

            return nil
        })!
        
    }
    
    func sendSnap (snap: BSnap, user: PUser) -> RXPromise {
        let promise = RXPromise.init()
        
        var data = snap.value() as [String: Any]?
        data?["timestamp"] = FIRServerValue.timestamp()
        
        ref(userID: user.entityID()).childByAutoId().setValue(data,
                                                              withCompletionBlock: ({(error: Error?, ref: FIRDatabaseReference) -> Void in
                                                                if error == nil {
                                                                    promise.resolve(withResult: nil)
                                                                }
                                                                else {
                                                                    promise.reject(withReason: error)
                                                                }
        }))
        

        return promise;
    }
    
    func on () {
        if isOn {
            return
        }
        isOn = true
        
        myRef().observe(FIRDataEventType.childAdded, with: ({(snapshot: FIRDataSnapshot) -> Void in
            if snapshot.value != nil {
                if let data = snapshot.value as? [String: String] {
                    let snap = BSnap.init(theData: data)
                    snap.setId(id: snapshot.key)
                    snap.setSenderId(id: BNetworkManager.shared().a.core().currentUserModel().entityID())
                    
                    let user = BStorageManager.shared().a.fetchOrCreateEntity(withID: snap.senderId(), withType: bUserEntity) as! PUser
                    snap.user = user
                    
                    let promise = CCUserWrapper.user(withModel: user).metaOn()
                    _ = promise!.promiseKitThen().then { (result: Any?) in
                        
                        // Add the snap to the list of snaps
                        self.snaps.append(snap)

                        // Post a notification that a new snap has been added
                        NotificationCenter.default.post(name: BSnapHandler.BSnapAddedNotification, object: nil)
                        return AnyPromise.promiseWithValue(result)
                    }
                    
//                    // This will make sure that we have the user's details
//                    let block = CCUserWrapper.user(withModel: user).metaOn().thenOnMain
//                    _ = block!({(result: Any?) -> Any? in
//                        
//                        // Add the snap to the list of snaps
//                        self.snaps.append(snap)
//                        
//                        // Post a notification that a new snap has been added
//                        NotificationCenter.default.post(name: BSnapHandler.BSnapAddedNotification, object: nil)
//                        return nil
//                    }, nil)
//
                }
            }
        }))
    }
    
    func delete (snap: BSnap) -> RXPromise {
        // Delete snap from list
        
        if let index = snaps.index(of: snap) {
            snaps.remove(at: index)
        }
        
        let promise = RXPromise.init()
        myRef().child(snap.id()).removeValue(completionBlock: ({(error: Error?, ref: FIRDatabaseReference) -> Void in
            if error == nil {
                promise.resolve(withResult: nil)
            }
            else {
                promise.reject(withReason: error)
            }
        }))
        return promise
    }
    
    func off () {
        isOn = false
        myRef().removeAllObservers()
    }
    
    func ref(userID: String) -> FIRDatabaseReference {
        return ref().child(userID)
    }
    
    func ref () -> FIRDatabaseReference {
        return FIRDatabaseReference.firebaseRef().child(snapPath)
    }
    
    func myRef () -> FIRDatabaseReference {
        let userId = BNetworkManager.shared().a.core().currentUserModel().entityID()
        return ref(userID: userId!)
    }
    
    
}
