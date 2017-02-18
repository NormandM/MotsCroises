//
//  CompleteCheckMotsCroises.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-09.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct CompleteCheck {
    var grilleSelected: String
    func completeCheck(reponse: [[String]]) -> (Bool, [[String]], [[String]], [[String]]) {
        var resultat: Bool = false
        var arrayResultat: [[String]] = []
        var lettresEtIndex: [[String]] = []
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        let lettresMotTotal = motsCroisesArray.motsCroisesArray()
        let lettres = lettresMotTotal.0
        var n = 0
        for lettre in lettres {
            if n < 100 {
                lettresEtIndex.append([String(n), lettre])
                n = n + 1
            }
        }
        let lettresFlat = lettresEtIndex.flatMap { $0 }
        let reponseFlat = reponse.flatMap { $0 }
        if lettresFlat == reponseFlat {
            resultat = true
        }
        n = 0

        for lettre in lettresEtIndex{

            if lettre[1] != reponse[n][1] {
                arrayResultat.append([String(n),lettre[1]])
            }
            
            n = n + 1
        }
      return (resultat, reponse, lettresEtIndex, arrayResultat)
    }
    
}
