//
//  NasaDBClient.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation




class NASADBClient: APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
        
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //MARK: - APOD
    func getAPOD(completion: @escaping (Result<APOD, APIError>) -> Void) {
        let endpoint = NASADB.apod(apodList: .apod)
        
        let request = endpoint.request
        
        fetch(with: request, parse: { json -> APOD? in
            //print(json)
            
            return APOD(json: json)
            
        }, completion: completion)
    
    }
    
    //MARK: - Mars Rover Photos
    func getMarsRoverPhotos(completion: @escaping (Result<[MarsRoverPhoto], APIError>) -> Void) {
        let endpoint = NASADB.marsRover(marsRoverList: .marsRover)
        
        let request = endpoint.request
        
        fetch(with: request, parse: { (json) -> [MarsRoverPhoto] in
            guard let marsRoverPhotos = json["photos"] as? [[String: Any]] else { return [] }
            
            return marsRoverPhotos.compactMap { MarsRoverPhoto(json: $0) }
            
        }, completion: completion)
    
    }
    
    //MARK: - Eye In the Sky Photos
    func getEyeInSkyPhoto(longitude: Double, latitude: Double, cloudScore: Bool = true, completion: @escaping (Result<EyeInSkyPhoto, APIError>) -> Void) {
        let endpoint = NASADB.eyeInTheSky(latitude: latitude, longitude: longitude, cloudScore: cloudScore)
        
        let request = endpoint.request
        //print(request)
        
        fetch(with: request, parse: { json -> EyeInSkyPhoto? in
            
            return EyeInSkyPhoto(json: json)
            
        }, completion: completion)
    
    
    }
    

    
} //END


