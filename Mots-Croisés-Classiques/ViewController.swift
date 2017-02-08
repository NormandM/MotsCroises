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

    var h: Bool = true
    let screenSize: CGRect = UIScreen.main.bounds
    var ref: Int = 0
    var selectedWordH: [Int] = []
    var selectedWordV: [Int] = []
    var lettres: [String] = []
    var totalMot: [[String]] = []
    var totalMotV: [String] = []
    let reuseIdentifier = "cell"
    var selectedCell: Int = 0
    var indexPathRef: IndexPath = []
    var indexPathSelected: IndexPath = []
    var indexPathPrecedent: IndexPath = []
    var indexPathInit: IndexPath = []
    var indiceCrash: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
         let solution: Bool = false
        // Position of the grid based on screen size
        verticalPosition.constant = 0.50 * screenSize.height
        let motsCroises = MotsCroises(noDeGrille: "20")
        let grilleChoisi = motsCroises.donnesMot()
        

        self.title = "Mots Croisés \(grilleChoisi[0][0])"
        var n = 0
        var i = 0
        let lettre: [String] = []
        // Creation of Array for each letter and all the info for each letter
        let definition = Definition(motArray: grilleChoisi, n: n)
        while n < definition.listeArray.count {
            let definitions = Definition(motArray: grilleChoisi, n: n)
            var grille = Grille(definition: definitions, lettre: lettre, choixDegrille: "20")
            let transitionArray = grille.epele()
            var totMotTransition: [String] = []
            for letter in transitionArray{
                totMotTransition = [definitions.grille, letter, definitions.mot, definitions.definition, definitions.orientation, String(i), definitions.noMot]
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
        _ = cellSelection(indexPath: indexPathInit)
        h = true
        super.viewDidAppear(animated)
        let height: CGFloat = 10.0 //whatever height you want
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
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
            cell.isUserInteractionEnabled = false
        }
     return cell
   }
    // MARK: - UICollectionViewDelegate protocol
    
////////////////////////////////////
//MARK; Selecting a cell
////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      // After viewDid appear triggers once the event of deselecting initial cells from viewDidAppear
        if  indexPathInit == [0, 0] {
            let cell = collectionView.cellForItem(at: indexPathInit) as! MyCollectionViewCell
            wordSelection(cell: cell)
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
            cell.backgroundColor = UIColor.white
            indexPathInit = [0, 1]
           indiceCrash = indiceCrash + 1
        }
        if indexPathPrecedent != [] {
            if let cell = collectionView.cellForItem(at: indexPathPrecedent) as? MyCollectionViewCell{
                wordSelection(cell: cell)
                cell.laLettre.isUserInteractionEnabled = false
                cell.laLettre.resignFirstResponder()
                cell.backgroundColor = UIColor.white
            }
       }
        let cell = cellSelection(indexPath: [0, indexPath.item ])
        cell.laLettre.becomeFirstResponder()
        indexPathPrecedent = indexPath
    }
    
///////////////////////////////////
// MARK: Deselecting a cell
//////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPathPrecedent) as? MyCollectionViewCell{
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        wordSelection(cell: cell)
        }
    }
