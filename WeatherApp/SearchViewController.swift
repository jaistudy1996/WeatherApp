//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/12/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import Foundation
import UIKit

class SearchView: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var search: UISearchBar!
    
    override func viewDidLoad() {
        search.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
