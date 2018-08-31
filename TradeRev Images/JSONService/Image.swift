//
//  Image.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-29.
//  Copyright © 2018 Armin. All rights reserved.
//

struct Image: Decodable{
    let width: Int?
    let height: Int?
    let description: String?
    let likes: Int?
    let urls: [String: String]?
}
