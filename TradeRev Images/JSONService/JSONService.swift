//
//  JSONService.swift
//  TradeRev Images
//
//  Created by Armin Gurdic on 2018-08-29.
//  Copyright © 2018 Armin. All rights reserved.
//

import Foundation

class JSONService{
    var delegate: JSONRequestDelegate? = nil
    
    func sendRequest(){
        let jsonURLString = "https://api.unsplash.com/photos/curated/?client_id=0badee5cd118448ae821afb785075e786cfbf8b46911cc5d0526e5cf3eb7a9e8"
        
        guard let url = URL(string: jsonURLString) else{
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else{
                return
            }
            
            do{
                let images = try JSONDecoder().decode([Image].self, from: data)
                self.delegate?.onImageReceive(images: images)
            }catch let jsonErr{
                print("Error serializing json: ", jsonErr)
            }
            
            }.resume()
    }
}

