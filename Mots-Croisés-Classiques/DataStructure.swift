//
//  DataStructure.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2016-12-30.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import Foundation
struct Definition {
    let mot: String
    let definition: String
    let orientation: String
    let grille: String
    let listeArray: [[String]]
    let n: Int
    init (motArray: [[String]] , n: Int){
        self.n = n
        listeArray = motArray
        grille = motArray[n][0]
        orientation = motArray[n][2]
        mot = motArray[n][1]
        definition = motArray[n][3]
        
    }
}

struct Grille {
    let definition: Definition
    var lettre: [String]
    mutating func epele() -> [String] {
            //if definition.orientation == "H"{
               let transitionArray = (Array(definition.mot.characters.map{String($0)}))
                lettre = transitionArray
            //}
    return lettre
    }
}
