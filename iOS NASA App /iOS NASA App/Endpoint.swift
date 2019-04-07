//
//  Endpoint.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation

// a type that provides URLRequests for defined API endpoints
protocol Endpoint {
    //returns the base URL for the API as a string
    var base: String { get }
    //returns the URL path for an endpoint, as a string
    var path: String { get }
    //returns the URL parameters for a given endpoint as an array of URLQueryItem
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    //returns an instance of URLComponents containing the base URL, path and the query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    //returns an instance of URLRequest encapsulating the endpoing URL
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
        
    }
}

enum APODEndpoint: CustomStringConvertible {
    case apod
    
    var description: String {
        switch self {
        case .apod: return "apod"
        }
    }

}

enum MarsRoverEndpoint: CustomStringConvertible {
    case marsRover
    
    var description: String {
        switch self {
        case .marsRover: return "curiosity/photos/"
        }
    }
}

enum EyeInSkyEndpoint: CustomStringConvertible {
    case eyeInSky
    
    var description: String {
        switch self {
        case .eyeInSky: return "earth/imagery"
        }
    }
}


enum NASADB {
    case apod(apodList: APODEndpoint)
    case marsRover(marsRoverList: MarsRoverEndpoint)
    case eyeInTheSky(latitude: Double, longitude: Double, cloudScore: Bool)
}

extension NASADB: Endpoint {
    var base: String {
        return "https://api.nasa.gov"
    }

    var path: String {
        switch self {
        case .apod(let apodList): return "/planetary/\(apodList.description)"
        case .marsRover(let marsRoverList): return "/mars-photos/api/v1/rovers/\(marsRoverList.description)"
        case .eyeInTheSky( _): return "/planetary/earth/imagery/"
        }
    }
    
    var queryItems: [URLQueryItem] {
    
        switch self {
        case .apod: return [
            URLQueryItem(name: "api_key", value: APIKey.apikey)
            ]
        case .marsRover: return [
            URLQueryItem(name: "api_key", value: APIKey.apikey),
            URLQueryItem(name: "sol", value: APIKey.currentSol)
            ]
        case .eyeInTheSky(let latitude, let longitude, let cloudScore): return [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "cloud_score", value: cloudScore.description),
            URLQueryItem(name: "api_key", value: APIKey.apikey)
            ]
        }
    }
    
}






