//
//  Extensions.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-12-02.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
extension String {
    func stripOfAccent() -> String {
        if self == "é" || self == "É" {
            return "E"
        }else if self == "è" || self == "È" {
            return "E"
        }else if self == "à" || self == "À" {
            return "A"
        }else if self == "ê" || self == "Ê" {
            return "E"
        }else if self == "â" || self == "Â" {
            return "A"
        }else if self == "ä" || self == "Ä" {
            return "A"
        }else if self == "ë" || self == "Ë" {
            return "E"
        }else if self == "ï" || self == "Ï" {
            return "I"
        }else if self == "î" || self == "Î" {
            return "I"
        }else if self == "ô" || self == "Ô" {
            return "O"
        }else if self == "ö" || self == "Ö" {
            return "O"
        }else if self == "ù" || self == "Ù" {
            return "U"
        }else if self == "û" || self == "Û" {
            return "U"
        }else if self == "ü" || self == "Ü" {
            return "U"
        }else if self == "ÿ" || self == "Ÿ" {
            return "Y"
        }else if self == "ç" || self == "Ç" {
            return "C"
        }else{
            return self
        }
        
    }
    
}
