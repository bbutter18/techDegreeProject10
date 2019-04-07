//
//  EyeInSkyController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/18/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import UIKit

//class for handling the Satellite imagery of Earth from the NASA API
class EyeInSkyController: UIViewController {

    //MARK: - Properties
    
    let nasaDBClient = NASADBClient()
    var longitude: Double = 98.75
    var latitude: Double = 50.43
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        
        nasaDBClient.getEyeInSkyPhoto(longitude: longitude, latitude: latitude) { [weak self] results in
            switch results {
            case .success(let eyeSkyPhoto):
                print("success")
                
                let url = URL(string: eyeSkyPhoto.imageURL)
                if let data = try? Data(contentsOf: url!) {
                    
                    let image: UIImage = UIImage(data: data)!
                    
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                    
                }
                
                
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    func setupLabels() {
        longitudeLabel.text = String(longitude)
        latitudeLabel.text = String(latitude)
    }
    
    
    
    @IBAction func searchEarthLocationButton(_ sender: Any) {
        
        performSegue(withIdentifier: "showSearchController", sender: Any?.self)
        
    }
    
    //MARK: - Navigation
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToEyeInTheSky" {
            guard let vc = segue.source as? SearchLocationController else { return }
            latitude = vc.latitude!
            longitude = vc.longitude!
            self.longitudeLabel.text = String(longitude)
            self.latitudeLabel.text = String(latitude)
            
            nasaDBClient.getEyeInSkyPhoto(longitude: longitude, latitude: latitude) { [weak self] results in
                switch results {
                case .success(let eyeSkyPhoto):
                    print("success")

                    let url = URL(string: eyeSkyPhoto.imageURL)
                    if let data = try? Data(contentsOf: url!) {

                        let image: UIImage = UIImage(data: data)!

                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }

                    }



                case .failure(let error):
                    print(error)
                }

            }
            
        }
    }
    
    
    
    
    
    
}//END
