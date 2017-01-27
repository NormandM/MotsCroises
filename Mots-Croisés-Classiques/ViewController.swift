//
//  ViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2016-12-29.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var definitionH: UILabel!
    @IBOutlet weak var definitionV: UILabel!
    @IBOutlet weak var verticalPosition: NSLayoutConstraint!
    @IBOutlet weak var boutonVertical: UIButton!
    @IBOutlet weak var boutonHorizontal: UIButton!

    var h: Bool = true
    let screenSize: CGRect = UIScreen.main.bounds
    var ref: Int = 0
    var selectedWordH: [Int] = []
    var selectedWordV: [Int] = []
    var lettres: [String] = []
    var grilleChoisi: [[String]] = []
    var totalMot: [[String]] = []
    var totalMotV: [String] = []
    let reuseIdentifier = "cell"
    var selectedCell: Int = 0
    var indexPathRef: IndexPath = []
    var indexPathSelected: IndexPath = []
    var indexPathInit: IndexPath = []
    var indiceCrash: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        var motArrayInit: [[String]] = []
         var solution: Bool = true
        // Position of the grid based on screen size
        verticalPosition.constant = 0.45 * screenSize.height
        if let plistPath = Bundle.main.path(forResource: "ListeMot", ofType: "plist"),
            let monArray = NSArray(contentsOfFile: plistPath){
            motArrayInit = monArray as! [[String]]
        }
        for mot in motArrayInit{
            if mot[0] == "14"{
                grilleChoisi.append(mot)
            }
        }
        var n = 0
        var i = 0
        let lettre: [String] = []
        // Creation of Array for each letter and all the info for each letter
        let definition = Definition(motArray: grilleChoisi, n: n)
        while n < definition.listeArray.count {
            let definitions = Definition(motArray: grilleChoisi, n: n)
            var grille = Grille(definition: definitions, lettre: lettre, choixDegrille: "14")
            let transitionArray = grille.epele()
            var totMotTransition: [String] = []
            for letter in transitionArray{
                totMotTransition = [definitions.grille, letter, definitions.mot, definitions.definition, definitions.orientation, String(i)]
                    totalMot = totalMot + [totMotTransition]
                    i = i + 1
            }
                lettres = lettres + transitionArray
            n = n + 1
        }
        n = 0
        if solution == false{
            for lettre in lettres {
                if lettre != "#"{
                    lettres[n] = ""
                }
                n = n + 1
            }
        }

// Add a reference for vertical words based on horizontal reference
        n = 100
        i = 0
            while n < 110 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 1
            while n < 120 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 2
            while n < 130 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 3
            while n < 140 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 4
            while n < 150 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 5
            while n < 160 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 6
            while n < 170 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 7
            while n < 180 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 8
            while n < 190 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
            i = 9
            while n < 200 {
                totalMot[n] = totalMot[n] + [String(i)]
                i = i + 10
                n = n + 1
            }
    }
///////////////////////////////////////////////////////
// Initial position of cursor after the grid appears
/////////////////////////////////////////////////////
    override func viewDidAppear(_ animated: Bool) {
        indexPathInit = [0,0]
        let cell = cellSelection(indexPath: indexPathInit)
        h = true
        boutonVertical.titleLabel?.textColor = UIColor.red
        boutonHorizontal.titleLabel?.textColor = UIColor.green

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lettres.count
    }
 ///////////////////////////////////////////
// create a cell for each cell index path
////////////////////////////////////////////
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.laLettre.text = self.lettres[indexPath.item]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        if cell.laLettre.text == "#" {
            cell.backgroundColor = UIColor.black
            cell.laLettre.backgroundColor = UIColor.black
        }
        
     return cell
   }
    // MARK: - UICollectionViewDelegate protocol
    
