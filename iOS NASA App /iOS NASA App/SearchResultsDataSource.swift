//
//  SearchResultsDataSource.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/27/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class SearchResultsDataSource: NSObject, UITableViewDataSource {

    var data: [MKMapItem] = []
    var mapView: MKMapView!

    weak var handleMapSearchDelegate: HandleMapSearch?

    override init() {
        super.init()
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        let selectedItem = object(at: indexPath)
        cell.titleLabel.text = selectedItem.name
       
        cell.subTitleLabel.text = parseAddress(selectedItem: selectedItem.placemark)
        
        return cell
    }
    


    // MARK: Helpers
    
    func object(at indexPath: IndexPath) -> MKMapItem {
        return data[indexPath.row]
    }
    
    func update(with data: [MKMapItem]) {
        self.data = data
    }
    
    func update(_ object: MKMapItem, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            selectedItem.thoroughfare ?? "",
            comma,
            selectedItem.locality ?? "",
            secondSpace,
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    
    

}



