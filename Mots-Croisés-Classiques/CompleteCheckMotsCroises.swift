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
    func completeCheck(reponse: [[String]]) -> (Bool, [[String]], [[String]]) {
        var resultat: Bool = false
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
      return (resultat, reponse, lettresEtIndex)
    }
    
}
