//
//  GrilleSave.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-10-01.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
import CoreData
class GrilleData {
    class func prepareGrille(dimension: Int, item: [Item], grilleSelected: String, grille: [[String]])  {
        if item == [] {
            for n in 0...dimension {
                for m in 0...dimension {
                    if grille[n][m] == "#" {
                        _ = CoreDataHandler.saveObject(completed: false, lettre: "#", noDeLettre: "\(n),\(m)", noMotcroise: grilleSelected)
                    }else{
                        _ = CoreDataHandler.saveObject(completed: false, lettre: " ", noDeLettre: "\(n),\(m)", noMotcroise: grilleSelected)
                    }

                }
                
            }
        }
    }
}
