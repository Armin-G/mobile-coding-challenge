//
//  ViewController.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-29.
//  Copyright © 2018 Armin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JSONRequestDelegate {

    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myService = JSONService()
        myService.delegate = self
        
        myService.sendRequest()
    }

    func onImageReceive(images: [Image]) {
        self.images = images
        print(self.images)
    }
}

