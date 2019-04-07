//
//  JSONDecodable.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation



protocol JSONDecodable {
    
    /*
     Instantiates an instance of the conforming type with a JSON dictionary.
     
     Returns `nil` if the JSON dictionary does not contain all the values
     needed for instantiation of the conforming type
     */
    
    init?(json: [String: Any])
}
