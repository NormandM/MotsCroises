//
//  ValiderLaLettre.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-24.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit

class Valider {
    class func laLettre (indexPathSelected: IndexPath, lettre: String, grille: [[String]]) -> Bool {
        let lettreToCheck = grille[indexPathSelected.section][indexPathSelected.item]
        if lettreToCheck == lettre {
            return true
        }else{
            return false
        }
    }
    class func leMot (indexPathSelected: IndexPath, selectedMot: [String], definitions: [[[String]]], isHorizontal: Bool, pathArray: [IndexPath]) -> [IndexPath]{
        var motToCheck = String()
        var indexPathForErrors = [IndexPath]()
        if isHorizontal{
           motToCheck = definitions[indexPathSelected.section][indexPathSelected.item][2]
        }else{
            motToCheck = definitions[indexPathSelected.section][indexPathSelected.item][3]
        }
        let motArray = motToCheck.map { String($0) }
        for n in 0...motArray.count - 1 {
            if motArray[n] != selectedMot[n] {
                indexPathForErrors.append(pathArray[n])
            }
        }
        return indexPathForErrors
    }
    class func grille(grilleUser: [[String]], grille: [[String]], dimension: Int) -> [IndexPath]{
        var indexPathForErrors = [IndexPath]()
        for n in 0...dimension {
            for m in 0...dimension {
                if grilleUser[n][m] != grille[n][m]{
                    indexPathForErrors.append([n, m])
                }
            }
        }
        return indexPathForErrors
    }
    
}
