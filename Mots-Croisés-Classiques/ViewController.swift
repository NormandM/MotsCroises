//
//  ViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2016-12-29.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate, GADBannerViewDelegate {
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-1437510869244180/3214567654"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    var items: [Item] = []
    let dataController = DataController.sharedInstance
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    var activityIndicatorView: ActivityIndicatorView!

    
    lazy var fetchRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in 
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "lettre", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "noMotcroise" ,ascending: false)
        let sortDescriptor3 = NSSortDescriptor(key: "noDeLettre" ,ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor2, sortDescriptor3, sortDescriptor]
        return request
    }()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var definitionH: UILabel!
    @IBOutlet weak var definitionV: UILabel!
    
    
    @IBOutlet weak var topView: NSLayoutConstraint!
    
    @IBOutlet weak var verticalPosition: NSLayoutConstraint!
    @IBOutlet weak var distanceEntre: NSLayoutConstraint!
    @IBOutlet weak var pointInterrogation: UIButton!
    @IBOutlet weak var alignementPoint: NSLayoutConstraint!
    @IBOutlet weak var leadingVerifierLettre: NSLayoutConstraint!
    @IBOutlet weak var trailingRevelerLettre: NSLayoutConstraint!
    @IBOutlet weak var centreVerifierLettre: NSLayoutConstraint!
    @IBOutlet weak var topVérifierMot: NSLayoutConstraint!
    @IBOutlet weak var topVérifierGrille: NSLayoutConstraint!
    @IBOutlet weak var bottomEffacerTout: NSLayoutConstraint!
    @IBOutlet weak var VTop: NSLayoutConstraint!
    @IBOutlet weak var topH: NSLayoutConstraint!
    @IBOutlet weak var definitionVWidth: NSLayoutConstraint!
    @IBOutlet weak var iconeHVconstraint: NSLayoutConstraint!
    @IBOutlet weak var definitionHWidth: NSLayoutConstraint!
    
    @IBOutlet weak var addView: UIView!
    
    
    var finDeCourse : Bool = false
    var backSpacePressed: Bool = false
    var stateOfMotsCroises: String = ""
    let modelName = UIDevice()
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
    var indexPathBack: IndexPath = []
    var indiceCrash: Int = 0
    override func viewDidLoad() { 
        super.viewDidLoad()
        adBannerView.load(GADRequest())
        navigationItem.titleView = adBannerView
        
        let modelName = UIDevice.current.modelName
        // Position of the grid based on screen size
        if modelName == "iPhone 5" || modelName == "iPhone 5c" || modelName == "iPhone 5s"{
            verticalPosition.constant = 0.50 * screenSize.height
            distanceEntre.constant = -305.0
            alignementPoint.constant = -230.0
            centreVerifierLettre.constant = 120.0
            leadingVerifierLettre.constant = -30
            trailingRevelerLettre.constant = 35
        }else if modelName == "iPad 2" || modelName == "iPad 3" || modelName == "iPad 4" || modelName == "iPad Air" || modelName == "iPad Air 2" || modelName == "iPad Pro" {
            topView.constant = 50
            verticalPosition.constant = 0.44 * screenSize.height
            centreVerifierLettre.constant = 250
            topVérifierMot.constant = 20
            topVérifierGrille.constant = 20
            bottomEffacerTout.constant = 70
            topH.constant = 30
            definitionH.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 20)
            definitionV.font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 20)
            iconeHVconstraint.constant = 25
            definitionH.frame.size.width = 200
            definitionV.frame.size.width = 200
            definitionHWidth.constant = 380
            definitionVWidth.constant = 380
        }else{
            verticalPosition.constant = 0.44 * screenSize.height

        }
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let solution: Bool = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "grungyPaper")!)
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
                    lettres[n] = " "
                }
                n = n + 1
            }
        }

       fetchRequest.predicate = NSPredicate(format: "noMotcroise == %@", grilleSelected)
       do {
            items = try managedObjectContext.fetch(fetchRequest) as! [Item]
        }catch let error as NSError{
            print("Error fetching items objects; \(error.localizedDescription), \(error.userInfo)")
       }

        n = 0
        if items == [] {
            while n < 100 {
                let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: dataController.managedObjectContext) as! Item
                item.noDeLettre = String(n)
                item.noMotcroise = grilleSelected
                item.lettre = lettres[n]
                item.completed = false
                DataController.sharedInstance.saveContext()
                n = n + 1
            }
        }else{
        n = 0
            for item in items {
                lettres[n] = item.lettre!
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

       fetchRequest.predicate = NSPredicate(format: "noMotcroise == %@", grilleSelected)
        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [Item]
        }catch let error as NSError{
            print("Error fetching items objects; \(error.localizedDescription), \(error.userInfo)")
        }
        DataController.sharedInstance.saveContext()
        super.viewDidAppear(animated)
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityIndicatorView.stopAnimating()
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")

        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
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
//MARK: Selecting a cell
////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      // After viewDid appear triggers once the event of deselecting initial cells from viewDidAppear
        if  indexPathInit == [0, 0] {
            let cell = collectionView.cellForItem(at: indexPathInit) as! MyCollectionViewCell
            wordSelection(cell: cell)
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()

            cell.backgroundColor = UIColor.clear
            indexPathInit = [0, 1]
           indiceCrash = indiceCrash + 1
        }
        if indexPathPrecedent != [] {
            if let cell = collectionView.cellForItem(at: indexPathPrecedent) as? MyCollectionViewCell{
                wordSelection(cell: cell)
                cell.laLettre.isUserInteractionEnabled = false
                cell.laLettre.resignFirstResponder()
                cell.backgroundColor = UIColor.clear
            }
       }
        let cell = cellSelection(indexPath: [0, indexPath.item ])
        cell.laLettre.becomeFirstResponder()
 
        cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: cell.laLettre.beginningOfDocument, to: cell.laLettre.endOfDocument)
        
        indexPathPrecedent = indexPath
        indexPathBack = [0, indexPath.item + 1]


        
    }
    
