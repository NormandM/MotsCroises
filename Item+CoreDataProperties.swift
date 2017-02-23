//
//  Item+CoreDataProperties.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-23.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var completed: Bool
    @NSManaged public var noDeLettre: String?
    @NSManaged public var noMotcroise: String?
    @NSManaged public var lettre: String?

}
