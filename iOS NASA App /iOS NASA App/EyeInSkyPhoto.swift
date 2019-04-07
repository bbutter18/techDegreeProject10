//
//  EyeInSkyPhoto.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/25/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit


//Model for handling EyeInTheSkyPhoto JSON objects
struct EyeInSkyPhoto {
    
    let id: String
    let imageURL: String

}

//conformance to the JSONDecodable protocol
extension EyeInSkyPhoto: JSONDecodable {
    init?(json: [String : Any]) {
        
        struct Key {
            static let id = "id"
            static let imageURL = "url"
        }
        
        guard let idValue = json[Key.id] as? String,
            let imageValue = json[Key.imageURL] as? String else {
                return nil
        }
        
        self.id = idValue
        self.imageURL = imageValue
    
    }
}






