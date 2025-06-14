//
//  FormatAndHideButton.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-26.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class FormatAndHideButton{
    class func activate(buttonArray: [UIButton]){
        let fonts = FontsAndConstraintsOptions()
        buttonArray.forEach {(eachButton) in
            eachButton.backgroundColor = ColorReference.sandColor
            eachButton.titleLabel?.font = fonts.smallBoldFont
        //    eachButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            eachButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
            eachButton.isHidden = true

        }
    }
}
