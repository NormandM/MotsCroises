//
//  Reveler.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-29.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit

class Reveler {
    let collectionView: UICollectionView
    let indexPathSelected: IndexPath
    let noMotcroise: String
    init (collectionView: UICollectionView, indexPathSelected: IndexPath, noMotcroise: String){
        self.collectionView = collectionView
        self.indexPathSelected = indexPathSelected
        self.noMotcroise = noMotcroise
    }
    func laLettre (lettre: String, grille: [[String]]) -> Bool {
        let fonts = FontsAndConstraintsOptions()
        let lettreToCheck = grille[indexPathSelected.section][indexPathSelected.item]
        if lettreToCheck == lettre {
            return true
        }else{
            let cell = collectionView.cellForItem(at: indexPathSelected) as! MotsCroisesCVCell
            cell.laLettre.text = lettreToCheck
            cell.laLettre.font = fonts.normalBoldFont
            let indexPathConverted = IndexPathToString.convert(indexPath: indexPathSelected)
            CoreDataHandler.fetchItemSaveLetter(noDeLettre: indexPathConverted, newLetter: lettreToCheck, grilleSelected: noMotcroise)
            return false
        }
    }
    func leMot (selectedMot: [String], definitions: [[[String]]], isHorizontal: Bool, pathArray: [IndexPath], dimension: Int) -> Bool{
        let fonts = FontsAndConstraintsOptions()
        var motToCheck = String()
        if isHorizontal{
           motToCheck = definitions[indexPathSelected.section][indexPathSelected.item][2]
        }else{
            motToCheck = definitions[indexPathSelected.section][indexPathSelected.item][3]
        }
        let motArray = motToCheck.map { String($0) }
        if motArray == selectedMot {
            return true
        }else{
            for n in 0...pathArray.count - 1 {
                let cell = collectionView.cellForItem(at: pathArray[n]) as! MotsCroisesCVCell
                cell.laLettre.text = motArray[n]
                let lettre = motArray[n]
                cell.laLettre.font = fonts.normalBoldFont
                let indexPathConverted = IndexPathToString.convert(indexPath: pathArray[n])
                CoreDataHandler.fetchItemSaveLetter(noDeLettre: indexPathConverted, newLetter: lettre, grilleSelected: noMotcroise)
            }
            return false
        }

    }
    func grille(grilleUser: [[String]], grille: [[String]], dimension: Int) -> Bool{
        let fonts = FontsAndConstraintsOptions()
        if grilleUser == grille {
            return true
        }else{
            for n in 0...dimension {
                for m in 0...dimension {
                    if grilleUser[n][m] != grille[n][m]{
                        let cell = collectionView.cellForItem(at: [n, m]) as! MotsCroisesCVCell
                        cell.laLettre.text = grille[n][m]
                        let lettre = grille[n][m]
                        cell.laLettre.font = fonts.normalBoldFont
                        CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(n),\(m)", newLetter: lettre, grilleSelected: noMotcroise)
                    }
                }
            }
            return false
        }
    }

}
