//
//  TextFieldMaxLengths.swift.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-01-13.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
import UIKit

private var maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText.prefix(upTo: maxCharIndex))
        //text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }

}

