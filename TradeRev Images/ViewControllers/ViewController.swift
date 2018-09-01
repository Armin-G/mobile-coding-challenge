//
//  ViewController.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-29.
//  Copyright © 2018 Armin. All rights reserved.
//

import UIKit
import Nuke

class ViewController: UIViewController, JSONRequestDelegate {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    var images: [Image] = []
    let myDefaults = UserDefaults.standard
    var isInFullScreenMode = false
    
    //Fullscreen Image Variables
    @IBOutlet weak var fullScreenImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var fullScreenImageDesc: UILabel!
    @IBOutlet weak var fullScreenImageLikes: UILabel!
    @IBOutlet weak var fullScreenImageExitButton: UIButton!
    @IBOutlet weak var fullScreenImageIndicator: UILabel!
    
    //Fullscreen image animation positions and size variables
    var cellPosition: CGPoint!
    var cellSize: CGRect!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDefaults.register(defaults: ["full_screen_image_id" : 0])
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        let myService = JSONService()
        myService.delegate = self
        myService.sendRequest()
    }
    
    override func viewDidLayoutSubviews() {
        headerView.dropShadow()
    }

    //Delegate function to update collectionview once JSONService has successfully retrieved images
    func onImageReceive(images: [Image]) {
        self.images = images
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }

    //Full screen swipe right gesture action
    @IBAction func swipeRight(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        var nextIndex = index - 1
        
        if(index == 0){// reach first image, wrap around to last image
            nextIndex = images.count - 1
        }
        setupFullScreenImage(index: nextIndex)
    }
    
    //Full screen swipe left gesture action
    @IBAction func swipeLeft(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        var nextIndex = index + 1

        if(index == images.count - 1){// reached last image, wrap around to first image
            nextIndex = 0
        }
        setupFullScreenImage(index: nextIndex)
    }
    
    //Exit fullscreen button action
    @IBAction func exitFullScreen(_ sender: Any) {
        isInFullScreenMode = false

        fullScreenImage.isHidden = true
        fullScreenImageLikes.isHidden = true
        fullScreenImageDesc.isHidden = true
        fullScreenImageExitButton.isHidden = true
        fullScreenImageIndicator.isHidden = true

        //Animate back to cell
        UIView.animate(withDuration: 0.25, animations: {
            self.top.constant = self.cellPosition.y - self.view.safeAreaInsets.top/2
            self.leading.constant = self.cellPosition.x
            self.trailing.constant = (self.view.frame.size.width - (self.leading.constant + self.cellSize.width))
            self.bottom.constant = (self.view.frame.size.height - (self.top.constant + self.cellSize.height))
            self.view.layoutIfNeeded()
        }, completion: {(value: Bool) in
            self.fullScreenImageView.isHidden = true
            self.top.constant = 0
            self.bottom.constant = 0
            self.leading.constant = 0
            self.trailing.constant = 0
            self.view.layoutIfNeeded()
            let i = IndexPath(item: self.myDefaults.integer(forKey: "full_screen_image_id"), section: 0)
            self.imageCollectionView.reloadData()
            self.imageCollectionView.scrollToItem(at: i, at: .centeredVertically, animated: true)
        })
    }
}


