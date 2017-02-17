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

        var arrayFinal: [String] = []
        var arrayFinalReponse: [String] = []
        var motArrayselectedNo: [Int] = []
        var motBon: Bool = false
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        let resultatFunc = motsCroisesArray.motsCroisesArray()
        let reponseTotal = ReponseTotale(reponse: reponse, grilleSelected: grilleSelected)
        let reponseArray = reponseTotal.reponseTotale()
    
        let arrayDuMotCroise = resultatFunc.1

        
        let selectionMot = SelectionMot(selectedCell: selectedCell, totalMot: arrayDuMotCroise)
        let selectedWordH = selectionMot.selectionMot().0
        let selectedWordV = selectionMot.selectionMot().1
        let motArraySelected = selectionMot.selectionMot().2
        let motArraySelectedV = selectionMot.selectionMot().3
        
        let selectionReponse = SelectionMot(selectedCell: selectedCell, totalMot: reponseArray)
        let motArrayReponse = selectionReponse.selectionMot().2
        let motArrayReponseV = selectionReponse.selectionMot().3
        
        
        
  
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
        

    return (motBon, motArrayselectedNo, arrayFinal, arrayFinalReponse)
    }
}
