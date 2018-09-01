//
//  ViewControllerExtensions.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-30.
//  Copyright © 2018 Armin. All rights reserved.
//
import UIKit
import Nuke

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceOrientation = UIDevice.current.orientation
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        let ogWidth = Double(images[indexPath.row].width!)
        let ogHeight = Double(images[indexPath.row].height!)
        
        var scaledWidth: Double = 0.0
        var scaledHeight:Double = 0.0
        
        if(deviceOrientation == .portrait){//Use width to determine size
            scaledWidth = Double(screenWidth) * (2.0 / 5.0)
            scaledHeight = scaledWidth * (ogHeight / ogWidth)
        }else if(deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight){// Use height to determine size
            scaledHeight = Double(screenHeight)  * (2.0 / 5.0)
            scaledWidth = scaledHeight * (ogWidth / ogHeight)
        }

        return CGSize(width: scaledWidth, height: scaledHeight)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CollectionImageViewCell
        Nuke.loadImage(with: URL(string: images[indexPath.row].urls!["regular"]!)!, into: cell.imageView)

        return cell
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isInFullScreenMode = true;
        setupFullScreenImage(index: indexPath.row)
        
        
        let attributes: UICollectionViewLayoutAttributes? = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect: CGRect? = attributes?.frame
        let cellFrameInSuperview = collectionView.convert(cellRect ?? CGRect.zero, to: collectionView.superview)
//        print("\(cellFrameInSuperview.origin)")
//        print("FSORIGIN: ", fullScreenImageView.frame.origin)
        animateFullScreen(cellPos: cellFrameInSuperview.origin, cellRect: cellRect!)

        
        fullScreenImageView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        let deviceOrientation = UIDevice.current.orientation
        let device = UIDevice.current.userInterfaceIdiom
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        var leftRightInset: CGFloat = 0
        var inset: UIEdgeInsets
        
        if(deviceOrientation == .portrait){// Use width to determine size
            if(device == .pad){// if iPad make insets bigger
                leftRightInset = screenWidth * (1 / 12)
            }else if(device == .phone){
                leftRightInset = screenWidth * (1 / 15)
            }
        }else if(deviceOrientation == .landscapeLeft || deviceOrientation == .landscapeRight){// Use height to determine size
            if(device == .pad){// if iPad make insets bigger
                leftRightInset = screenHeight * (1 / 10)
            }else if(device == .phone){
                leftRightInset = screenHeight * (1 / 15)
            }
        }
        inset = UIEdgeInsets(top: 20, left: leftRightInset, bottom: 20, right: leftRightInset)
    
        return inset
    }
}