///////////////////////////////////
// MARK: Deselecting a cell
//////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPathPrecedent) as? MyCollectionViewCell{
            if cell.laLettre.text == "" {
                cell.laLettre.text = " "
            }
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        wordSelection(cell: cell)
        }
    }
/////////////////////////////////////////////////////////////////
// MARK: Moving the cursor to next letter after text has been entered
////////////////////////////////////////////////////////////////
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("isBackSpace")
            backSpacePressed = true
            if h {
                if indexPathBack == [] {indexPathBack = [0, 0]}
                    indexPathBack = [0, indexPathBack.item - 1]
                
            }else{
                ref = ref - 1
                
                for mot in totalMot {
                    if ref == Int(mot[5]){
                        if ref == 110 || ref == 120 || ref == 130 || ref == 140 || ref == 150 || ref == 160 || ref == 170 || ref == 180 || ref == 190 {
                            indexPathBack = [0, Int(mot[7])! + 89]
                        }else{
                            indexPathBack = [0, Int(mot[7])! - 10]
                        }
                    }
                }
 
            }

            if indexPathBack.item < 0 { indexPathBack = [0, 0]}
            if indexPathBack.item < 0 {
                backSpacePressed = false
                finDeCourse = true
            }
        }
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        var indexPath: IndexPath = [0, 0]
        if textField.text != "#" {
            if indexPathRef.item > 99 {indexPath = [0, 99] }
            if indexPathRef.item < 0 {indexPath = [0, 0]}

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
                cell.backgroundColor = UIColor.clear
                indexPathInit = [0, 1]
                indiceCrash = indiceCrash + 1
            }
            if h{
                if backSpacePressed{
                    var cell = collectionView.cellForItem(at: [0, indexPathBack.item ]) as! MyCollectionViewCell
                    cell.laLettre.text = " "
                    cell.laLettre.isUserInteractionEnabled = false
                    cell.laLettre.resignFirstResponder()
                    cell = collectionView.cellForItem(at: indexPathBack) as! MyCollectionViewCell
                    wordSelection(cell: cell)
                    indexPathRef  = indexPathBack
                    indexPathRef = [0, indexPathRef.item - 1]
                    if indexPathBack.item <= 0 {indexPathRef = [0, 0]}
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                    while cell.laLettre.text == "#" {
                        indexPathRef = [0, indexPathRef.item - 1]
                        if indexPathRef.item > 0 {
                            cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                        }else{
                            indexPathRef = [0, 0]
                            break
                        }
                    }
                    
                    if indexPathRef.item > -1 {
                        cell = cellSelection(indexPath: indexPathRef)
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)
                        indexPathPrecedent = [0, indexPathRef.item + 1]
                    }
                    backSpacePressed = false
                    indexPathBack = indexPathRef
                    
                }else{
                    indexPath = [0, indexPathRef.item - 1]
                    indexPathBack = indexPathRef
                    var cell = cellSelection(indexPath: indexPath)
                    wordSelection(cell: cell)
                    if finDeCourse{
                        indexPathRef = [0, 0]
                        finDeCourse = false
                    }
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                    while cell.laLettre.text == "#" {
                            indexPathRef = [0, indexPathRef.item + 1]
                        if indexPathRef.item != 100 {
                            cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell

                        }else{
                            indexPathRef = [0, 98]
                            cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                            break
                        }
                    }
                    if indexPathRef.item < 100 {
                
                        cell = cellSelection(indexPath: indexPathRef)
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)
                        indexPathBack = indexPathRef
                        indexPathPrecedent = [0, indexPathRef.item - 1]
                    }
                }
            }else{
                if indiceCrash == 1 {
                    ref = 100
                    indiceCrash = indiceCrash + 1
                }
                if backSpacePressed == true {
                    indexPath = indexPathBack
                    var cell = helperCellSelect(indexPath: indexPath)
                    wordSelection(cell: cell)
                    while cell.laLettre.text == "#" && ref > -1 {
                        indexPathBack = refVerticale(totalMot: totalMot, ref: ref, backSpacePressed: backSpacePressed)
                        cell = collectionView.cellForItem(at: indexPathBack) as! MyCollectionViewCell
                        ref = ref - 1
                    }
                    if indexPathPrecedent.item == 187 {indexPathPrecedent = [0, 88]}
                    if indexPathPrecedent.item == 186 {indexPathPrecedent = [0, 87]}
                    if indexPathPrecedent.item == 185 {indexPathPrecedent = [0, 86]}
                    if indexPathPrecedent.item == 184 {indexPathPrecedent = [0, 85]}
                    if indexPathPrecedent.item == 183 {indexPathPrecedent = [0, 84]}
                    if indexPathPrecedent.item == 182 {indexPathPrecedent = [0, 83]}
                    if indexPathPrecedent.item == 181 {indexPathPrecedent = [0, 82]}
                    if indexPathPrecedent.item == 180 {indexPathPrecedent = [0, 81]}
                    if indexPathPrecedent.item == 179 {indexPathPrecedent = [0, 80]}
                    cell = collectionView.cellForItem(at: [0, indexPathPrecedent.item ]) as! MyCollectionViewCell
                    cell.laLettre.text = " "
                    cell.laLettre.isUserInteractionEnabled = false
                    cell.laLettre.resignFirstResponder()
                    cell = collectionView.cellForItem(at: indexPathBack) as! MyCollectionViewCell
                    wordSelection(cell: cell)

                    indexPathPrecedent = movingVertical(cell: cell, totalMot: totalMot, indexPath: indexPathBack, backSpacePressed: backSpacePressed)
                    
                    if cell.laLettre.text != "#"{
                        ref = ref - 1
                        cell = cellSelection(indexPath: indexPathBack)
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)
                        for mot in totalMot {
                            if ref == Int(mot[5]){
                                if ref == 119 || ref == 129 || ref == 139 || ref == 149 || ref == 159 || ref == 169 || ref == 179 || ref == 189 || ref == 109 {
                                    indexPathPrecedent = [0, Int(mot[7])! + 89]
                                }else{
                                    indexPathPrecedent = indexPathBack
                                    indexPathBack = [0, Int(mot[7])! + 10 ]
                                    if indexPathBack.item > 100 {indexPathBack = [0, 99]}
                                }
                            }
                        }
                    }
                indexPath = indexPathBack
                backSpacePressed = false
                }else{
                    ref = ref - 1
                    indexPathRef = refVerticale(totalMot: totalMot, ref: ref, backSpacePressed: backSpacePressed)
                    indexPath = indexPathRef
                    var cell = cellSelection(indexPath: indexPath)
                    wordSelection(cell: cell)
                    cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                    indexPathRef = refVerticale(totalMot: totalMot, ref: ref, backSpacePressed: backSpacePressed)
                    while cell.laLettre.text == "#" && ref < 200 {
 
                        indexPathRef = refVerticale(totalMot: totalMot, ref: ref, backSpacePressed: backSpacePressed)
                        cell = collectionView.cellForItem(at: indexPathRef) as! MyCollectionViewCell
                        ref = ref + 1
                    }
                    if cell.laLettre.text != "#"{
                        cell = cellSelection(indexPath: indexPathRef)
                        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)
                        cell.laLettre.becomeFirstResponder()
                         indexPathPrecedent = movingVertical(cell: cell, totalMot: totalMot, indexPath: indexPathRef, backSpacePressed: backSpacePressed)
                    }
                }
            }
        }
