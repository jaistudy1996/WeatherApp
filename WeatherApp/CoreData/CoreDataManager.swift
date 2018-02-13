//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Jayant Arora on 2/9/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import Foundation
import CoreData

// Main Core Data Manager

class CoreDataManager {
    
    // MARK: - Shared instance
    static let shared = CoreDataManager(modelName: "Weather")
    
    // MARK: - Properties
    private let modelName: String
    
    // MARK: - Initializer
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    // set up Managed Object Context
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()
    
    // set up managed object model
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "Weather", withExtension: "momd") else {
            fatalError("Unable to find data model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data model")
        }
        
        return managedObjectModel
    }()
    
    // set up persitent store coordinator
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentDirectory.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            fatalError("Unable to add persistent store")
        }
        return persistentStoreCoordinator
    }()
    
    // create entity
    func createEntity(for entityName: String, in managedContext: NSManagedObjectContext) -> NSEntityDescription?{
        return NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
    }
    
    // add entity to managed context
    
    // save data call to persistent store coordinator
    func saveData() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Unable to save context")
        }
    }
}
