//
//  RoverController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/18/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//Class for handling the collection view of Mars Rover Photos and API calls to get Mars Rover Photos
class MarsRoverController: UIViewController {

    //MARK: - Properties
    
    let nasaDBClient = NASADBClient()
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    var selectedCellImage: [UIImage] = []
    var finalSelectImage: UIImage!
    
    @IBOutlet weak var marsRoverCollectionView: UICollectionView!
    
    
    
    lazy var dataSource: MarsRoverCollectionViewDataSource = {
        return MarsRoverCollectionViewDataSource(data: [])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        nasaDBClient.getMarsRoverPhotos() { [weak self] results in
            DispatchQueue.main.async {
                
            switch results {
            case .success(let marsPhotos):
                print("success")
                self?.dataSource.updateData(marsPhotos)
                self?.marsRoverCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
            
            }
        }
        
    }
    
    func setupCollectionView() {
        marsRoverCollectionView.dataSource = dataSource
        marsRoverCollectionView.delegate = self as? UICollectionViewDelegate
        
    }
    
    
    //MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCellImage = []
        
        let cell = collectionView.cellForItem(at: indexPath) as! MarsRoverViewCell
        
        selectedCellImage.append(cell.imageView.image!)
        print("in selection")
        for i in selectedCellImage {
            finalSelectImage = i
        }
        performSegue(withIdentifier: "showPostcardController", sender: nil)

    }
    
    
    
    @IBAction func randomImagesButton(_ sender: Any) {
        
        print("randomizing Mars Rover Photos")
        
        var newSol = APIKey.currentSol
        newSol = String(Int.random(in: 1 ..< 1000))
        print(newSol)
        APIKey.currentSol = newSol
        
        nasaDBClient.getMarsRoverPhotos() { [weak self] results in
            DispatchQueue.main.async {
                
            switch results {
            case .success(let marsPhotos):
                print("success")
                
                self?.dataSource.updateData(marsPhotos)
                self?.marsRoverCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
            
            }
        }
        
    }
    
    
    
    
   
    //MARK - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.destination is PostcardMakerController {
            let controller = segue.destination as? PostcardMakerController

            guard let selectImage = finalSelectImage else { return }
            controller?.postcardImage = selectImage
            print("initiating segue")

        }
    }

    
} //End


extension MarsRoverController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }


}

