// saving letter changedg
        var n = 0
        var cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        while n < 100 {
            cell = collectionView.cellForItem(at: [0, n]) as! MyCollectionViewCell
            items[n].lettre = cell.laLettre.text
            n = n + 1
        }

        let reponse = reponseACeMoment()
        let completeCheck = CompleteCheck(grilleSelected: grilleSelected)
        let resultat = completeCheck.completeCheck(reponse: reponse)
        if resultat.0 {
            for item in items{
                item.completed = true
            }
            showAlert()
        }
       DataController.sharedInstance.saveContext()
    }
/////////////////////////////////////////////////////////////////////////
//Compute the dimension of a cell for an NxN layout with space S between
// cells.  Take the collection view's width, subtract (N-1)*S points for
// the spaces between the cells, and then divide by N to find the final
// dimension for the cell's width and height.
/////////////////////////////////////////////////////////////////////////
   @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
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
                        cell.backgroundColor = UIColor.clear
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
                        cell.backgroundColor = UIColor.clear
                    }
                }
            }
            definitionH.text = totalMot[selectedCell][3]
            definitionV.text = totalMotV[3]
            let cell = helperCellSelect(indexPath: indexPath)
            cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)
            if h {
                indexPathRef = [0, indexPath.item + 1]
            
            }else{
                ref = ref + 1
                indexPathRef = refVerticale(totalMot: totalMot, ref: ref, backSpacePressed: backSpacePressed)
                indexPathBack = indexPathRef
               }
        }
       return cell
    }
