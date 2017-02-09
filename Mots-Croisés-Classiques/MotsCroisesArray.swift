//
//  MotsCroisesArray.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-09.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct MotsCroisesArray {
    var grilleSelected: String
    func motsCroisesArray()-> ([String], [[String]]){
        var totalMot: [[String]] = []
        var lettres: [String] = []
        var n = 0
        var i = 0
        let lettre: [String] = []
        let motsCroises = MotsCroises(noDeGrille: grilleSelected)
        let grilleChoisi = motsCroises.donnesMot()
        let definition = Definition(motArray: grilleChoisi, n: n)
        while n < definition.listeArray.count {
            let definitions = Definition(motArray: grilleChoisi, n: n)
            var grille = Grille(definition: definitions, lettre: lettre, choixDegrille: grilleSelected)
            let transitionArray = grille.epele()
            var totMotTransition: [String] = []
            for letter in transitionArray{
                totMotTransition = [definitions.grille, letter, definitions.mot, definitions.definition, definitions.orientation, String(i), definitions.noMot]
                totalMot = totalMot + [totMotTransition]
                i = i + 1
            }
            lettres = lettres + transitionArray
            n = n + 1
        }
        n = 100
        i = 0
        while n < 110 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 1
        while n < 120 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 2
        while n < 130 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 3
        while n < 140 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 4
        while n < 150 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 5
        while n < 160 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 6
        while n < 170 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 7
        while n < 180 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 8
        while n < 190 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        i = 9
        while n < 200 {
            totalMot[n] = totalMot[n] + [String(i)]
            i = i + 10
            n = n + 1
        }
        
        let lettresTotalMot = (lettres, totalMot)
        return lettresTotalMot
    }
        
}
