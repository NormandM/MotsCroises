//
//  SpecialTableViewCell.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-08.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit

class SpecialTableViewCell: UITableViewCell {

    @IBOutlet weak var grilleLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var purchaseImageView: UIImageView!
    
    override func awakeFromNib() {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
