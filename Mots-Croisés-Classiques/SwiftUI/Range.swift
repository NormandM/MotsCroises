//
//  Range.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2023-02-27.
//  Copyright © 2023 Normand Martin. All rights reserved.
//

import Foundation
struct Range {
    static func horizontal(i: Int, dimension: Int) -> Int{
        if dimension == 11 {
            switch i {
            case 0...11:
                return 1
            case 12...23:
                return 2
            case 24...35:
                return 3
            case 36...47:
                return 4
            case 48...59:
                return 5
            case 59...71:
                return 6
            case 72...83:
                return 7
            case 84...95:
                return 8
            case 96...107:
                return 9
            case 108...119:
                return 10
            case 120...131:
                return 11
            case 132...143:
                return 12
            default:
                return 0
            }
        }else{
            switch i {
            case 0...9:
                return 1
            case 10...19:
                return 2
            case 20...29:
                return 3
            case 30...39:
                return 4
            case 40...49:
                return 5
            case 50...59:
                return 6
            case 60...69:
                return 7
            case 70...79:
                return 8
            case 80...89:
                return 9
            case 90...99:
                return 10
            default:
                return 0
            }
        }
    }
    static func vertical(i: Int, dimension: Int) -> Int{
        if dimension == 11 {
            switch i {
            case 0,12,24,36,48,60,72,84,96,108,120,132:
                return 1
            case 1,13,25,37,49,61,73,85,97,109,121,133:
                return 2
            case 2,14,26,38,50,62,74,86,98,110,122,134:
                return 3
            case 3,15,27,39,51,63,75,87,99,111,123,135:
                return 4
            case 4,16,28,40,52,64,76,88,100,112,124,136:
                return 5
            case 5,17,29,41,53,65,77,89,101,113,125,137:
                return 6
            case 6,18,30,42,54,66,78,90,102,114,126,138:
                return 7
            case 7,19,31,43,55,67,79,91,103,115,127,139:
                return 8
            case 8,20,32,44,56,68,80,92,104,116,128,140:
                return 9
            case 9,21,33,45,57,69,81,93,105,117,129,141:
                return 10
            case 10,22,34,46,58,70,82,94,106,118,130,142:
                return 11
            case 11,23,35,47,59,71,83,95,107,119,131,143:
                return 12
            default:
                return 0
            }
        }else{
            switch i {
            case 0,10,20,30,40,50,60,70,80,90:
                return 1
            case 1,11,21,31,41,51,61,71,81,91:
                return 2
            case 2,12,22,32,42,52,62,72,82,92:
                return 3
            case 3,13,23,33,43,53,63,73,83,93:
                return 4
            case 4,14,24,34,44,54,64,74,84,94:
                return 5
            case 5,15,25,35,45,55,65,75,85,95:
                return 6
            case 6,16,26,36,46,56,66,76,86,96:
                return 7
            case 7,17,27,37,47,57,67,77,87,97:
                return 8
            case 8,18,28,38,48,58,68,78,88,98:
                return 9
            case 9,19,29,39,49,59,69,79,89,99:
                return 10
            default:
                return 0
            }
        }
    }

}
