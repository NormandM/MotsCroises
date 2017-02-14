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
    func verificationDuMot  (cellSelected: String, reponse : [[String]]) -> (Bool, [String], [String], [String]){
        var motSelected: String = ""
        var motReponse: String = ""
        var noDeMot: String = ""
        var motArrayReponse: [String] = []
        var motArraySelected: [String] = []
        var motArrayselectedNo: [String] = []
        var motBon: Bool = false
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        let resultatFunc = motsCroisesArray.motsCroisesArray()
        let reponseTotal = ReponseTotale(reponse: reponse, grilleSelected: grilleSelected)
        let reponseArray = reponseTotal.reponseTotale()
    
        let arrayDuMotCroise = resultatFunc.1
        var n = 0
        for arrayLettre in arrayDuMotCroise {
            if cellSelected == arrayLettre[5]{
                motSelected = arrayLettre[3]
                motReponse = reponseArray[n][3]
                noDeMot = arrayLettre[6]
            }
            n = n + 1
        }
        n = 0
        for mot in arrayDuMotCroise {
            if noDeMot == mot[6]{
                motArraySelected.append(mot[1])
                motArrayReponse.append(reponseArray[n][1])
                motArrayselectedNo.append(mot[5])
            }
            n = n + 1
        }

        if motArraySelected == motArrayReponse {
            motBon = true
        }else{
            motBon = false
        }
    return (motBon, motArraySelected, motArrayReponse, motArrayselectedNo)
    }
}