////////////////////////////////////
//Selecting a cell
////////////////////////////////////
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      // After viewDid appear triggers once the event of deselecting initial cells from viewDidAppear
        if indexPathInit == [0, 0] {
            let cell = collectionView.cellForItem(at: indexPathInit) as! MyCollectionViewCell
            wordSelection(cell: cell)
            cell.laLettre.isEnabled = false
            cell.laLettre.resignFirstResponder()
            cell.backgroundColor = UIColor.white
            indexPathInit = [0, 1]
            indiceCrash = indiceCrash + 1
            
        }
        indexPathSelected = indexPath
        cellSelection(indexPath: indexPath)
     }
    
///////////////////////////////////
// Deselecting a cell
//////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        wordSelection(cell: cell)
    }
/////////////////////////////////////////////////////////////////
// Moving the cursor to next letter after text has been entered
////////////////////////////////////////////////////////////////
    func textFieldDidChange(_ textField: UITextField) {
        if textField.text != "" && textField.text != "#" {
            var indexPath: IndexPath
            selectedCell = indexPathRef.item
            var totalMotV: [String] = []
            for motArray in totalMot {
                if motArray[4] == "V" {
                    if motArray[6] == String(selectedCell){
                        totalMotV = motArray
                    }
                }
            }
            definitionH.text = totalMot[selectedCell][3]
            definitionV.text = totalMotV[3]
            print(ref)
            if h{
                print(indiceCrash)
                if indiceCrash == 2 {
                ref = ref - 1
                    for mot in totalMot {
                        if ref == Int(mot[5]){
                            indexPathRef = [0, Int(mot[6])!]
                            print(indexPathRef)
                        }
                    }
                    indiceCrash = indiceCrash + 1
                }
                indexPath = [0, indexPathRef.item - 1]
                print(indexPath)
                var cell = cellSelection(indexPath: indexPath)
                wordSelection(cell: cell)
                cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                while cell.laLettre.text == "#" {
                    indexPathRef = [0, indexPathRef.item + 1]
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                }
                cell = cellSelection(indexPath: indexPathRef)
                cell.backgroundColor = UIColor.gray

            }else{
                ref = ref - 1
                if indiceCrash == 1 {
                    ref = 100
                    indiceCrash = indiceCrash + 1
                }
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        indexPathRef = [0, Int(mot[6])!]
                    }
                }
                indexPath = indexPathRef
                var cell = cellSelection(indexPath: indexPath)
                wordSelection(cell: cell)
                cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                //ref = ref + 1
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        indexPathRef = [0, Int(mot[6])!]
                    }
                }
                while cell.laLettre.text == "#" {
                    ref = ref + 1
                    for mot in totalMot {
                        if ref == Int(mot[5]){
                            indexPathRef = [0, Int(mot[6])!]
                        }
                    }

                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                }

                cell = cellSelection(indexPath: indexPathRef)
                cell.backgroundColor = UIColor.gray
            }
        }
            
    }
/////////////////////////////////////////////////////////////////////////
//Compute the dimension of a cell for an NxN layout with space S between
// cells.  Take the collection view's width, subtract (N-1)*S points for
// the spaces between the cells, and then divide by N to find the final
// dimension for the cell's width and height.
/////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellsAcross: CGFloat = 10
    let spaceBetweenCells: CGFloat = 0
    let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
    return CGSize(width: dim, height: dim)
    }
//////////////////////////////////////////////////////////////////////////////
/// Func to change color background of selected word and the word definition
/////////////////////////////////////////////////////////////////////////////
    func cellSelection(indexPath: IndexPath) -> MyCollectionViewCell{
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        if cell.laLettre.text != "#" {
            selectedCell = indexPath.item
            var n = 0
            ref = 0
            for motArray in totalMot {
                if motArray[4] == "V" {
                     if motArray[6] == String(selectedCell){
                        totalMotV = motArray
                        ref = n
                    }
                }
                n = n + 1
            }
            choixDOrientation()
            if h{
                for select in selectedWordH{
                    if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                        cell.backgroundColor = UIColor.lightGray
                    }
                }
                for select in selectedWordV{
                    if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                        cell.backgroundColor = UIColor.white
                    }
                }
            }else{
                for select in selectedWordV{
                    if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                        cell.backgroundColor = UIColor.lightGray
                    }
                }
                for select in selectedWordH{
                    if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                        cell.backgroundColor = UIColor.white
                    }
                }

            }
            definitionH.text = totalMot[selectedCell][3]
            definitionV.text = totalMotV[3]
            let cell = helperCellSelect(indexPath: indexPath)
            cell.backgroundColor = UIColor.gray
            if h {
                indexPathRef = [0, indexPath.item + 1]
            }else{
                ref = ref + 1
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        indexPathRef = [0, Int(mot[6])!]
                    }
                }
            }
        }
       return cell
    }
