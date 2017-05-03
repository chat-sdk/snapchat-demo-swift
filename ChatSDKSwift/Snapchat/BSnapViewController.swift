//
//  BSnapViewController.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 21/04/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import ChatSDKUI

class BSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var path: String?
    var count: Int = 10
    var timer: Timer?
    var deleteBlock: ((Void) -> Void)?
    
    init (imagePath: String) {
        super.init(nibName: nil, bundle: nil)
        path = imagePath
        self.title = "Snap"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL.init(string: path!)
        
        // Initially hide the image view
        hideImage()
        
        // Download the image and when it finished downloading, start the timer
        imageView.sd_setImage(with: url!, completed: {(image , error, cacheType, imageURL) in
            self.showImage()
            self.startTimer()
        })
        
        
    }
    
    func showImage () {
        imageView.isHidden = false
        label.isHidden = false
        activityView.isHidden = true
        activityView.startAnimating()
    }
    
    func hideImage () {
        imageView.isHidden = true
        label.isHidden = true
        activityView.isHidden = false
        activityView.stopAnimating()
    }
    
    func startTimer () {
        updateLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: ({(timer: Timer) -> Void in
            self.updateCount()
        }))
    }
    
    func updateLabel () {
        label.text = String(count)
    }
    
    func updateCount () {
        count = count - 1
        self.updateLabel()
        if(count < 0) {
            self.deleteBlock?()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
