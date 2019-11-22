//
//  SelectingTextField.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-16.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class SelectingTextField {
    class func selectBegin(cell: MotsCroisesCVCell){
        cell.backgroundColor = ColorReference.coralColorVDardk
        cell.laLettre.isUserInteractionEnabled = true
        cell.laLettre.becomeFirstResponder()
        cell.laLettre.selectAll(nil)
        cell.laLettre.backgroundColor = .clear
        let newPosition = cell.laLettre.beginningOfDocument
        cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: newPosition, to: newPosition)
    }
    class func selectEnd(cell: MotsCroisesCVCell) -> String{
        cell.backgroundColor = ColorReference.coralColorVDardk
        cell.laLettre.isUserInteractionEnabled = true
        cell.laLettre.becomeFirstResponder()
        cell.laLettre.selectAll(nil)
        let newPosition = cell.laLettre.endOfDocument
        cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: newPosition, to: newPosition)
        return cell.laLettre.text ?? ""
    }
}

