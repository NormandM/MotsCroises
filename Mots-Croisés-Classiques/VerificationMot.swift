//
//  VerificationMot.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-13.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct VerificationDuMot {
    let grilleSelected: String
    let reponse: [[String]]
    let horizontal: Bool
    func verificationDuMot  (selectedCell: Int, reponse : [[String]]) -> (Bool, [Int], [String], [String]){
        var arrayTrans: [[String]] = []
        var selectedWordH: [Int] = []
        var selectedWordV: [Int] = []
        var reponseWordH: [Int] = []
        var reponseWordV: [Int] = []
        var totalMotV: [String] = []
        var totMotVReponse: [String] = []
        var arrayFinal: [String] = []
        var arrayFinalReponse: [String] = []
        var motArrayReponse: [String] = []
        var motArrayReponseV: [String] = []
        var motArraySelected: [String] = []
        var motArraySelectedV: [String] = []
        var motArrayselectedNo: [Int] = []
        var motBon: Bool = false
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        let resultatFunc = motsCroisesArray.motsCroisesArray()
        let reponseTotal = ReponseTotale(reponse: reponse, grilleSelected: grilleSelected)
        let reponseArray = reponseTotal.reponseTotale()
    
        let arrayDuMotCroise = resultatFunc.1
        var n = 0
        for motArray in arrayDuMotCroise {
            if motArray[4] == "V" {
                if motArray[7] == String(selectedCell){
                    totalMotV = motArray
                }
            }
            n = n + 1
        }
        n = 0
        for motArray in arrayDuMotCroise {
            if motArray[4] == "H" {
                if motArray[2] == arrayDuMotCroise[selectedCell][2] && motArray[6] == arrayDuMotCroise[selectedCell][6]{
                    
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
        for motArray in arrayDuMotCroise {
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
 
        
        
        
        
        
        
        n = 0
        arrayTrans = []
        for motArray in reponseArray {
            if motArray[4] == "V" {
                if motArray[7] == String(selectedCell){
                    totMotVReponse = motArray
                }
            }
            n = n + 1
        }
        n = 0
        for motArray in reponseArray {
            if motArray[4] == "H" {
                if motArray[2] == reponseArray[selectedCell][2] && motArray[6] == reponseArray[selectedCell][6]{
                    
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        
        // Grid position number for each letter of the word selected in horizontal position
        for array in arrayTrans {
            // making sure the lleter is within the same word
            if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[5]) {
                    reponseWordH.append(choixArray)
                    motArrayReponse.append(array[1])
                }
            }
        }
        arrayTrans = []
        for motArray in reponseArray {
            if motArray[4] == "V"{
                if motArray[2] == totMotVReponse[2] && motArray[6] == totMotVReponse[6]{
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        
        // Grid position number for each letter of the word selected in vertical position
        for array in arrayTrans {
            // making sure the lleter is within the same word
            if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[7]) {
                    reponseWordV.append(choixArray)
                    motArrayReponseV.append(array[1])
                }
            }
        }

        if horizontal == true {
            motArrayselectedNo = selectedWordH
            arrayFinal = motArraySelected
            arrayFinalReponse = motArrayReponse
            if motArraySelected == motArrayReponse {
                motBon = true
                
            }else{
                motBon = false
            }
        }else{
            motArrayselectedNo = selectedWordV
            arrayFinal = motArraySelectedV
            arrayFinalReponse = motArrayReponseV
            if motArraySelectedV == motArrayReponseV{
                motBon = true
            }else{
                motBon = false
            }
            
        }
        
        
        
        
        
        /*
        for arrayLettre in arrayDuMotCroise {
            if cellSelected == arrayLettre[5]{
                if arrayLettre[4] == "H" {
                    motSelected = arrayLettre[2]
                    motReponse = reponseArray[n][2]
                    noDeMot = arrayLettre[6]
                }else if arrayLettre[4] == "V"{
                    motSelected = arrayLettre[2]
                    motReponse = reponseArray[n][2]
                    noDeMot = arrayLettre[6]
                }
            }
            n = n + 1
        }
        n = 0
        for mot in arrayDuMotCroise {
            
            if mot[4] == "H" {
                if noDeMot == mot[6]{
                    motArraySelected.append(mot[1])
                    motArrayReponse.append(reponseArray[n][1])
                    motArrayselectedNo.append(mot[5])
                }
            }else if mot[4] == "V" {
                
                if noDeMot == mot[6]{
                    print(n)
                    motArraySelected.append(mot[1])
                    motArrayReponse.append(reponseArray[n][1])
                    motArrayselectedNo.append(mot[7])
                }
            }
            n = n + 1
        }
        */
//        if motArraySelected == motArrayReponse {
//            motBon = true
//        }else{
//            motBon = false
//       }
    return (motBon, motArrayselectedNo, arrayFinal, arrayFinalReponse)
    }
}
