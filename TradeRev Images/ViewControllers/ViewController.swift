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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.imageCollectionViewFlowLayout = self.imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        self.imageCollectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        self.imageCollectionViewFlowLayout?.invalidateLayout()
        
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
    
}


