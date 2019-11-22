//
//  StringToIndexPath.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-10-01.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
class StringToIndexPath {
    class func transform (stringIndexPath: String) -> IndexPath{
        let stringElement = Array(stringIndexPath)
        var stringArray = [String]()
        for string in stringElement {
            stringArray.append(String(string))
        }
        var indexPathSection = Int()
        var indexPathItem = Int()
        switch stringArray[0] {
        case "0":
            indexPathSection = 0
        case "1":
            indexPathSection = 1
        case "2":
            indexPathSection = 2
        case "3":
            indexPathSection = 3
        case "4":
            indexPathSection = 4
        case "5":
            indexPathSection = 5
        case "6":
            indexPathSection = 6
        case "7":
            indexPathSection = 7
        case "8":
            indexPathSection = 8
        case "9":
            indexPathSection = 9
        case "10":
            indexPathSection = 10
        case "11" :
            indexPathSection = 11
        default:
            indexPathSection = 0
        }
        switch stringArray[1] {
        case "0":
            indexPathItem = 0
        case "1":
            indexPathItem = 1
        case "2":
            indexPathItem = 2
        case "3":
            indexPathItem = 3
        case "4":
            indexPathItem = 4
        case "5":
            indexPathItem = 5
        case "6":
            indexPathItem = 6
        case "7":
            indexPathItem = 7
        case "8":
            indexPathItem = 8
        case "9":
            indexPathItem = 9
        case "10":
            indexPathSection = 10
        case "11" :
            indexPathSection = 11

        default:
            indexPathItem = 0
        }
        return [indexPathSection, indexPathItem]
    }
}

