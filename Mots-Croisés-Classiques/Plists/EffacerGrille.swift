//
//  EffacerGrille.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-29.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class EffacerGrille {
    class func effacer(collectionView: UICollectionView, dimension: Int, grilleSelected: String) {
        for n in 0...dimension {
            for m in 0...dimension{
                let cell = collectionView.cellForItem(at: [n, m]) as! MotsCroisesCVCell
                if cell.laLettre.text != "#" {
                    cell.laLettre.text = " "
                    CoreDataHandler.fetchItemSaveLetter(noDeLettre: "\(n),\(m)", newLetter: " ", grilleSelected: grilleSelected)
                }
            }
        }
    }
}
