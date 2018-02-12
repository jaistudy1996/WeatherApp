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
    
    // TESTING
    
    
    // TESTING
    
    private static var currentLoc: String?
    private static let cdManager = CoreDataManager(modelName: "Weather")
    
    class func getCDManager() -> CoreDataManager{
        return cdManager
    }
    
    class func updateLoc(to newLoc: String) {
        ViewController.currentLoc = newLoc
        
    }
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var units: UITextField!
    var unitTextField = UnitSelector.currentUnit()
    var locationTextField = SearchView.getCurrentLoc()

    
    @IBAction func goToSearchViewController(_ sender: UITextField) {
        performSegue(withIdentifier: "searchForPlaces", sender: self)
    }
    
    func updateUnitTextField() {
        unitTextField = UnitSelector.currentUnit()
    }
    
    func updateLocationField() {
        locationTextField = SearchView.getCurrentLoc()
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
        updateLocationField()
        location.text = locationTextField
        
        
        // TEST
        
        
        let todoEndpoint: String = "https://jsonplaceholder.typicode.com/todos/1"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        print(url)
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest, completionHandler:{ _, _, _ in })
        let task = session.dataTask(with: urlRequest) { data, response, error in
            // do stuff with response, data & error here
            do {
                guard let todo = try JSONSerialization.jsonObject(with: data!, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLocationField()
        super.viewDidAppear(true)
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

