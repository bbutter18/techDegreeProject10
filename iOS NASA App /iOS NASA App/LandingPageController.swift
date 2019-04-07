//
//  ViewController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 2/24/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import UIKit

//Main landing page for the app
class LandingPageController: UIViewController {

    //MARK: - Properties
    let nasaDBClient = NASADBClient()
    var images: [UIImage] = []
    var apods: [APOD] = []
    var singleAPOD: [APOD] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var apodCollectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var apodNameLabel: UILabel!
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    //initalizing the data source only when needed
    lazy var dataSource: APODCollectionViewDataSource = {
        return APODCollectionViewDataSource(data: [])
    }()
    
    let request = APIKey.apodJSONURL

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        //API call for APODs to populate the collection view
        nasaDBClient.retrieveAPODJson(with: request) { jsonArray, error in
            
            DispatchQueue.main.async {
            
            if let error = error {
                print("\(error)")
                return
            }
            
            guard let jsonArray = jsonArray else {
                print("jsonArray is empty")
                return
            }
            
            self.apods = jsonArray.compactMap { APOD(json: $0) }
            
            self.dataSource.updateData(self.apods)
            
            self.apodCollectionView.reloadData()
            }
        }
        
        //API call for the single APOD
        nasaDBClient.getAPOD() { [weak self] results in
            DispatchQueue.main.async {
                
            switch results {
            case .success(let apod):
                self?.singleAPOD.append(apod)
                print("success")

                self?.apodNameLabel.text = apod.title
                
                let url = URL(string: apod.imageURL)
                if let data = try? Data(contentsOf: url!) {
                    
                    let image: UIImage = UIImage(data: data)!
                    self?.imageView.image = image
                    
                }

            case .failure(let error):
                print(error)
            
                
                }
            }
        }

    }
    
    func setupCollectionView() {
        apodCollectionView.dataSource = dataSource
        apodCollectionView.delegate = self as? UICollectionViewDelegate
    }
    

} //END

//MARK: - Collection View Delegate

extension LandingPageController: UICollectionViewDelegateFlowLayout {
    
    //is responsible for telling the layout the size of a given cell
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //here you work out the total amount of space taken up by padding. There will be n+1 evenly sized spaces, where n is the number of items in the row. The space size can be taken from the left section inset. Subtracting this from the view's width and dividing by the number of items in a row gives you the width for each item. You then return the size as a square.
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
        
    }
    
    //returns the space between the cells, headers, and foothers. A constant is used to store the value.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    //this method controls the spacing between each line in the layout. YOu want this to match the padding at the left and right.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    
    
}


