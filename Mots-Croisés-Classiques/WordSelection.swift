//
//  WordSelection.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-17.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class WordSelection {
    class func selectWord(isHorizontal: Bool, collectionView: UICollectionView, indexPathSelected: IndexPath, dimension: Int) -> ([IndexPath], Bool){
        var wordArraySelected = [IndexPath]()
        var filteredIndexPaths = [IndexPath]()
        var groupedIndexPaths = [[IndexPath]]()
        var cell = collectionView.cellForItem(at: indexPathSelected) as! MotsCroisesCVCell
        for n in 0...dimension {
            if isHorizontal{
                cell = collectionView.cellForItem(at: [indexPathSelected.section, n]) as! MotsCroisesCVCell
            }else{
                cell = collectionView.cellForItem(at: [n, indexPathSelected.item]) as! MotsCroisesCVCell
            }
            if cell.laLettre.text != "#" {
                if isHorizontal{
                    filteredIndexPaths.append([indexPathSelected.section, n])
                }else{
                    filteredIndexPaths.append([n, indexPathSelected.item])
                }
            }else{
                if filteredIndexPaths != [] {groupedIndexPaths.append(filteredIndexPaths)}
                filteredIndexPaths = []
            }
            if filteredIndexPaths != [] {
                groupedIndexPaths.append(filteredIndexPaths)
            }
        }
        for indexPathArray in groupedIndexPaths {
            if indexPathArray.contains(indexPathSelected){
                wordArraySelected = indexPathArray
            }
        }
        return (wordArraySelected, isHorizontal)
    }
}
