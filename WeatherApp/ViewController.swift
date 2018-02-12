//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/9/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    private static let cdManager = CoreDataManager(modelName: "Weather")
    
    class func getCDManager() -> CoreDataManager{
        return cdManager
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var units: UITextField!
    var unitTextField = UnitSelector.currentUnit()

    
    @IBAction func goToSearchViewController(_ sender: UITextField) {
        performSegue(withIdentifier: "searchForPlaces", sender: self)
    }
    
    func updateUnitTextField() {
        unitTextField = UnitSelector.currentUnit()
    }
    
    @IBAction func selectUnits(_ sender: UITextField) {
        print("Running selectUnits controller")
        performSegue(withIdentifier: "selectUnits", sender: self)
        updateUnitTextField()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        units.text = unitTextField
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveUserInfo(_ sender: UIButton) {
        print("\(name.text ?? "") and \(units.text ?? "")")
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: ViewController.cdManager.managedObjectContext)
        let user = NSManagedObject(entity: userEntity!, insertInto: ViewController.cdManager.managedObjectContext)
        user.setValue(name.text, forKey: "firstName")
        user.setValue(unitTextField, forKey: "defaultUnits")
        print(ViewController.cdManager.managedObjectContext)
        ViewController.cdManager.saveData()
        print("data saved")
        performSegue(withIdentifier: "weatherFromSettings", sender: self)
    }
    
    // make a new User object
}

