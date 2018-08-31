//
//  ResizeImage.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-30.
//  Copyright © 2018 Armin. All rights reserved.
//

import UIKit

extension UIImage{
    func resizeImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
