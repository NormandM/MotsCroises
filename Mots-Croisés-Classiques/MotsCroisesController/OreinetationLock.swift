//
//  File.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2023-03-31.
//  Copyright © 2023 Normand Martin. All rights reserved.
//

import UIKit
struct AppOrientationUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
        
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        // Find the key window's scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Define the desired interface orientation
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)

            // Request the geometry update
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                print("Failed to update orientation: \(error.localizedDescription)")
            }
        }
    }
}
