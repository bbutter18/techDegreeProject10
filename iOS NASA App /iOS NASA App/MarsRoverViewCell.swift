//
//  MarsRoverViewCell.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit


//Configuration of Mars Rover Photos in the collection view
class MarsRoverViewCell: UICollectionViewCell {

    static let reuseIdentifier = "marsRoverViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with viewModel: MarsRoverCellViewModel) {
        
        let http = viewModel.imageURL
        let https = "https" + http.dropFirst(4)
        
        let url = URL(string: https)
        
        if let data = try? Data(contentsOf: url!) {
            
            let image: UIImage = UIImage(data: data)!
            self.imageView.image = image
            
            
        }
    }
    
    
    
    
}
