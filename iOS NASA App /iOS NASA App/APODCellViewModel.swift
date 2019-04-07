//
//  APODCellViewModel.swift
//  iOS NASA App
//
//  Created by user on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//model view for APOD 
struct APODCellViewModel {
    let title: String
    let imageURL: String
}

extension APODCellViewModel {
    init(apod: APOD) {
        self.title = apod.title
        self.imageURL = apod.imageURL
    }
    
}





