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
        let jsonURLString = "https://api.unsplash.com/photos/curated/?client_id=c091e96466487072b7924117c85475761f6d14b5c8373fa1becbfc0904455385"
        
        guard let url = URL(string: jsonURLString) else{
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //check response status 200 OK
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

