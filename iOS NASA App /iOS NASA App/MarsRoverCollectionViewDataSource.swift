//
//  MarsRoverCollectionViewDataSource.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/19/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit



class MarsRoverCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    private var data: [MarsRoverPhoto]
    
    let maxPhotosDisplayInt = 12
    var selectedIndexPath: IndexPath?
    
    init(data: [MarsRoverPhoto]) {
        self.data = data
        super.init()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count > 10 ? 10 : data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarsRoverViewCell.reuseIdentifier, for: indexPath) as! MarsRoverViewCell
        
        let mars = object(at: indexPath)
        let viewModel = MarsRoverCellViewModel(marsPhoto: mars)
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    
    // MARK: - Helpers
    
    func update(_ object: MarsRoverPhoto, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [MarsRoverPhoto]) {
        self.data = data
    }
    
    func object(at indexPath: IndexPath) -> MarsRoverPhoto {
        return data[indexPath.row]
    }
    
}

















