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
            return .smallPhone          // iPhone SE, iPod Touch
        case 700..<900:
            return .mediumPhone         // iPhone 11–15, 16, 16 Pro
        case 900..<1024:
            return .largePhone          // iPhone Pro Max models
        case 1024...:
            return .tablet              // iPads
        default:
            return .unknown
        }
    }
}
