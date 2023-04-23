//
//  OrderVertical.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2023-02-27.
//  Copyright © 2023 Normand Martin. All rights reserved.
//

import Foundation
struct Order{
    static func vertical(defs: [(String, Int, String)]) -> [(String, Int, String)]{
        var array1 = [(String, Int, String)]()
        var array2 = [(String, Int, String)]()
        var array3 = [(String, Int, String)]()
        var array4 = [(String, Int, String)]()
        var array5 = [(String, Int, String)]()
        var array6 = [(String, Int, String)]()
        var array7 = [(String, Int, String)]()
        var array8 = [(String, Int, String)]()
        var array9 = [(String, Int, String)]()
        var array10 = [(String, Int, String)]()
        var array11 = [(String, Int, String)]()
        var array12 = [(String, Int, String)]()
        for def in defs {
            switch def.2 {
            case "1":
                array1.append(def)
            case "2":
                array2.append(def)
            case "3":
                array3.append(def)
            case "4":
                array4.append(def)
            case "5":
                array5.append(def)
            case "6":
                array6.append(def)
            case "7":
                array7.append(def)
            case "8":
                array8.append(def)
            case "9":
                array9.append(def)
            case "10":
                array10.append(def)
            case "11":
                array11.append(def)
            case "12":
                array12.append(def)
            default:
                return [("",0,"")]
            }
        }
        return array1 + array2 + array3 + array4 + array5 + array6 + array7 + array8 + array9 + array10 + array11 + array12
    }
}
