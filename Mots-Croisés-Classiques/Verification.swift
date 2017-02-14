//
//  Verification.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-10.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct Verification {
    let grilleSelected: String
    let reponse: [[String]]
    func verificationLettre(lettreChoisiIndex: String) -> Bool {
        var reponseDonneLettre: String = ""
        var solutionLettre: String = ""
        var bonneReponse: Bool = false
        let completeCheck = CompleteCheck(grilleSelected: grilleSelected)
        let reponse = completeCheck.completeCheck(reponse: self.reponse).1
        let solution = completeCheck.completeCheck(reponse: self.reponse).2
        
        for reponses in reponse {
            if reponses[0] == lettreChoisiIndex {
                reponseDonneLettre = reponses[1]
            }
        }
        for solutions in solution {
                if solutions[0] == lettreChoisiIndex {
                solutionLettre = solutions[1]
            }
        }
        if reponseDonneLettre == solutionLettre {
            bonneReponse = true
        }
        return bonneReponse
    }
}
