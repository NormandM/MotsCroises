//
//  SelectedCellColor.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-18.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class SelectingCellColor {
    class func colorSelected(isHorizontal: Bool, collectionView: UICollectionView, indexPathSelected: IndexPath, dimension: Int) -> (Bool, [String], String, [IndexPath]){
        var  cell = collectionView.cellForItem(at: indexPathSelected) as! MotsCroisesCVCell
        var letterArray = [String]()
        if cell.laLettre.text == "" {
            cell.laLettre.text = " "
        }
        for n in 0...dimension {
            for m in 0...dimension {
                cell = collectionView.cellForItem(at: [n, m]) as! MotsCroisesCVCell
                if cell.laLettre.text != "#"{
                    cell.backgroundColor = ColorReference.sandColor
                }
            }
        }
        let pathArray = WordSelection.selectWord(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        for word in pathArray.0 {
            cell = collectionView.cellForItem(at: word) as! MotsCroisesCVCell
            letterArray.append(cell.laLettre.text ?? "")
            cell.backgroundColor = ColorReference.coralColorLigh
        }
        let word = letterArray
        cell = collectionView.cellForItem(at: indexPathSelected) as! MotsCroisesCVCell
        let lettre = SelectingTextField.selectEnd(cell: cell)
        let wasHorizontal = pathArray.1
        return (wasHorizontal, word, lettre, pathArray.0)
    }
    class func colorDeselected(wasHorizontal: Bool, collectionView: UICollectionView, indexPathSelected: IndexPath, dimension: Int) {
        var  cell = collectionView.cellForItem(at: indexPathSelected) as! MotsCroisesCVCell
        cell.laLettre.isUserInteractionEnabled = false
        let wordArray = WordSelection.selectWord(isHorizontal: wasHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        for word in wordArray.0 {
            cell = collectionView.cellForItem(at: word) as! MotsCroisesCVCell
            cell.backgroundColor = ColorReference.sandColor
        }
    }
}
