//
//  ScrollingPositions.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-17.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
class Scrolling {
    class func moveHorizontalRight (indexPath: IndexPath, dimension: Int) -> IndexPath{
        var newIndexPath: IndexPath = [indexPath.section,  indexPath.item + 1]
        if newIndexPath.item > dimension{
            newIndexPath = [indexPath.section + 1, 0]
            if newIndexPath.section > dimension{
                newIndexPath = [0, 0]
            }
        }
        return newIndexPath
    }
    class func moveHorizontalLeft (indexPath: IndexPath, dimension: Int) -> IndexPath{
        var newIndexPath: IndexPath = [indexPath.section,  indexPath.item - 1]
        if newIndexPath.item < 0 {
            newIndexPath = [indexPath.section - 1, dimension]
            if newIndexPath.section < 0 {
                newIndexPath = [dimension, dimension]
            }
        }
        return newIndexPath
    }
    class func moveVerticalDown (indexPath: IndexPath, dimension: Int) -> IndexPath{
        var newIndexPath: IndexPath = [indexPath.section + 1,  indexPath.item]
        if newIndexPath.section >  dimension {
            newIndexPath = [0, newIndexPath.item + 1]
            if newIndexPath.item > dimension {
                newIndexPath = [0, 0]
            }
        }
        return newIndexPath
    }
    class func moveVerticalUp (indexPath: IndexPath, dimension: Int) -> IndexPath{
        var newIndexPath: IndexPath = [indexPath.section - 1,  indexPath.item]
        if newIndexPath.section < 0 {
            newIndexPath = [dimension, newIndexPath.item - 1]
            if newIndexPath.item < 0 {
                newIndexPath = [dimension, dimension]
            }
        }
        return newIndexPath
    }
}
