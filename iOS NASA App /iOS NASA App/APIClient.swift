//
//  APIClient.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/17/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Network Error

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case invalidURL
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .invalidURL: return "URL is not a valid address"
        }
    }
}

protocol APIClient {
    
    var session: URLSession { get }
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> [T], completion: @escaping (Result<[T], APIError>) -> Void)
    
}

extension APIClient {
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, APIError?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            //Error handling for an Error code in case a network connection has failed
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    self.displayAlertError(with: "Error", message: "No Internet Connection Available")
                    
                case .networkConnectionLost:
                    self.displayAlertError(with: "Error", message: "Network Connection Lost")
                    
                default: break
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            //http 200 reponse code indicates that the request has succeeded, and subsequent error handling of each scenario of request responses
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                    print("from up here")
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
    
    //MARK: - Custom API call for a random batch of APOD photos from the NASA API
    
    typealias otherJSON = [[String: Any]] // - an array of JSON objects
    typealias otherJSONTaskCompletionHandler = (otherJSON?, APIError?) -> Void
    
    func retrieveAPODJson(with endpoint: String, completionHandler completion: @escaping otherJSONTaskCompletionHandler) {
        
        guard let url = URL(string: endpoint) else {
            completion(nil, .invalidURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //at this point we're done with any work in a background queue so we can switch to the main queue to continue.
            DispatchQueue.main.async {
            
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        self.displayAlertError(with: "Error", message: "No Internet Connection Available")
                        
                    case .networkConnectionLost:
                        self.displayAlertError(with: "Error", message: "Network Connection Lost")
                        
                    default: break
                    }
                }
                
        guard let dataResponse = data else {
            completion(nil, .requestFailed)
            return
        }
        
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                completion(jsonArray, nil)
            } catch {
                completion(nil, .invalidData)
            }
            
            }
        }
        
        task.resume()
    }
    
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        
        let task = jsonTask(with: request) { json, error in
            
            //at this point we're done with any work in a background queue so we can switch to the main queue to continue.
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    
                    return
                }
                
                //success case
                if let value = parse(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        
        
        task.resume()
    }
    
    
    func fetch<T: JSONDecodable>(with request: URLRequest, parse: @escaping (JSON) -> [T], completion: @escaping (Result<[T], APIError>) -> Void) {
        
        let task = jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                        print("from here")
                    }
                    
                    return
                }
                
                //success case
                let value = parse(json)
                
                if !value.isEmpty {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        
        
        task.resume()
    }
    
    
    func displayAlertError(with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.present(alert, animated: true, completion: nil)
    }
    
}//END





