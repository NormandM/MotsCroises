//
//  CoreDataHandler.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-10-01.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    private class func getContext() ->  NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    class func saveObject(completed: Bool, lettre: String, noDeLettre: String, noMotcroise: String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        managedObject.setValue(completed, forKey: "completed")
        managedObject.setValue(lettre, forKey: "lettre")
        managedObject.setValue(noDeLettre, forKey: "noDeLettre")
        managedObject.setValue(noMotcroise, forKey: "noMotcroise")
        do {
            try context.save()
            return true
        }catch{
            return false
        }
    }
    class func fetchSingleObject(noDeLettre: String, grilleSelected: String) -> Item{
            let context = getContext()
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            var item: [Item]? = nil
            let predicate1 = NSPredicate(format: "noDeLettre == %@", noDeLettre)
            let predicate2 = NSPredicate(format: "noMotcroise == %@", grilleSelected)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = predicate
            do {
                try item = context.fetch(fetchRequest)
                return item![0]
            }catch{
                return item![0]
            }
        }
    class func saveSingleObject(item: Item) -> Bool {
        let context = getContext()
        do {
            try context.save()
            return true
        }catch{
            return false
        }
    }
    // Delete a single object
    class func deleteObject(item: Item) -> Bool {
        let context = getContext()
        context.delete(item)
        do {
            try context.save()
            return true
        }catch{
            return false
        }
    }
    // Delete all objects
    class func cleanDelete () -> Bool {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Item.fetchRequest())
        do {
            try context.execute(delete)
            return true
        }catch{
            return false
        }
    }
    // Fetch Saved Grille by selected Number
    class func fetchGrille(grilleSelected: String) -> [Item]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var item: [Item]? = nil
        let predicate = NSPredicate(format: "noMotcroise == %@", grilleSelected)
        fetchRequest.predicate = predicate
        do {
            try item = context.fetch(fetchRequest)
            return item
        }catch{
            return item
        }
    }
    class func fetchLetters(noDeLettre: String, grilleSelected: String) -> String {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        var item: [Item]? = nil
        let predicate1 = NSPredicate(format: "noDeLettre == %@", noDeLettre)
        let predicate2 = NSPredicate(format: "noMotcroise == %@", grilleSelected)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicate
        do {
            try item = context.fetch(fetchRequest)
            return item![0].lettre!
        }catch{
            return ""
        }
    }
    class func isMotsCroisesFinished (noDeLettre: String, grilleSelected: String) -> Bool{
        let context = getContext()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
         var item: [Item]? = nil
        let predicate1 = NSPredicate(format: "noDeLettre == %@", noDeLettre)
        let predicate2 = NSPredicate(format: "noMotcroise == %@", grilleSelected)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        fetchRequest.predicate = predicate
        do {
            try item = context.fetch(fetchRequest)
            return item![0].completed
        }catch{
            return false
        }
    }

    class func fetchItemSaveLetter(noDeLettre: String, newLetter: String, grilleSelected: String){
        let item = fetchSingleObject(noDeLettre: noDeLettre, grilleSelected: grilleSelected)
        item.lettre = newLetter
        let isSuccessful = saveSingleObject(item: item)
        if !isSuccessful {
            print("Did not save")
        }
    }
    class func saveCompletedStatus(grilleSelected: String) {
        let item = fetchSingleObject(noDeLettre: "0,0", grilleSelected: grilleSelected)
        item.completed  = true
        let isSuccessful = saveSingleObject(item: item)
        if !isSuccessful {
            print("Did not save")
        }
    }
    class func saveUncompleteStatus(grilleSelected: String) {
        let item = fetchSingleObject(noDeLettre: "0,0", grilleSelected: grilleSelected)
        item.completed  = false
        let isSuccessful = saveSingleObject(item: item)
        if !isSuccessful {
            print("Did not save")
        }
    }

}
