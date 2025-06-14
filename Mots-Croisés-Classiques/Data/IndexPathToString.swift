//
//  IndexPathToString.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-10-02.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
class IndexPathToString{
    class func convert(indexPath: IndexPath) -> String{
        return "\(indexPath.section),\(indexPath.item)"
    }
}
