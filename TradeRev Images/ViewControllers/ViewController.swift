//
//  ViewController.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-29.
//  Copyright © 2018 Armin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JSONRequestDelegate {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    var images: [Image] = []
    var imageCollectionViewFlowLayout: UICollectionViewFlowLayout?
    let myDefaults = UserDefaults.standard
    
    //Fullscreen Image Variables
    @IBOutlet weak var fullScreenImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var fullScreenImageDesc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myDefaults.register(defaults: ["full_screen_image_id" : 0])
    
        let myService = JSONService()
        myService.delegate = self
        
        myService.sendRequest()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        headerView.dropShadow()
    }

    func onImageReceive(images: [Image]) {
        self.images = images
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    @IBAction func exitFullScreen(_ sender: Any) {
        fullScreenImageView.isHidden = true
    }
    @IBAction func swipeRight(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index - 1
        
        if(index == 0){// Can't go left anymore
            return
        }else{
            let imageStringURL = images[nextIndex].urls!["small"]
            let imageURL = URL(string: imageStringURL!)!
            let imageData = try! Data(contentsOf: imageURL)
            
            fullScreenImage.image = UIImage(data: imageData)
            let imageDesc = images[nextIndex].description ?? "No description available"
            let desc = "\"" + imageDesc  + "\""
            fullScreenImageDesc.text = desc
        }
        myDefaults.set(nextIndex, forKey: "full_screen_image_id")
    }
    @IBAction func swipeLeft(_ sender: Any) {
        let index = myDefaults.integer(forKey: "full_screen_image_id")
        let nextIndex = index + 1

        if(index == images.count - 1){// Can't go right anymore
            return
        }else{
            let imageStringURL = images[nextIndex].urls!["small"]
            let imageURL = URL(string: imageStringURL!)!
            let imageData = try! Data(contentsOf: imageURL)
            
            fullScreenImage.image = UIImage(data: imageData)
            let imageDesc = images[nextIndex].description ?? "No description available"
            let desc = "\"" + imageDesc  + "\""
            fullScreenImageDesc.text = desc
        }
        myDefaults.set(nextIndex, forKey: "full_screen_image_id")
    }
}


