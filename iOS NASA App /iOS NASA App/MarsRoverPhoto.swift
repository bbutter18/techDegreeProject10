//
//  MarsRoverPhoto.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit


//Model for handling MarsRoverPhoto JSON objects
struct MarsRoverPhoto {
    let sol: Int
    let imageURL: String 
}


//conformance to the JSONDecodable protocol 
extension MarsRoverPhoto: JSONDecodable {
    init?(json: [String: Any]) {
        struct Key {
            static let sol = "sol"
            static let imageURL = "img_src"
            
        }
        
        guard let solValue = json[Key.sol] as? Int,
            let imageValue = json[Key.imageURL] as? String else {
                return nil
        }
        
        self.sol = solValue
        self.imageURL = imageValue
        
    }
    
}




