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

class SearchView: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    // MARK: - Default properties
    // TODO: - UPDATE LOC FROM CORELOCATION
    private static var currentLoc = "TEST"
    
    // MARK: - Default location servies
    class func getCurrentLoc() -> String {
        return currentLoc
    }
    
    
    @IBAction func closeSearch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "placeSelected", sender: self)
    }
    
    // MARK: -  Search Bar
    
    @IBOutlet weak var search: UISearchBar!
    
    override func viewDidLoad() {
        search.delegate = self
        searchCompleter.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchCompleter.queryFragment = searchText
    }
    
    // MARK: - MapKit
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsViewer.reloadData()
        print(searchResults)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: - Table View

    @IBOutlet weak var searchResultsViewer: UITableView!
    
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
            SearchView.currentLoc = (response?.mapItems[0].name)!
            print(response?.mapItems[0].name)
        }
        ViewController.updateLoc(to: SearchView.currentLoc)
        performSegue(withIdentifier: "placeSelected", sender: self)
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
