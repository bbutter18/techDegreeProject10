//
//  iOS_NASA_AppTests.swift
//  iOS NASA AppTests
//
//  Created by user on 4/1/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import XCTest
@testable import iOS_NASA_App
import MapKit


class iOS_NASA_AppTests: XCTestCase {

    let nasaDBClient = NASADBClient()
    
    var testSession: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        testSession = URLSession(configuration: .default)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testSession = nil
        super.tearDown()
    }
    
    func testFor200Code() {
        let expectedResult = expectation(description: "Status code is 200")
        let urlRequest = URL(string: "https://api.nasa.gov/planetary/apod?api_key=W3WvR4SQdHJGu9L6Z5Th0IocIZvr9m5U9UiECglu&date=2019-03-15")
        var statusCode: Int?
        var responseError: Error?
        
        _ = testSession.dataTask(with: urlRequest!) { result, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectedResult.fulfill()
        } .resume()
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    func testGetAPOD() {

        let expectedResult = expectation(description: "APOD Photo object")
        var apodPhoto: APOD?
        var responseError: Error?
        
        nasaDBClient.getAPOD() { result in
            switch result {
            case .success(let response):
                apodPhoto = response
                let url = URL(string: apodPhoto!.imageURL)
                _ = try? Data(contentsOf: url!)
                expectedResult.fulfill()
            case .failure(let error):
                responseError = error
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(apodPhoto)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testRetrieveAPODJSON() {
        let expectedResult = expectation(description: "APOD object")
        var apodJSON: [APOD]?
        var responseError: Error?
        let urlRequest = "https://api.nasa.gov/planetary/apod?api_key=W3WvR4SQdHJGu9L6Z5Th0IocIZvr9m5U9UiECglu&count=10"

        nasaDBClient.retrieveAPODJson(with: urlRequest) { apod, error in
            
            if let apod = apod {
                apodJSON = apod.compactMap { APOD(json: $0) }
                expectedResult.fulfill()
            }

            if let error = error {
                responseError = error
                
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(apodJSON)

    }
    
    func testGetMarsPhotos() {
        
        let expectedResult = expectation(description: "Mars Photo object")
        var marsPhoto: MarsRoverPhoto? 
        var responseError: Error?
        
        nasaDBClient.getMarsRoverPhotos() { result in
            switch result {
            case .success(let response):
                marsPhoto = response.first
                expectedResult.fulfill()
            case .failure(let error):
                responseError = error
            }
            
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(marsPhoto)
        
    }
    
    func testGetEyeInSkyPhoto() {
        
        let expectedResult = expectation(description: "Eye In the Sky Photo object")
        var eyeSkyPhoto: EyeInSkyPhoto?
        var responseError: Error?
        let longitude = 98.75
        let latitude = 50.43
        
        nasaDBClient.getEyeInSkyPhoto(longitude: longitude, latitude: latitude) { result in
            switch result {
            case .success(let response):
                eyeSkyPhoto = response
                let url = URL(string: eyeSkyPhoto!.imageURL)
                _ = try? Data(contentsOf: url!)
                expectedResult.fulfill()
            case .failure(let error):
                responseError = error
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(eyeSkyPhoto)
        
    }
    
    func testMapSearchResults() {
        let expectedResult = expectation(description: "Map Search returns a set of locations or a location")
        var results: MKLocalSearch.Response?
        let searchText = "safeway"
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else { return }
            results = response
            expectedResult.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(results)
        
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
