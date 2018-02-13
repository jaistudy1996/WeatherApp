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
        super.viewDidAppear(true)
        print(" == Fetch Request Test == ")
        let fetch: NSFetchRequest<User> = User.fetchRequest()
        cdManager.managedObjectContext.performAndWait {
            do {
                let user = try fetch.execute()
                print(user)
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
