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
    
    //Fullscreen Image Variables
    @IBOutlet weak var fullScreenImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var fullScreenImageDesc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
}


