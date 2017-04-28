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
    let noMot: String
    let listeArray: [[String]]
    let n: Int
    init (motArray: [[String]] , n: Int){
        self.n = n
        grille = motArray[n][0]
        listeArray = motArray
        orientation = motArray[n][2]
        mot = motArray[n][1]
        definition = motArray[n][3]
        noMot = motArray[n][4]
        
    }
}
struct Grille {
    let definition: Definition
    var lettre: [String]
    var choixDegrille: String
    mutating func epele() -> [String] {
        if definition.grille == choixDegrille {
            let transitionArray = (Array(definition.mot.characters.map{String($0)}))
            lettre = transitionArray
        }
    return lettre
    }
}
struct MotsCroises {
    let noDeGrille: String
    func donnesMot() -> [[String]]  {
        var motArrayInit: [[String]] = []
        var grilleChoisi: [[String]] = []
        if let plistPath = Bundle.main.path(forResource: "ListeMot", ofType: "plist"),
        let monArray = NSArray(contentsOfFile: plistPath){
            motArrayInit = monArray as! [[String]]
        }
        for mot in motArrayInit{
            if mot[0] == noDeGrille{
                grilleChoisi.append(mot)
            }
        }
     return grilleChoisi
    }
    
}















