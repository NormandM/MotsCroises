//
//  GrilleUser.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-29.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
struct GrilleUser {
    static func write(dimension: Int, collectionView: UICollectionView) -> [[String]] {
        var grilleUser = [[String]]()
        var lineGrille = [String]()
        for n in 0...dimension {
            for m in 0...dimension {
                let cell = collectionView.cellForItem(at: [n, m]) as! MotsCroisesCVCell
                lineGrille.append(cell.laLettre.text ?? "")
            }
            grilleUser.append(lineGrille)
            lineGrille = []
        }
        return grilleUser
    }
}
