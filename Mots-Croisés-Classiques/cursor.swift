//
//  cursor.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-04-07.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit

class cursor: UITextField {
   
   override func caretRect(for position:UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) ->  [Any] {
     
    return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    
    
    return false
    }



}
