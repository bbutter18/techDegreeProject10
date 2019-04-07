//
//  SearchLocationController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/26/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}

//class responsible for handling Searching for a location using MapKit, and displaying the results in a table view
class SearchLocationController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    let dataSource = SearchResultsDataSource()
    let searchController = UISearchController(searchResultsController: nil)
    /// Location manager used to find the user's current location.
    let locationManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    var selectedMapLocation: [MKPlacemark] = []
    var chosenMapItem: MKMapItem?
    var longitude: Double?
    var latitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view
        
        setupSearchBar()
        setupTableView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        dataSource.handleMapSearchDelegate = self
        
    }
    
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self as? UITableViewDelegate
        
    }
    
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar

        searchController.searchBar.placeholder = "Use this search bar to find locations..."
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    
    
    @IBAction func makeLocationSelection(_ sender: Any) {
        print("initiating Eye In Sky Controller Segue")
       
    }
    
    
    
    // MARK: - Navigation
     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let newLatitude = chosenMapItem?.placemark.coordinate.latitude, let newLongitude = chosenMapItem?.placemark.coordinate.longitude {
            latitude = newLatitude
            longitude = newLongitude
        }
    }


}//END

//MARK: - Location Delegate
extension SearchLocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapView.setRegion(region, animated: true)
        }
        
        
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: \(error.localizedDescription)")
    }
    
    
    
    
}//END


//MARK: - UISearchResults

extension SearchLocationController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
            !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
        }
        guard let mapView = mapView else { return }
        
        // search request.
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        // start search.
        search.start { (response, error) in
            if let error = error {
                print("SearchResultsController search error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response else { return }
            
            self.dataSource.data = response.mapItems
            self.tableView.reloadData()
            
        }
    }
}

//MARK: - MapKit Helper

extension SearchLocationController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        //cache the pin
        selectedPin = placemark
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion.init(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

}

//MARK: - Table View Delegate

extension SearchLocationController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Call the callback method for selected item.
        let mapThing = dataSource.object(at: indexPath).placemark
        dataSource.handleMapSearchDelegate?.dropPinZoomIn(placemark: mapThing)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        selectedMapLocation.append(mapThing)
        
        print("selected something")
        
        chosenMapItem = dataSource.object(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        
        selectedMapLocation.remove(at: 0)
        print(selectedMapLocation)
        print(selectedMapLocation.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
































