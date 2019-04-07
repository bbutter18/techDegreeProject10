//
//  MarsRoverViewCellModel.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//model view for Mars Rover Photos
struct MarsRoverCellViewModel {
    let solNumber: Int
    let imageURL: String
}

extension MarsRoverCellViewModel {
    init(marsPhoto: MarsRoverPhoto) {
        self.solNumber = marsPhoto.sol
        self.imageURL = marsPhoto.imageURL
    }
    
}
