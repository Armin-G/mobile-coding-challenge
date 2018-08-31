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
}


