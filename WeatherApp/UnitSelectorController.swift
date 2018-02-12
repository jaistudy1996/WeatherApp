//
//  UnitSelectorController.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/12/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import Foundation
import UIKit

class UnitSelector: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let units = ["Fahrenheit", "Celsius"]
    private static var selectedUnit = "Fahrenheit"
    
    class func currentUnit() -> String {
        return selectedUnit
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UnitSelector.selectedUnit = units[row]
    }
    
    @IBAction func unitSelected(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unitSelected", sender: self)
    }
}
