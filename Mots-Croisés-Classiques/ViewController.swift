//
//  ViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2016-12-29.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var lettres: [String] = []
    var motArray: [[String]] = []
    var totalMot: [[String]] = []
    let reuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        if let plistPath = Bundle.main.path(forResource: "ListeMot", ofType: "plist"),
            let monArray = NSArray(contentsOfFile: plistPath){
            motArray = monArray as! [[String]]
            
        }
        var n = 0
        let lettre: [String] = []
        let definition = Definition(motArray: motArray, n: n)
        while n < definition.listeArray.count {
            let definitions = Definition(motArray: motArray, n: n)
            var grille = Grille(definition: definitions, lettre: lettre)
            let transitionArray = grille.epele()
            var totMotTransition: [String] = []
            for letter in transitionArray{
                totMotTransition = [letter, definitions.mot, definitions.definition, definitions.orientation]
                totalMot = totalMot + [totMotTransition]
            }
            if definitions.orientation == "H" {
                lettres = lettres + transitionArray
            }
            n = n + 1
        }
        print(totalMot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lettres.count
    }
    // make a cell for each cell index path
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.laLettre.text = self.lettres[indexPath.item]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        if cell.laLettre.text == "#" {
           cell.backgroundColor = UIColor.black
        }
        
     return cell
   }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = indexPath.item
        
        print(totalMot[selectedCell])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    // Compute the dimension of a cell for an NxN layout with space S between
    // cells.  Take the collection view's width, subtract (N-1)*S points for
    // the spaces between the cells, and then divide by N to find the final
    // dimension for the cell's width and height.
    let cellsAcross: CGFloat = 10
    let spaceBetweenCells: CGFloat = 0
    let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
    return CGSize(width: dim, height: dim)

    
    }

}

