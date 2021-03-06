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
    
    var currentLocName:  String?
    var currentLocInfo = Array<Double>() // This array will store lat and long for the name selected
    var nameText: String?
    var unitText: String?
    let cdManager = CoreDataManager.shared
    
    @IBOutlet weak var location: UITextField!
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
        location.text = currentLocName
        name.text = nameText ?? ""
        
        
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveUserInfo(_ sender: UIButton) {
        print("\(name.text ?? "") and \(units.text ?? "")")
        
        let placeEntity = cdManager.createEntity(for: "Places", in: cdManager.managedObjectContext)
        let place = Places(entity: placeEntity!, insertInto: cdManager.managedObjectContext)
        place.latitude = currentLocInfo[0]
        place.longitude = currentLocInfo[1]
        
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: cdManager.managedObjectContext)
        let user = User(entity: userEntity!, insertInto: cdManager.managedObjectContext)
        user.firstName = name.text
        user.defaultUnits = unitTextField
        user.addToUserToPlace(place)

        place.placeToUser = user
        
        print(place.placeToUser)
        print(user.userToPlace)
        
        print(cdManager.managedObjectContext)
        cdManager.saveData()
        print("data saved")
        performSegue(withIdentifier: "weatherFromSettings", sender: self)
    }
    
    // make a new User object
}

