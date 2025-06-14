//
//  ButtonFormating.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-26.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class MenuAction {
    class func activate(buttonArray: [UIButton]){
        buttonArray.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = !eachButton.isHidden
            })
        }
    }
}
