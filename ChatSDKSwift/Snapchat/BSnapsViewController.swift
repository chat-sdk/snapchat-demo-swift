//
//  BSnapsViewController.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 20/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import ChatSDKCore
import ChatSDKUI
import ChatSDKCoreData

class BSnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override init (nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Set the title and tab bar image
        self.title = "Snap"
        self.tabBarItem.image = UIImage.init(named: "icn_30_snap.png")

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: "BUserCell", bundle: Bundle.chatUI()), forCellReuseIdentifier: "UserCell")
        
        NotificationCenter.default.addObserver(forName: BSnapHandler.BSnapAddedNotification, object: nil, queue: nil, using: ({(n: Notification) -> Void in
            self.reloadData()
        }))

        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "icn_30_snap.png"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(openSnapView(sender:)))
        
        // This is necessary so that the navigation bar and tab bar don't overlap the content
        //self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let snap = BSnapHandler.shared.snaps[indexPath.row]
        
        // Load the snap
        let snapView = BSnapViewController.init(imagePath: snap.path()!)
        snapView.deleteBlock = {
            _ = BSnapHandler.shared.delete(snap: snap)
            self.reloadData()
        }
        present(snapView, animated: true, completion: nil)
        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BSnapHandler.shared.snaps.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! BUserCell
        userCell.statusImageView.isHidden = true
        
        let snap = BSnapHandler.shared.snaps[indexPath.row]
        
        userCell.setUser(snap.user)
        userCell.stateLabel.text = ""
        
        return userCell
    }
    
    func openSnapView (sender: UIBarButtonItem) {
        let snapViewController = BTakeSnapViewController.init(nibName: nil, bundle: nil)
        present(UINavigationController.init(rootViewController: snapViewController), animated: true, completion: nil)
    }
    
    func reloadData () {
        self.tableView.reloadData()
    }

}