/////////////////////////////////////////////////////////////////////////////////////////////
// Function determining position number of the letters of the word selected depending on
//horizontal or vertical position
///////////////////////////////////////////////////////////////////////////////////////////
    func choixDOrientation() {
        var arrayTrans: [[String]] = []
        selectedWordH = []
        selectedWordV = []
        for motArray in totalMot{
            if motArray[4] == "H" {
                if motArray[2] == totalMot[selectedCell][2] {
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
       
        // Grid position number for each letter of the word selected in horizontal position
        for array in arrayTrans {
            if let choixArray = Int(array[5]) {
                selectedWordH.append(choixArray)
            }
        }
        arrayTrans = []
        for motArray in totalMot {
            if motArray[4] == "V"{
                if motArray[2] == totalMotV[2]{
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        // Grid position number for each letter of the word selected in vertical position
        for array in arrayTrans {
            if let choixArray = Int(array[6]) {
                selectedWordV.append(choixArray)
            }
        }
    }
//////////////////////////////////////////////////////////////
////// Function used when a cell is being selected
//////////////////////////////////////////////////////////
    func helperCellSelect(indexPath: IndexPath) -> MyCollectionViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        cell.laLettre.isUserInteractionEnabled = true
        cell.laLettre.becomeFirstResponder()
        cell.laLettre.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: cell.laLettre.beginningOfDocument, to: cell.laLettre.beginningOfDocument)
        return cell
    }
    //////////////////////////////////////////////////////////////
    ////// Function selectig word for each letter selected
    //////////////////////////////////////////////////////////
    func wordSelection(cell: MyCollectionViewCell) {
        if cell.laLettre.text != "#" {
            for select in selectedWordH{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.white
                }
            }
            for select in selectedWordV{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.white
                }
            }
            //let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.white
        }
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()

    }
    @IBAction func choixVertical(_ sender: Any) {
        h = false
        indiceCrash = indiceCrash + 1
        boutonVertical.titleLabel?.textColor = UIColor.green
        boutonHorizontal.titleLabel?.textColor = UIColor.red
        choixDOrientation()
        for select in selectedWordV{
            if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                cell.backgroundColor = UIColor.lightGray
            }
            
        }
        for select in selectedWordH{
            if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                cell.backgroundColor = UIColor.white
            }
        }
        if indiceCrash == 1 {indexPathSelected = [0, 0]}
        let cell = collectionView.cellForItem(at: indexPathSelected) as! MyCollectionViewCell
        cell.backgroundColor = UIColor.gray

    }

    @IBAction func choixHorizontal(_ sender: Any) {
        h = true
        boutonVertical.titleLabel?.textColor = UIColor.red
        boutonHorizontal.titleLabel?.textColor = UIColor.green
        choixDOrientation()
        for select in selectedWordH{
            if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                cell.backgroundColor = UIColor.lightGray
            }
        }
        for select in selectedWordV{
            if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                cell.backgroundColor = UIColor.white
            }
        }
        if indiceCrash == 2 {
            indexPathSelected = [0, selectedWordH[0]]
        
        }
        //let cell = collectionView.cellForItem(at: ) as! MyCollectionViewCell
        let cell = helperCellSelect(indexPath: indexPathSelected)
        cell.backgroundColor = UIColor.gray

    }
   
    
}

