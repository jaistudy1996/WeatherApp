//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/12/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class SearchView: UIViewController {
    
    // MARK: - Default properties
    // TODO: - UPDATE LOC FROM CORELOCATION
    private var currentLoc = "TEST"
    
    let cdManager = CoreDataManager.shared
    
    // MARK: -  Search Bar
    
    @IBOutlet weak var search: UISearchBar!
    
    @IBAction func closeSearch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "placeSelected", sender: self)
    }
    
    override func viewDidLoad() {
        search.delegate = self
        searchCompleter.delegate = self
    }
    
    // MARK: - MapKit
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    // MARK: - Table View

    @IBOutlet weak var searchResultsViewer: UITableView!
    
}

extension SearchView {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeSelected" {
            print("SEGUE: placeSelected.    TYPE: prepare")
            let destVC = segue.destination as! ViewController
            destVC.currentLoc = currentLoc
        }
    }
}

extension SearchView: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsViewer.reloadData()
        print(searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchCompleter.queryFragment = searchText
    }
}

extension SearchView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]
        print("======== Selected Cell ========")
        print(completion)
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            //let coordinate = response?.mapItems[0].placemark.coordinate
            
            print("========== currentLOC Test =======")
            
            print("Before: \(self.currentLoc)")
            self.currentLoc = (response?.mapItems[0].name)!
            print("After: \(self.currentLoc)")
            
            print("========== currentLOC Test End =======")
            
            print(response?.mapItems[0].placemark.coordinate.latitude)
            print(response?.mapItems[0].placemark.coordinate.longitude)
            
            // Entity information
            let name = response?.mapItems[0].name
            let longitude = response?.mapItems[0].placemark.coordinate.longitude
            let latitude = response?.mapItems[0].placemark.coordinate.latitude
            
            // Selected Place entity
            let locEntity = NSEntityDescription.entity(forEntityName: "Places", in: self.cdManager.managedObjectContext)
            let locObject = NSManagedObject(entity: locEntity!, insertInto: self.cdManager.managedObjectContext)
            locObject.setValue(name, forKey: "name")
            locObject.setValue(longitude, forKey: "longitude")
            locObject.setValue(latitude, forKey: "latitude")
            
            self.cdManager.saveData()
            self.performSegue(withIdentifier: "placeSelected", sender: self)
        }
        
        //ViewController.updateLoc(to: SearchView.currentLoc)
        
        // Add selected Place to Place Entity
        
        
    }
}

extension SearchView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        print(searchResult)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        print("========== CELL ==========")
        print("\(cell)")
        return cell
    }
}
