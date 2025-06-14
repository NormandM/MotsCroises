//
//  LabelAndImagePosition.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-02.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class LabelAndImagePosition {
    class func place(indexPath: IndexPath, arrayGrilleState: [[Bool]]) -> (UIImage){
        var image = UIImage()
        if indexPath == [0, 0] || indexPath == [1,0] || indexPath == [2,0] || indexPath == [3,0]{
            image = UIImage(named: "gratuit5")!
        }else{
            if arrayGrilleState[indexPath.section][indexPath.row]{
                image  = UIImage(named: "achat10")!
            }else{
                image = UIImage(named: "CoinMotsCroises3")!
            }
        }
         return (image)
    }
   
}
