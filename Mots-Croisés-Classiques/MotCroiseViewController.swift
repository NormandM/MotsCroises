//
//  MotCroiseViewController.swift
//  MotsCroises2Dev
//
//  Created by Normand Martin on 2019-09-10.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation

class MotCroiseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var iconesStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var v1StackView: UIStackView!
    @IBOutlet weak var v2StackView: UIStackView!
    @IBOutlet weak var topDefinitionLabelConstraints: NSLayoutConstraint!
    @IBOutlet weak var iconeStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var horizontalVerticalButton2: UIButton!
    @IBOutlet var validerItems: [UIButton]!
    @IBOutlet var revelerItems: [UIButton]!
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var revelerButton: UIButton!
    @IBOutlet weak var effacerButton: UIButton!
    @IBOutlet weak var moveLeftButton: UIButton!
    @IBOutlet weak var moveRightButton: UIButton!
    @IBOutlet weak var definitionLabel: SpecialLabel!
    @IBOutlet weak var pointInterrogation: UIButton!
    @IBOutlet weak var horizOrVertLabel: UILabel!
    @IBOutlet weak var noDeMotsCroisesLabel: UILabel!
    
    @IBOutlet weak var topHorVertToCollectionViewConstraint: NSLayoutConstraint!
    var effect: UIVisualEffect!
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    var blurEffectView = UIVisualEffectView()
    var motsCroisesSelected = String()
    var dimension = Int()
    var activityIndicatorView: ActivityIndicatorView!
    var keyBoardIsHidden = Bool()
    var isHorizontal = true
    var wasHorizontal = false
    var selectedWord = [String]()
    var selectedLettre = String()
    var pathArray = [IndexPath]()
    var wasIndexPathSelected = IndexPath()
    var indexPathSelected = IndexPath()
    var grille = [[String]]()
    var definitions = [[[String]]]()
    let fonts = FontsAndConstraintsOptions()
    var lettres: [String] = []
    var keyBoardCGRec = CGRect()
    var grilleSelected = String()
    var item: [Item]?
    var soundPlayer: SoundPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                // prefer a light interface style with this:
                overrideUserInterfaceStyle = .light
        }
        soundPlayer = SoundPlayer()
        let pListLettres = "Lettres" + grilleSelected
        let pListDefinitions = "Definitions" + grilleSelected
        if let plistPath = Bundle.main.path(forResource: pListLettres, ofType: "plist"),
            let motCr = NSArray(contentsOfFile: plistPath){
            grille = motCr as! [[String]]
        }
        if let plistPath = Bundle.main.path(forResource: pListDefinitions, ofType: "plist"),
            let def = NSArray(contentsOfFile: plistPath){
            definitions = def as! [[[String]]]
        }
        dimension = grille.count - 1
        var item = CoreDataHandler.fetchGrille(grilleSelected: grilleSelected)
        if item == [] {
            GrilleData.prepareGrille(dimension: dimension, item:item!, grilleSelected: grilleSelected, grille: grille)
            item = CoreDataHandler.fetchGrille(grilleSelected: grilleSelected)
        }

        FormatAndHideButton.activate(buttonArray: validerItems)
        FormatAndHideButton.activate(buttonArray: revelerItems)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)

        view.backgroundColor = ColorReference.coralColor
        blurredView()
        self.activityIndicatorView = ActivityIndicatorView(title: "Construction de la Grille...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        moveLeftButton.setImage(UIImage(named: "leftTriangleG3.png"), for: .normal)
        moveRightButton.setImage(UIImage(named: "rightTriangleG3.png"), for: .normal)
        definitionLabel.font = fonts.smallItaliqueBoldFont
        definitionLabel.backgroundColor = ColorReference.brownGray
        definitionLabel.textColor = .white
        definitionLabel.numberOfLines = 0
        definitionLabel.lineBreakMode = .byWordWrapping
        horizOrVertLabel.font = fonts.largeBoldFont
        horizOrVertLabel.backgroundColor = ColorReference.brownGray
        horizOrVertLabel.textColor = .white
        horizOrVertLabel.textAlignment = .center
        pointInterrogation.titleLabel?.font = fonts.largeFont
        let newConstraint = collectionViewConstraint.constraintWithMultiplier(fonts.multiplierConstraint)
        view.removeConstraint(collectionViewConstraint)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        collectionViewConstraint = newConstraint
        noDeMotsCroisesLabel.text = "Mots Croisés: \(grilleSelected)"
        noDeMotsCroisesLabel.font = fonts.largeItaliqueBoldFont
        noDeMotsCroisesLabel.backgroundColor = ColorReference.coralColorVDardk
        noDeMotsCroisesLabel.textColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        let cell = cellChosen(indexPath: [0, 0])
        indexPathSelected = [0,0 ]
        collectionView.selectItem(at: indexPathSelected, animated: false, scrollPosition: .centeredHorizontally)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        wasHorizontal = boolStringTupple.0
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        cell.isSelected = true
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
        wasIndexPathSelected = indexPathSelected
        let yPosition = collectionView.frame.maxY
        let heightBackground = keyBoardCGRec.minY - yPosition
        topDefinitionLabelConstraints.constant = heightBackground/2  - definitionLabel.frame.height/2
        topHorVertToCollectionViewConstraint.constant = heightBackground/2  - horizOrVertLabel.frame.height/2
        let line = CAShapeLayer()
        line.path = UIBezierPath(roundedRect: CGRect(x: 0, y: keyBoardCGRec.minY, width: view.frame.width, height: 5), cornerRadius: 0).cgPath
        line.fillColor = ColorReference.sandColor.cgColor
        view.layer.addSublayer(line)
        let lineMaxY = keyBoardCGRec.minY
        let sectionHeightMiddle = lineMaxY + (view.frame.maxY - lineMaxY)/2  -  validerButton.frame.height/2
        let iconeMinY = sectionHeightMiddle - collectionView.frame.maxY
        iconeStackViewConstraint.constant = iconeMinY * 0.7
        view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: Notification for keyboard
    @objc func keyBoardWillShow(notification: Notification) {
        guard let keyBoardRec = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        keyBoardCGRec = keyBoardRec
        keyBoardIsHidden = false
    }
    @objc func keyboardWillHide (_ notification: Notification){
        keyBoardIsHidden = true
    }
    @objc func keyBoardDidShow() {
        activityIndicatorView.stopAnimating()
        blurEffectView.removeFromSuperview()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return grille.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grille[0].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MotsCroisesCVCell
        cell.backgroundColor = ColorReference.sandColor
        cell.laLettre.text = grille[indexPath.section][indexPath.item]
        cell.laLettre.font = fonts.normalItaliqueFont
        cell.laLettre.textColor = .black
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        if cell.laLettre.text == "#" {
            cell.backgroundColor = UIColor.black
            cell.laLettre.backgroundColor = UIColor.black
            cell.isUserInteractionEnabled = false
        }else{
           cell.laLettre.text = CoreDataHandler.fetchLetters(noDeLettre: "\(indexPath.section),\(indexPath.item)", grilleSelected: grilleSelected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathSelected = indexPath
        SelectingCellColor.colorDeselected(wasHorizontal: wasHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        wasHorizontal = boolStringTupple.0
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellChosen(indexPath: indexPath)
        cell.laLettre.isUserInteractionEnabled = false
        cell.resignFirstResponder()
        SelectingCellColor.colorDeselected(wasHorizontal: wasHorizontal, collectionView: collectionView, indexPathSelected: indexPath, dimension: dimension)
    }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = cellChosen(indexPath: indexPathSelected)
        cell.laLettre.text = string.stripOfAccent()
        guard let char = string.cString(using: String.Encoding.utf8) else {
            return false
        }
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            wasIndexPathSelected = indexPathSelected
            gridMoveSimple(scrollH: Scrolling.moveHorizontalLeft(indexPath:dimension:), scrollV: Scrolling.moveVerticalUp(indexPath:dimension:))
            let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
            selectedWord = boolStringTupple.1
            selectedLettre = boolStringTupple.2
            pathArray = boolStringTupple.3
            let cell = cellChosen(indexPath: indexPathSelected)
            cell.laLettre.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.laLettre.selectedTextRange = cell.laLettre.textRange(from: cell.laLettre.beginningOfDocument, to: cell.laLettre.endOfDocument)
            definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
            let noDeLettre = IndexPathToString.convert(indexPath: indexPathSelected)
            CoreDataHandler.fetchItemSaveLetter(noDeLettre: noDeLettre, newLetter: string, grilleSelected: grilleSelected)
        }else{
            gridMove(scrollH: Scrolling.moveHorizontalRight(indexPath:dimension:), scrollV: Scrolling.moveVerticalDown(indexPath:dimension:))
            SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
            let noDeLettre = IndexPathToString.convert(indexPath: wasIndexPathSelected)
            CoreDataHandler.fetchItemSaveLetter(noDeLettre: noDeLettre, newLetter: string, grilleSelected: grilleSelected)
            let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
            selectedWord = boolStringTupple.1
            selectedLettre = boolStringTupple.2
            pathArray = boolStringTupple.3
            definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
            let gridUser = GrilleUser.write(dimension: dimension, collectionView: collectionView)
            let indexPathforErrors = Valider.grille(grilleUser: gridUser, grille: grille, dimension: dimension)
            if indexPathforErrors == [] {
                showAlerteGrilleReussie()
                CoreDataHandler.saveCompletedStatus(grilleSelected: grilleSelected)
            }
        }

        return true
    }
    /////////////////////////////////////////////////////////////////////////
    //Compute the dimension of a cell for an NxN layout with space S between
    // cells.  Take the collection view's width, subtract (N-1)*S points for
    // the spaces between the cells, and then divide by N to find the final
    // dimension for the cell's width and height.
    /////////////////////////////////////////////////////////////////////////
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellsAcross  =  CGFloat(dimension + 1)
        let spaceBetweenCells: CGFloat = 0
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
        let cell = cellChosen(indexPath: indexPathSelected)
        cell.laLettre.text = " "
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3

    }
    
    func cellChosen(indexPath: IndexPath) -> MotsCroisesCVCell{
        return collectionView.cellForItem(at: indexPath) as! MotsCroisesCVCell
    }
    @IBAction func validerPressed(_ sender: UIButton) {
        MenuAction.activate(buttonArray: validerItems)

    }
    @IBAction func revelerPressed(_ sender: UIButton) {
        MenuAction.activate(buttonArray: revelerItems)
    }
    @IBAction func validerItemPressed(_ sender: UIButton) {
        if let validerButtonTitle = sender.titleLabel?.text{
            switch  validerButtonTitle{
            case ButtonTitle.Lettre.rawValue:
                let isGood = Valider.laLettre(indexPathSelected: indexPathSelected, lettre: selectedLettre, grille: grille)
                if isGood {
                    showAlertNoError()
                }else{
                    let cell = cellChosen(indexPath: indexPathSelected)
                    cell.backgroundColor = ColorReference.specialRed
                }
            case ButtonTitle.Mot.rawValue:
                let indexPathforErrors = Valider.leMot(indexPathSelected: indexPathSelected, selectedMot: selectedWord, definitions: definitions, isHorizontal: isHorizontal, pathArray: pathArray)
                if indexPathforErrors == [] {
                    showAlertNoError()
                }else{
                    for indexPath in indexPathforErrors {
                        let cell = cellChosen(indexPath: indexPath)
                        cell.backgroundColor = ColorReference.specialRed
                    }
                }
            case ButtonTitle.Grille.rawValue:
                let grilleUser = GrilleUser.write(dimension: dimension, collectionView: collectionView)
                let indexPathForError = Valider.grille(grilleUser: grilleUser, grille: grille, dimension: dimension)
                for indexPath in indexPathForError {
                    let cell = cellChosen(indexPath: indexPath)
                    cell.backgroundColor = ColorReference.specialRed
                }
            default:
                return
            }
        }
        MenuAction.activate(buttonArray: validerItems)
    }
    @IBAction func revelerItemPressed(_ sender: UIButton) {
        let reveler = Reveler(collectionView: collectionView, indexPathSelected: indexPathSelected, noMotcroise: grilleSelected)
        if let revelerButtonTitle = sender.titleLabel?.text{
            switch  revelerButtonTitle{
            case ButtonTitle.Lettre.rawValue:
                let isGood = reveler.laLettre(lettre: selectedLettre, grille: grille)
                let gridUser = GrilleUser.write(dimension: dimension, collectionView: collectionView)
                let indexPathforErrors = Valider.grille(grilleUser: gridUser, grille: grille, dimension: dimension)
                if isGood && indexPathforErrors == []{
                    showAlerteGrilleReussie()
                    CoreDataHandler.saveCompletedStatus(grilleSelected: grilleSelected)
                }else if isGood{
                    showAlertNoError()
                }
            case ButtonTitle.Mot.rawValue:
                let isGood = reveler.leMot(selectedMot: selectedWord, definitions: definitions, isHorizontal: isHorizontal, pathArray: pathArray, dimension: dimension)
                let gridUser = GrilleUser.write(dimension: dimension, collectionView: collectionView)
                let indexPathforErrors = Valider.grille(grilleUser: gridUser, grille: grille, dimension: dimension)
                if isGood && indexPathforErrors == []{
                    showAlerteGrilleReussie()
                    CoreDataHandler.saveCompletedStatus(grilleSelected: grilleSelected)
                }else if isGood{
                    showAlertNoError()
                }

            case ButtonTitle.Grille.rawValue:
                let grilleUser = GrilleUser.write(dimension: dimension, collectionView: collectionView)
                _ = reveler.grille(grilleUser: grilleUser, grille: grille, dimension: dimension)
                showAlerteGrilleReussie()
                CoreDataHandler.saveCompletedStatus(grilleSelected: grilleSelected)
            default:
                return
            }
        }
        MenuAction.activate(buttonArray: revelerItems)
    }
    @IBAction func effacerPressed(_ sender: UIButton) {
        showAlertEffacerGrille ()
    }
    @IBAction func pointPressed(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func horizontalVericalPressed(_ sender: UIButton) {
        SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        isHorizontal = !isHorizontal
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        wasHorizontal = isHorizontal
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
    }
    @IBAction func moveRightPressed(_ sender: UIButton) {
        gridMoveSimple(scrollH: Scrolling.moveHorizontalRight(indexPath:dimension:), scrollV: Scrolling.moveVerticalDown(indexPath:dimension:))
        SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
    }
    @IBAction func moveLeftPressed(_ sender: UIButton) {
        gridMoveSimple(scrollH: Scrolling.moveHorizontalLeft(indexPath:dimension:), scrollV: Scrolling.moveVerticalUp(indexPath:dimension:))
        SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
    }
    // MARK: - Navigation
    @IBAction func goBackToGridList(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "backToGridSelection", sender: self)
    }
    
    
    
    func gridMove (scrollH: (IndexPath, Int) -> IndexPath, scrollV: (IndexPath, Int) -> IndexPath){
        var cell = cellChosen(indexPath: indexPathSelected)
        var newIndexPath =  IndexPath()
        wasIndexPathSelected = indexPathSelected
        cell.backgroundColor = ColorReference.sandColor
        var count = 0
        var isThereBlankCase = false
        for n in 0...dimension {
            for m in 0...dimension {
                
                let cell = collectionView.cellForItem(at: [n, m]) as! MotsCroisesCVCell
                if cell.laLettre.text == "" || cell.laLettre.text == " " {
                    count = count + 1
                }
                if count >= 1 { isThereBlankCase = true}
            }
        }
        if isThereBlankCase {
            if isHorizontal {
                newIndexPath = scrollH(indexPathSelected, dimension)
                cell = cellChosen(indexPath: newIndexPath)
                while cell.laLettre.text != " " &&  cell.laLettre.text != ""{
                    newIndexPath = scrollH(newIndexPath, dimension)
                    cell = cellChosen(indexPath: newIndexPath)
                }
            }else{
                newIndexPath = scrollV(indexPathSelected, dimension)
                cell = cellChosen(indexPath: newIndexPath)
                while cell.laLettre.text != " " &&  cell.laLettre.text != "" {
                    newIndexPath = scrollV(newIndexPath, dimension)
                    cell = cellChosen(indexPath: newIndexPath)
                }
            }
            SelectingTextField.selectBegin(cell: cell)
            indexPathSelected = newIndexPath
            collectionView.selectItem(at: indexPathSelected, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    func gridMoveSimple(scrollH: (IndexPath, Int) -> IndexPath, scrollV: (IndexPath, Int) -> IndexPath) {
        var cell = cellChosen(indexPath: indexPathSelected)
        var newIndexPath =  IndexPath()
        wasIndexPathSelected = indexPathSelected
        cell.backgroundColor = ColorReference.sandColor
        if isHorizontal {
            newIndexPath = scrollH(indexPathSelected, dimension)
            cell = cellChosen(indexPath: newIndexPath)
            while cell.laLettre.text == "#"{
                newIndexPath = scrollH(newIndexPath, dimension)
                cell = cellChosen(indexPath: newIndexPath)
            }
        }else{
            newIndexPath = scrollV(indexPathSelected, dimension)
            cell = cellChosen(indexPath: newIndexPath)
            while cell.laLettre.text == "#" {
                newIndexPath = scrollV(newIndexPath, dimension)
                cell = cellChosen(indexPath: newIndexPath)
            }
        }
        SelectingTextField.selectBegin(cell: cell)
        indexPathSelected = newIndexPath
        collectionView.selectItem(at: indexPathSelected, animated: false, scrollPosition: .centeredHorizontally)

    }
    func definition(indexPathSelected: IndexPath, isHorizontal: Bool) {

        if isHorizontal {
            horizOrVertLabel.text = "H:"
            let trimmedString = "\(definitions[indexPathSelected.section][indexPathSelected.item][0])".trimmingCharacters(in: .whitespaces)
            definitionLabel.text = trimmedString
        }else{
            horizOrVertLabel.text = "V:"
            let trimmedString = "\(definitions[indexPathSelected.section][indexPathSelected.item][1])".trimmingCharacters(in: .whitespaces)
            definitionLabel.text = trimmedString
        }
    }
    func showAlertNoError () {
        let alert = UIAlertController(title: "Il n'y a pas d'erreur", message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertEffacerGrille (){
        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Êtes vous sur de vouloir tout effacer?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.destructive, handler:{(alert: UIAlertAction!) in self.actionEffaceGrille()}))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlerteGrilleReussie () {
        let alert = UIAlertController(title: "Félicitations!", message: "Vous avez complété la grille!", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        soundPlayer?.playSound(soundName: "music_harp_gliss_up", type: "wav")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func actionEffaceGrille() {
        EffacerGrille.effacer(collectionView: collectionView, dimension: dimension, grilleSelected: grilleSelected)
        CoreDataHandler.saveUncompleteStatus(grilleSelected: grilleSelected)
        let cell = cellChosen(indexPath: [0, 0])
        indexPathSelected = [0,0 ]
        collectionView.selectItem(at: indexPathSelected, animated: false, scrollPosition: .centeredHorizontally)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        wasHorizontal = boolStringTupple.0
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        cell.isSelected = true
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
    }
    func blurredView() {
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effect = blurEffectView.effect
        effect = blurEffectView.effect
        view.addSubview(blurEffectView)
    }

}