/////////////////////////////////////////////////////////////////
// MARK: Moving the cursor to next letter after text has been entered
////////////////////////////////////////////////////////////////
    func textFieldDidChange(_ textField: UITextField) {
        var indexPath: IndexPath = [0, 0]
        if textField.text != "" && textField.text != "#" {
            if indexPathRef.item > 99 {indexPath = [0, 99] }
            selectedCell = indexPathRef.item
            var totalMotV: [String] = []
            for motArray in totalMot {
                if motArray[4] == "V" {
                    if motArray[7] == String(selectedCell){
                        totalMotV = motArray
                    }
                }
            }
            definitionH.text = totalMot[selectedCell][3]
            if totalMotV == []{
                indexPathRef = [0, indexPathRef.item - 1]
            }else{
                definitionV.text = totalMotV[3]
            }
 // répitition du code initial après démarrage de l'application
            if  indexPathInit == [0, 0] {
                let cell = collectionView.cellForItem(at: indexPathInit) as! MyCollectionViewCell
                wordSelection(cell: cell)
                cell.laLettre.isUserInteractionEnabled = false
                cell.laLettre.resignFirstResponder()
                cell.backgroundColor = UIColor.white
                indexPathInit = [0, 1]
                indiceCrash = indiceCrash + 1
            }
            if h{
                indexPath = [0, indexPathRef.item - 1]
                var cell = cellSelection(indexPath: indexPath)
                wordSelection(cell: cell)
                cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                while cell.laLettre.text == "#" {
                    indexPathRef = [0, indexPathRef.item + 1]
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                }
                if indexPathRef.item < 100 {
                    cell = cellSelection(indexPath: indexPathRef)
                    cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 1.0)
                    indexPathPrecedent = [0, indexPathRef.item - 1]
                }
            }else{
                ref = ref - 1
                if indiceCrash == 1 {
                    ref = 100
                    indiceCrash = indiceCrash + 1
                }
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        indexPathRef = [0, Int(mot[7])!]
                    }
                }
                indexPath = indexPathRef
                var cell = cellSelection(indexPath: indexPath)
                wordSelection(cell: cell)
                cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                for mot in totalMot {
                    if ref == Int(mot[5]){
                            indexPathRef = [0, Int(mot[7])!]
                    }
                }
                while cell.laLettre.text == "#" && ref < 200 {
            
                    for mot in totalMot {
                        if ref == Int(mot[5]){
                            indexPathRef = [0, Int(mot[7])!]
                        }
                    }
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                    ref = ref + 1
                }
                if cell.laLettre.text != "#"{
                    cell = cellSelection(indexPath: indexPathRef)
                    cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 1.0)
                    cell.laLettre.becomeFirstResponder()
                    for mot in totalMot {
                        
                        if ref == Int(mot[5]){
                            if ref == 110 || ref == 120 || ref == 130 || ref == 140 || ref == 150 || ref == 160 || ref == 170 || ref == 180 || ref == 190 {
                                indexPathPrecedent = [0, Int(mot[7])! + 89]
                                
                            }else{
                            indexPathPrecedent = [0, Int(mot[7])! - 10]
                            }
                        }
                    }
                }
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
// MARK: Func to change color background of selected word and the word definition
/////////////////////////////////////////////////////////////////////////////
    func cellSelection(indexPath: IndexPath) -> MyCollectionViewCell{
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        if cell.laLettre.text != "#" {
            selectedCell = indexPath.item
            indexPathSelected = indexPath
            var n = 0
            ref = 0
            for motArray in totalMot {
                if motArray[4] == "V" {
                     if motArray[7] == String(selectedCell){
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
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 0.60)
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
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 0.60)
                        
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
            cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 1.0)
            if h {
                indexPathRef = [0, indexPath.item + 1]
            }else{
                ref = ref + 1
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        indexPathRef = [0, Int(mot[7])!]
                    }
                }
            }
        }
       return cell
    }
/////////////////////////////////////////////////////////////////////////////////////////////
// MARK: Function determining position number of the letters of the word selected depending on
//horizontal or vertical position
///////////////////////////////////////////////////////////////////////////////////////////
    func choixDOrientation() {
        var arrayTrans: [[String]] = []
        selectedWordH = []
        selectedWordV = []
        for motArray in totalMot{
            if motArray[4] == "H" {
                if motArray[2] == totalMot[selectedCell][2] && motArray[6] == totalMot[selectedCell][6]{
                    
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
       
        // Grid position number for each letter of the word selected in horizontal position
        for array in arrayTrans {
        // making sure the lleter is within the same word
           if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[5]) {
                    selectedWordH.append(choixArray)
                }
           }
        }
        arrayTrans = []
        for motArray in totalMot {
            if motArray[4] == "V"{
                if motArray[2] == totalMotV[2] && motArray[6] == totalMotV[6]{
                    arrayTrans = arrayTrans + [motArray]
                }
            }
        }
        // Grid position number for each letter of the word selected in vertical position
        for array in arrayTrans {
        // making sure the lleter is within the same word
            if array[6] == arrayTrans[0][6]{
                if let choixArray = Int(array[7]) {
                    selectedWordV.append(choixArray)
                }
            }
        }

    }
//////////////////////////////////////////////////////////////
////// MARK: Function used when a cell is being selected
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
    //////MARK:  Function selectig word for each letter selected
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
            //cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.white
        }
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()

    }
    @IBAction func horizontalVertical(_ sender: Any) {
        if h == true {
            h = false
        }else{
            h = true
        }
        choixDOrientation()
        if h == true {
            for select in selectedWordH{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 0.60)
                }
            }
            for select in selectedWordV{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.white
                }
            }
        }else {
            indiceCrash = indiceCrash + 1
            for select in selectedWordV{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 0.60)
                }
                
            }
            for select in selectedWordH{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.white
                }
            }
        }
        let cell = cellSelection(indexPath: indexPathSelected)
        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 1.0)

    }
}

