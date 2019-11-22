//
//  ActivityIndicator.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-24.
//  Copyright © 2017 Normand Martin. All rights reserved.
//
import UIKit
import Foundation
class ActivityIndicatorView
{
    var view: UIView!
    
    var activityIndicator: UIActivityIndicatorView!
    let fonts = FontsAndConstraintsOptions()
    var title: String!
    
    init(title: String, center: CGPoint, width: CGFloat = 350.0, height: CGFloat = 80.0)
    {
        self.title = title
        let x = center.x - width/2.0
        let y = center.y - height/2.0
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = ColorReference.coralColorVDardk
        self.view.layer.cornerRadius = 10
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.activityIndicator.color = UIColor.white
        self.activityIndicator.hidesWhenStopped = false
        let titleLabel = UILabel(frame: CGRect(x: 90, y: 15, width: 200, height: 50))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = fonts.normalBoldFont
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(titleLabel)
    }
    
    func getViewActivityIndicator() -> UIView
    {
        return self.view
    }
    
    func startAnimating()
    {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimating()
    {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        self.view.removeFromSuperview()
    }
    //end
}
