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
                setFullScreenSizes(mode: .landscapeLeft)
            }

            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {// Portrait
                setFullScreenSizes(mode: .portrait)
            }
        }
    }

    //Updates the UIImageView in full screen mode to maximize screen usage while keeping original image aspect ratio
    func setFullScreenSizes(mode: UIDeviceOrientation){
        let screenHeight = Double(fullScreenImageView.bounds.size.height)
        let screenWidth = Double(fullScreenImageView.bounds.size.width)
        let ogHeight = Double(images[myDefaults.integer(forKey: "full_screen_image_id")].height!)
        let ogWidth = Double(images[myDefaults.integer(forKey: "full_screen_image_id")].width!)

        var scaledHeight: Double = 0.0
        var scaledWidth: Double = 0.0
        
        if(mode == .portrait){
            scaledWidth = screenWidth
            scaledHeight = scaledWidth * ogHeight / ogWidth
        }else{
            scaledHeight = screenHeight * 0.8
            scaledWidth = scaledHeight * ogWidth / ogHeight
        }
        fullScreenImage.bounds.size = CGSize(width: scaledWidth, height: scaledHeight)
    }

    //Delegate function to update collectionview once JSONService has successfully retrieved images
    func onImageReceive(images: [Image]) {
        self.images = images
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    @IBAction func exitFullScreen(_ sender: Any) {
        isInFullScreenMode = false
        fullScreenImageView.isHidden = true
        
        let i = IndexPath(item: myDefaults.integer(forKey: "full_screen_image_id"), section: 0)
        imageCollectionView.reloadData()
        imageCollectionView.scrollToItem(at: i, at: .centeredVertically, animated: true)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index - 1
        
        if(index == 0){// Can't go left anymore
            return
        }else{
            setupNewImage(nextIndex: nextIndex)
        }
    }
    

    @IBAction func swipeLeft(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index + 1

        if(index == images.count - 1){// Can't go right anymore
            return
        }else{
            setupNewImage(nextIndex: nextIndex)
        }
    }
    
    // Used by the swipe gestures to setup and insert the next image that you swiped to
    func setupNewImage(nextIndex: Int){
        myDefaults.set(nextIndex, forKey: "full_screen_image_id")
        setFullScreenSizes(mode: UIDevice.current.orientation)
        Nuke.loadImage(with: URL(string: images[nextIndex].urls!["regular"]!)!, into: fullScreenImage)
        let imageDesc = images[nextIndex].description ?? "No description available"
        let desc = "\"" + imageDesc  + "\""
        fullScreenImageDesc.text = desc
        fullScreenImage.image = fullScreenImage.image?.resizeImage(newSize: fullScreenImage.bounds.size)
    }
}


