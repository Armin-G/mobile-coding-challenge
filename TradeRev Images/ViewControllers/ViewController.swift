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
    var imageCollectionViewFlowLayout: UICollectionViewFlowLayout?
    let myDefaults = UserDefaults.standard
    var isInFullScreenMode = false
    
    //Fullscreen Image Variables
    @IBOutlet weak var fullScreenImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var fullScreenImageDesc: UILabel!
    @IBOutlet weak var fullScreenImageLikes: UILabel!
    @IBOutlet weak var fullScreenImageExitButton: UIButton!
    
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
    
    /* Used to change fullscreen image sizing based on screen orientation */
    @objc func rotated(){
        if(isInFullScreenMode){
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {//Landscape
                setFullScreenSizes(mode: .landscapeLeft, index: myDefaults.integer(forKey: "full_screen_image_id"))
            }

            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {// Portrait
                setFullScreenSizes(mode: .portrait, index: myDefaults.integer(forKey: "full_screen_image_id"))
            }
        }
    }

    //Delegate function to update collectionview once JSONService has successfully retrieved images
    func onImageReceive(images: [Image]) {
        self.images = images
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    

    
    @IBAction func swipeRight(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index - 1
        
        if(index == 0){// Can't go left anymore
            return
        }else{
            setupFullScreenImage(index: nextIndex)
        }
    }
    

    @IBAction func swipeLeft(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index + 1

        if(index == images.count - 1){// Can't go right anymore
            return
        }else{
            setupFullScreenImage(index: nextIndex)
        }
    }
    
    // Used to set up the full screen image and it's information
    func setupFullScreenImage(index: Int){
        myDefaults.set(index, forKey: "full_screen_image_id")
        setFullScreenSizes(mode: UIDevice.current.orientation, index: index)
        Nuke.loadImage(with: URL(string: images[index].urls!["regular"]!)!, into: fullScreenImage)
        let imageDesc = images[index].description ?? "No description available"
        let likeCount = images[index].likes ?? 0
        let likeDesc = "\(likeCount) likes"
        let desc = "\"\(imageDesc)\""
        fullScreenImageDesc.text = desc
        fullScreenImageLikes.text = likeDesc
        fullScreenImage.image = fullScreenImage.image?.resizeImage(newSize: fullScreenImage.bounds.size)
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
    
    //Updates the UIImageView in full screen mode to maximize screen usage while keeping original image aspect ratio
    func setFullScreenSizes(mode: UIDeviceOrientation, index: Int){
        let screenHeight = Double(fullScreenImageView.bounds.size.height)
        let screenWidth = Double(fullScreenImageView.bounds.size.width)
        let ogHeight = Double(images[index].height!)
        let ogWidth = Double(images[index].width!)
        
        var scaledHeight: Double = 0.0
        var scaledWidth: Double = 0.0
        
        if(mode == .portrait){
            scaledWidth = screenWidth
            scaledHeight = scaledWidth * ogHeight / ogWidth
        }else{
            scaledHeight = screenHeight
            scaledWidth = scaledHeight * ogWidth / ogHeight
        }
        fullScreenImage.bounds.size = CGSize(width: scaledWidth, height: scaledHeight)
        fullScreenImageExitButton.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func exitFullScreen(_ sender: Any) {
        isInFullScreenMode = false

        self.fullScreenImage.isHidden = true
        self.fullScreenImageLikes.isHidden = true
        self.fullScreenImageDesc.isHidden = true
        self.fullScreenImageExitButton.isHidden = true
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
    
    func animateFullScreen(cellPos: CGPoint, cellRect: CGRect){
        cellPosition = cellPos
        cellSize = cellRect

        top.constant = cellPos.y - self.view.safeAreaInsets.top/2
        leading.constant = cellPos.x
        trailing.constant = (self.view.frame.size.width - (leading.constant + cellSize.width))
        bottom.constant = (self.view.frame.size.height - (top.constant + cellSize.height))
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.top.constant = 0
            self.bottom.constant = 0
            self.leading.constant = 0
            self.trailing.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {(value: Bool) in
            self.fullScreenImage.isHidden = false
            self.fullScreenImageLikes.isHidden = false
            self.fullScreenImageDesc.isHidden = false
            self.fullScreenImageExitButton.isHidden = false
        })
    }
}


