//
//  DataController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-19.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
import CoreData
open class DataController: NSObject {
 
    static let sharedInstance = DataController()
    private override init() {}
    fileprivate lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[(urls.endIndex - 1)]
    }()
    
    fileprivate lazy var managerObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "MotsCroise", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("MotsCroise.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            let userInfo: [String: AnyObject] = [NSLocalizedDescriptionKey: "Failed to initialized the application's saved data" as AnyObject, NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data" as AnyObject, NSUnderlyingErrorKey: error as NSError]
            let wrappedError = NSError(domain: "Normand", code: 9999, userInfo: userInfo)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    open lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    open func saveContext() {
        if managedObjectContext.hasChanges{
            do {
                try managedObjectContext.save()
            } catch let error as NSError{
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
