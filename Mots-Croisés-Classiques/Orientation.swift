//
//  Orientation.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-17.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct SelectionMot {
    var selectedCell: Int
    var totalMot: [[String]]
    func selectionMot() -> ([Int], [Int], [String], [String]){
        var arrayTrans: [[String]] = []
        var selectedWordH: [Int] = []
        var selectedWordV: [Int] = []
        var totalMotV: [String] = []
        var motArraySelected: [String] = []
        var motArraySelectedV: [String] = []
        var n = 0
        for motArray in totalMot {
            if motArray[4] == "V" {
                if motArray[7] == String(selectedCell){
                    totalMotV = motArray
                }
            }
            n = n + 1
        }

        for motArray in totalMot{
            if motArray[4] == "H" {
                if motArray[2] == totalMot[selectedCell][2] && motArray[6] == totalMot[selectedCell][6]{
                    
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        
        // Grid position number for each letter of the word selected in horizontal position
        for array in arrayTrans {
            // making sure the lleter is within the same word
            if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[5]) {
                    selectedWordH.append(choixArray)
                    motArraySelected.append(array[1])
                }
            }
        }
        arrayTrans = []
        for motArray in totalMot {
            if motArray[4] == "V"{
                if motArray[2] == totalMotV[2] && motArray[6] == totalMotV[6]{
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        // Grid position number for each letter of the word selected in vertical position
        for array in arrayTrans {
            // making sure the lleter is within the same word
            if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[7]) {
                    selectedWordV.append(choixArray)
                    motArraySelectedV.append(array[1])
                }
            }
        }
        
    return (selectedWordH, selectedWordV, motArraySelected, motArraySelectedV)
    }
}
