//
//  APODCollectionViewDataSource.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/18/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit



class APODCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    private var data: [APOD]
    
    init(data: [APOD]) {
        self.data = data
        super.init()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: APODViewCell.reuseIdentifier, for: indexPath) as! APODViewCell
        
        let apod = object(at: indexPath)
        let viewModel = APODCellViewModel(apod: apod)
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    // MARK: - Helpers
    
    func update(_ object: APOD, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [APOD]) {
        self.data = data
    }
    
    func object(at indexPath: IndexPath) -> APOD {
        return data[indexPath.row]
    }

}











