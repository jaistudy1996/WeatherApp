//
//  WeatherInfoController.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/12/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WeatherInfoController: UIViewController {
    
    let cdManager = CoreDataManager.shared
    
    @IBOutlet weak var testText: UITextView!
    
    @IBAction func settingsButton(_ sender: UIButton) {
        goToSettings()
    }
    func goToSettings() {
        performSegue(withIdentifier: "checkUser", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(" == Fetch Request Test == ")
        
        print("Props for entity:")
        let entityTest = CoreDataManager.shared.createEntity(for: "User", in: CoreDataManager.shared.managedObjectContext)
        
        print(entityTest?.propertiesByName)
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        fetch.relationshipKeyPathsForPrefetching = ["userTopPlace"]
        cdManager.managedObjectContext.performAndWait {
            do {
                let user = try fetch.execute()
                print(user.count)
//                let a = user[0]
//                print(a.userToPlace)
                print(user.isEmpty)
                if user.isEmpty {
                    print("Perform segue")
                    goToSettings()
                    print("DONE Perform segue")
                }
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
}

extension WeatherInfoController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkUser" {
            let destVC = segue.destination as! ViewController
//            destVC.
        }
    }
}
