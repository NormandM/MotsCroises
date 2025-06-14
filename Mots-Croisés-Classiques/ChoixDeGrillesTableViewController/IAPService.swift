//
//  IAPService.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-05.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
import StoreKit
extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
