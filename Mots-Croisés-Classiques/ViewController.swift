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
    var grilleSelected: String = ""
    let screenSize: CGRect = UIScreen.main.bounds
    var ref: Int = 0
    var reponse: [[String]] = []
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
        
        
         let solution: Bool = true
        
        
        // Position of the grid based on screen size
        verticalPosition.constant = 0.50 * screenSize.height
        
        let motsCroises = MotsCroises(noDeGrille: grilleSelected)
        let grilleChoisi = motsCroises.donnesMot()
        self.title = "Mots Croisés \(grilleChoisi[0][0])"
        let motsCroisesArray = MotsCroisesArray(grilleSelected: grilleSelected)
        let lettresMotTotal = motsCroisesArray.motsCroisesArray()
        lettres = lettresMotTotal.0
        totalMot = lettresMotTotal.1
        var n = 0
        if solution == false{
            for lettre in lettres {
                if lettre != "#"{
                    lettres[n] = ""
                }
                n = n + 1
            }
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
        let reponse = reponseACeMoment()
        let completeCheck = CompleteCheck(grilleSelected: grilleSelected)
        let resultat = completeCheck.completeCheck(reponse: reponse)
        if resultat.0 {
            showAlert()
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
            let selectionMot = SelectionMot(selectedCell: selectedCell, totalMot: totalMot)
            
            selectedWordH = selectionMot.selectionMot().0
            selectedWordV = selectionMot.selectionMot().1
            
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
            cell.backgroundColor = UIColor.white
        }
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()

    }

    func showAlert () {
        
        let alertController = UIAlertController(title: "Bravo", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = definitionH.frame
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: dismissAlert)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func dismissAlert(_ sender: UIAlertAction) {
        
    }
    func showAlert2 (){
        let alertController = UIAlertController(title: "Bravo", message: "Il n'y a pas d'erreur", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = definitionH.frame
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: dismissAlert)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    func dismissAlert2(_ sender: UIAlertAction) {
        let cell = collectionView.cellForItem(at: [0, selectedCell]) as! MyCollectionViewCell
        cell.backgroundColor = UIColor.white
    }

    func reponseACeMoment() -> [[String]]{
        var n = 0
        var reponse: [[String]] = []
        while n < 100 {
            let cell = collectionView.cellForItem(at: [0, n]) as! MyCollectionViewCell
            reponse.append([String(n), cell.laLettre.text!])
            n = n + 1
        }
        return reponse
    }

    @IBAction func horizontalVertical(_ sender: Any) {
        if h == true {
            h = false
        }else{
            h = true
        }
        let selectionMot = SelectionMot(selectedCell: selectedCell, totalMot: totalMot)
        selectedWordH = selectionMot.selectionMot().0
        selectedWordV = selectionMot.selectionMot().1

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

    @IBAction func verificationlettre(_ sender: Any) {
        let reponse = reponseACeMoment()
        let lettreChoisiIndex = reponse[selectedCell][0]
        let verificationLettre = Verification(grilleSelected: grilleSelected, reponse: reponse)
        if verificationLettre.verificationLettre(lettreChoisiIndex: lettreChoisiIndex).0{
            showAlert2()
        }else{
            let cell = collectionView.cellForItem(at: [0, selectedCell]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.red
        }
        self.view.endEditing(true)
    }
    
    @IBAction func verificationMot(_ sender: Any) {
        let reponse = reponseACeMoment()
        let verificationDuMot = VerificationDuMot(grilleSelected: grilleSelected, reponse: reponse, horizontal: h)
        let motVerifie = verificationDuMot.verificationDuMot(selectedCell: selectedCell, reponse: reponse)
        var erreurLettre: [Int] = []
        if motVerifie.0 == true {
            showAlert2()
        }else{
            var n = 0
            for lettre in motVerifie.2{
                if lettre != motVerifie.3[n]{
                    erreurLettre.append(motVerifie.1[n])
                }
                n = n + 1
            }
            
        }

        for lettre in erreurLettre{
            let cell = collectionView.cellForItem(at: [0, lettre]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.red
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
        }
        
        
        self.view.endEditing(true)
    }
    
    @IBAction func verificationGrille(_ sender: Any) {
        let reponse = reponseACeMoment()
        let completeCheck = CompleteCheck(grilleSelected: grilleSelected)
        let result = completeCheck.completeCheck(reponse: reponse)
        let resultArray = result.3
        for indexLettre in resultArray {
            let cell = collectionView.cellForItem(at: [0, Int(indexLettre[0])!]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.red
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
        }
        let grilleVerifie = result.0
        if grilleVerifie{
            showAlert2()
        }

    }
    
    @IBAction func revelerLettre(_ sender: Any) {
        let reponse = reponseACeMoment()
        let lettreChoisiIndex = reponse[selectedCell][0]
        let verificationLettre = Verification(grilleSelected: grilleSelected, reponse: reponse)
        let resultatVerification = verificationLettre.verificationLettre(lettreChoisiIndex: lettreChoisiIndex)
        if resultatVerification.0{
            showAlert2()
        }else{
            let cell = collectionView.cellForItem(at: [0, selectedCell]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.green
            cell.laLettre.text = resultatVerification.1
        }
        self.view.endEditing(true)

    }
    @IBAction func revelerMot(_ sender: Any) {
        var bonneReponse: [String] = []
        let reponse = reponseACeMoment()
        let verificationDuMot = VerificationDuMot(grilleSelected: grilleSelected, reponse: reponse, horizontal: h)
        let motVerifie = verificationDuMot.verificationDuMot(selectedCell: selectedCell, reponse: reponse)
        var erreurLettre: [Int] = []
        if motVerifie.0 == true {
            showAlert2()
        }else{
            var n = 0
            for lettre in motVerifie.2{
                if lettre != motVerifie.3[n]{
                    erreurLettre.append(motVerifie.1[n])
                    bonneReponse.append(motVerifie.2[n])
                    
                }
                n = n + 1
            }
            
        }
        var n = 0
        for lettre in erreurLettre{
            let cell = collectionView.cellForItem(at: [0, lettre]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.green
            cell.laLettre.text = bonneReponse[n]
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
            n = n + 1
        }
        self.view.endEditing(true)
    }
    
    @IBAction func revelerGrille(_ sender: Any) {
        var n = 0
        let reponse = reponseACeMoment()
        let completeCheck = CompleteCheck(grilleSelected: grilleSelected)
        let result = completeCheck.completeCheck(reponse: reponse)
        let resultArray = result.3
        for indexLettre in resultArray {
            let cell = collectionView.cellForItem(at: [0, Int(indexLettre[0])!]) as! MyCollectionViewCell
            cell.backgroundColor = UIColor.green
            cell.laLettre.text = resultArray[n][1]
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
            n = n + 1
        }
        let grilleVerifie = result.0
        if grilleVerifie{
            showAlert2()
        }

        
    }
    
    
    
    
    
    
    @IBAction func hideKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
        
    }

    
}

