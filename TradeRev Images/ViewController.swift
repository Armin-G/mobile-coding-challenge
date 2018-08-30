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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageCollectionViewFlowLayout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        imageCollectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
        imageCollectionViewFlowLayout?.invalidateLayout()
        
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

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CollectionImageViewCell
        
        let imageStringURL = images[indexPath.row].urls!["thumb"]
        let imageURL = URL(string: imageStringURL!)!
        let imageData = try! Data(contentsOf: imageURL)
        
        cell.imageView.image = UIImage(data: imageData)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(images[indexPath.item].description)
    }
}
