//
//  APOD.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//Model for handling APOD JSON objects
struct APOD {
    let title: String
    let imageURL: String 
    var image: UIImage? {
    
        return UIImage(named: imageURL)
    }
}

//conformance to the JSONDecodable protocol
extension APOD: JSONDecodable {
    init?(json: [String: Any]) {
        struct Key {
            static let title = "title"
            static let imageURL = "url"
        
        }
        
        guard let titleValue = json[Key.title] as? String,
            let imageValue = json[Key.imageURL] as? String else {
                return nil
        }
        
        self.title = titleValue
        self.imageURL = imageValue
        
    }

}

