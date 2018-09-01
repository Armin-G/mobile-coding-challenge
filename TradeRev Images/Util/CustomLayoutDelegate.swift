//
//  CustomLayoutDelegate.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-31.
//  Copyright © 2018 Armin. All rights reserved.
//
import UIKit

protocol CustomLayoutDelegate: class{
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGSize
}
