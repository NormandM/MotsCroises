//
//  ReponseTotale.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-14.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
struct ReponseTotale {
    let reponse: [[String]]
    let grilleSelected: String
    func reponseTotale() -> [[String]] {
        var n = 0
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        var arrayMotsCroises = motsCroisesArray.motsCroisesArray().1
        for mot in reponse {
            if mot[1] != arrayMotsCroises[n][1]{
                arrayMotsCroises[n][1] = mot[1]
            }
            n = n + 1
        }
        n = 100
        var i = 0
        while n < 110 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 1
        while n < 120 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 2
        while n < 130 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 3
        while n < 140 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 4
        while n < 150 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 5
        while n < 160 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 6
        while n < 170 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 7
        while n < 180 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 8
        while n < 190 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }
        i = 9
        while n < 200 {
            if arrayMotsCroises[n][1] != reponse[i][1]{
                arrayMotsCroises[n][1] = reponse[i][1]
            }
            i = i + 10
            n = n + 1
        }

        return arrayMotsCroises
    }
}