//////////////////////////////////////////////////////////////
////// MARK: Function used when a cell is being selec
//////////////////////////////////////////////////////////
    func helperCellSelect(indexPath: IndexPath) -> MyCollectionViewCell {

        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        cell.laLettre.isUserInteractionEnabled = true
        cell.laLettre.becomeFirstResponder()
        cell.laLettre.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: cell.laLettre.beginningOfDocument, to: cell.laLettre.endOfDocument)
        return cell
    }
    //////////////////////////////////////////////////////////////
    //////MARK:  Function selectig word for each letter selected
    //////////////////////////////////////////////////////////
    func wordSelection(cell: MyCollectionViewCell) {
        if cell.laLettre.text != "#" {
            for select in selectedWordH{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.clear
                }
            }
            for select in selectedWordV{
                if let cell = collectionView.cellForItem(at: [0, select]) as? MyCollectionViewCell{
                    cell.backgroundColor = UIColor.clear
                }
            }
            cell.backgroundColor = UIColor.clear
        }
        cell.laLettre.isUserInteractionEnabled = false
        cell.laLettre.resignFirstResponder()
    }
    /////////////////////////////////////////////////////////////
    ///IndexSelection when in vertical orientation
    //////////////////////////////////////////////////////////
    func refVerticale(totalMot: [[String]], ref: Int, backSpacePressed: Bool) -> IndexPath {
        var indexPath: IndexPath = [0, 0]
        if backSpacePressed{
            let refV = ref - 1
            for mot in totalMot {
                if refV == Int(mot[5]){
                    indexPath = [0, Int(mot[7])!]
                }
            }
        }else{
            for mot in totalMot {
                if ref == Int(mot[5]){
                    indexPath = [0, Int(mot[7])!]
                }
            }
        }
        return indexPath
    }
    
    ///////////////////////////////////////////////////////////
    /// Moving cursor in vertical position
    ///////////////////////////////////////////////////////////
    func movingVertical(cell: MyCollectionViewCell, totalMot: [[String]], indexPath: IndexPath, backSpacePressed: Bool) -> IndexPath{
        if backSpacePressed{
            if cell.laLettre.text != "#"{
                 for mot in totalMot {
                    if ref == Int(mot[5]){
                        if ref == 119 || ref == 129 || ref == 139 || ref == 149 || ref == 159 || ref == 169 || ref == 179 || ref == 189 || ref == 109 {
                            indexPathPrecedent = [0, Int(mot[7])! + 89]
                        }else{
                            indexPathPrecedent = [0, Int(mot[7])! + 10]
                            if indexPathPrecedent.item > 99 {indexPathPrecedent = [0, 99]}
                        }
                        
                    }
                }
            }

        }else{
            if cell.laLettre.text != "#"{
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
        return indexPathPrecedent
    }
    
    
    
    func showAlert () {
        

        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Bravo, vous avez complété la grille!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    func dismissAlert(_ sender: UIAlertAction) {
        
    }
    func showAlert2 (){

        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Il n'y a pas d'erreur", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
    }
    func dismissAlert2(_ sender: UIAlertAction) {
        let cell = collectionView.cellForItem(at: [0, selectedCell]) as! MyCollectionViewCell
        cell.backgroundColor = UIColor.clear
    }
    func showAlert3 (){
        
        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Êtes vous sur de vouloir tout effacer?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.destructive, handler:{(alert: UIAlertAction!) in self.actionEffaceGrille()}))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    
  func dismissAlert3(_ sender: UIAlertAction) {
    
       
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
                    cell.backgroundColor = UIColor.clear
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
                    cell.backgroundColor = UIColor.clear
                }
            }
        }
        let cell = cellSelection(indexPath: indexPathSelected)
        indexPathBack = [0, indexPathSelected.item + 1]
        cell.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 255/255, alpha: 1.0)

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
            items[selectedCell].lettre = cell.laLettre.text
        }
        self.view.endEditing(true)
        DataController.sharedInstance.saveContext()
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
            items[lettre].lettre = cell.laLettre.text
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
            n = n + 1
        }
        DataController.sharedInstance.saveContext()
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
            items[Int(indexLettre[0])!].lettre = resultArray[n][1]
            cell.laLettre.isUserInteractionEnabled = false
            cell.laLettre.resignFirstResponder()
            n = n + 1
        }
        let grilleVerifie = result.0
        if grilleVerifie{
            showAlert2()
        }
        DataController.sharedInstance.saveContext()
    }
    @IBAction func effacerLaGrille(_ sender: UIButton) {
        showAlert3()
    }
    func actionEffaceGrille(){
            var n = 0
            for lettre in lettres {
            
                if lettre != "#"{
                    lettres[n] = " "
                }
                n = n + 1
            }
            n = 0
 
            n = 0
            while n < 100 {
                let cell = collectionView.cellForItem(at: [0 , n]) as! MyCollectionViewCell
                cell.laLettre.text = lettres[n]
                items[n].lettre = lettres[n]
                n = n + 1
            }
        for item in items{
            if item.noMotcroise == grilleSelected{
                item.completed = false
            }
        }

        stateOfMotsCroises = "Faites un essai!"
        UserDefaults.standard.set(stateOfMotsCroises, forKey: "stateOfMotsCroises")
        DataController.sharedInstance.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindDetailsMotsCroises" {
            let controller = segue.destination as! DetailMotsCroises
            controller.stateOfMotsCroises = stateOfMotsCroises
            controller.grilleSelected = grilleSelected
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.performSegue(withIdentifier: "unwindDetailsMotsCroises", sender: self)
        
    }

    @IBAction func hideKeyBoard(_ sender: Any) {
        self.view.endEditing(true)
        
    }
    
}

