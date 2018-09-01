//
//  ViewControllerHelperFunctions.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-09-01.
//  Copyright © 2018 Armin. All rights reserved.
//
import UIKit
import Nuke

// Holds the functions used to facilitate transition / setup of fullscreen mode
extension ViewController{
    // Used to change fullscreen image sizing based on screen orientation
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
    
    // Used to set up the full screen image and it's information
    func setupFullScreenImage(index: Int){
        myDefaults.set(index, forKey: "full_screen_image_id")
        setFullScreenSizes(mode: UIDevice.current.orientation, index: index)
        Nuke.loadImage(with: URL(string: images[index].urls!["regular"]!)!, into: fullScreenImage)
        
        let imageDesc = images[index].description ?? "No description available"
        let likeCount = images[index].likes ?? 0
        let likeDesc = "\(likeCount) likes"
        let desc = "\"\(imageDesc)\""
        let imageIndicator = "\(index + 1) of \(images.count)"
        
        fullScreenImageDesc.text = desc
        fullScreenImageLikes.text = likeDesc
        fullScreenImage.image = fullScreenImage.image?.resizeImage(newSize: fullScreenImage.bounds.size)
        fullScreenImageIndicator.text = imageIndicator
        
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
    
    // Animates image from cell to fullscreen mode
    func animateFullScreen(cellPos: CGPoint, cellRect: CGRect){
        cellPosition = cellPos
        cellSize = cellRect
        
        //Set fullscreen to cells location and size
        top.constant = cellPos.y - self.view.safeAreaInsets.top/2
        leading.constant = cellPos.x
        trailing.constant = (self.view.frame.size.width - (leading.constant + cellSize.width))
        bottom.constant = (self.view.frame.size.height - (top.constant + cellSize.height))
        self.view.layoutIfNeeded()
        
        //Animate to fullscreen
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
            self.fullScreenImageIndicator.isHidden = false
        })
    }
}
