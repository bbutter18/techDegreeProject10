//
//  APODViewCell.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/18/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//Configuration of APOD cells in the collection view
class APODViewCell: UICollectionViewCell {

    static let reuseIdentifier = "apodViewCell"

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var imageLabel: UILabel!
    

    func configure(with viewModel: APODCellViewModel) {
        imageLabel.text = viewModel.title
        
        let url = URL(string: viewModel.imageURL)
        if let data = try? Data(contentsOf: url!) {
            
            if let image: UIImage = UIImage(data: data) {
                self.imageView.image = image
            } else {
                displayAlertError(with: "Error", message: "NASA API not responding, please reload app.")
            }
        
        }
    }
    
    func displayAlertError(with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.present(alert, animated: true, completion: nil)
    }
    
}







