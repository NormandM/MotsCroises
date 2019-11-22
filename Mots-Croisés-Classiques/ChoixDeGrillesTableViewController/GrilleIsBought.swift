//
//  GrilleIsBought.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-04.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class GrilleIsBought {
    class func state(arrayButton: [[UIButton]], arrayGrillesComment: [[String]], arrayGrilleState: [[Bool]] ) -> [[String]] {
        var arrayGrilleCommentTrans = arrayGrillesComment
        for n in 0...2{
            for m in 0...5{
                if arrayGrilleState[n][m]{
                    switch m {
                    case 1:
                        arrayGrilleCommentTrans[n][m] = "Grilles 1 à 10 achetées!"
                    case 2:
                        arrayGrilleCommentTrans[n][m] = "Grilles 11 à 20 achetées!"
                    case 3:
                        arrayGrilleCommentTrans[n][m] = "Grilles 21 à 30 achetées!"
                    case 4:
                        arrayGrilleCommentTrans[n][m] = "Grilles 31 à 40 achetées!"
                    case 5:
                        arrayGrilleCommentTrans[n][m] = "Grilles 41 à 50 achetées!"
                    default:
                        print("\(n)\(m)")
                    }
                }
            }
        }
        return arrayGrilleCommentTrans
    }
}
