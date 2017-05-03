//
//  BSnapViewController.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 18/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import UIKit
import TGCameraViewController
import ChatSDKCore
import MBProgressHUD

class BTakeSnapViewController: UIViewController, TGCameraDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var snapView: UIView!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // This is necessary so that the navigation bar and tab bar don't overlap the content
        self.edgesForExtendedLayout = []
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(close(sender:)))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI () {
        sendButton.isHidden = photoView.image == nil
        deleteButton.isHidden = photoView.image == nil
        snapView.isHidden = photoView.image != nil
        photoView.isHidden = photoView.image == nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        photoView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        photoView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        // Show the user picker view - this will allow us to send the snap to our contacts
        let friendsListViewController = BInterfaceManager.shared().a.friendsViewControllerWithUsers(toExclude: []);
        
        // Set the action button to Send
        friendsListViewController?.rightBarButtonActionTitle = "Send"

        // Implement the block - this will be called when the user selectes the users and clicks send
        friendsListViewController?.usersToInvite = ({(users: [Any]?, groupName: String?) -> Void in
            
            // When we're about to send the message show a processing indicator
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Sending"
            
            // Send the snap to the users
            _ = BSnapHandler.shared.sendSnap(image: self.photoView.image!, users: users as! [PUser]).promiseKitThen().then {(result: Any?) in
                
                // When it has sent, hide the hud and dismiss the view
                hud.hide(animated: true)
                self.dismiss(animated: true, completion: nil)
                
                return AnyPromise.promiseWithValue(result)
            }
        })
        
        // Show the friends view controller
        let navController = UINavigationController.init(rootViewController: friendsListViewController!)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func snapButtonPressed(_ sender: Any) {
        let navigationController = TGCameraNavigationController.new(with: self)
        present(navigationController!, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        photoView.image = nil
        updateUI()
    }
    
    func close (sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
