//
//  EnumScreenSize.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2025-06-28.
//  Copyright © 2025 Normand Martin. All rights reserved.
//

import UIKit
enum ScreenSizeCategory {
    case smallPhone
    case mediumPhone
    case largePhone
    case tablet
    case unknown

    static func current() -> ScreenSizeCategory {
        let height = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)

        if UIDevice.current.userInterfaceIdiom == .pad {
            return .tablet
        }

        switch height {
        case 0..<700:
            return .smallPhone  // e.g. iPhone SE
        case 700..<850:
            return .mediumPhone // e.g. iPhone 12/13/14
        case 850...:
            return .largePhone  // e.g. iPhone 16 Pro Max
        default:
            return .unknown
        }
    }
}
