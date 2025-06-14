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
    @IBOutlet weak var elapsedTimeLabel: SpecialLabel!
    @IBOutlet weak var defintionStackView: UIStackView!
    @IBOutlet weak var HVStackView: UIStackView!
    @IBOutlet weak var topDefinitionStackConstraint: NSLayoutConstraint!
   // var iPadIsInLandScape = false
    var keyBoardHeight = CGFloat()
    var collectionViewHeight = CGFloat()
    var effect: UIVisualEffect!
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    var blurEffectView = UIVisualEffectView()
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
    var keyBoardCGRecPlaceHolder = CGRect()
    var item: [Item]?
    var soundPlayer: SoundPlayer?
    var timer = Timer()
    var seconds = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        overrideUserInterfaceStyle = .light

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
        if let savedTime = UserDefaults.standard.object(forKey: grilleSelected) as? Int {
            seconds = savedTime
        }
        if !CoreDataHandler.isMotsCroisesFinished(noDeLettre: "0,0", grilleSelected: grilleSelected){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }else{
            updateTimer()
        }
            
        FormatAndHideButton.activate(buttonArray: validerItems)
        FormatAndHideButton.activate(buttonArray: revelerItems)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        view.backgroundColor = ColorReference.coralColor
        blurredView()
        self.activityIndicatorView = ActivityIndicatorView(title: "Construction de la Grille...", center: self.view.center, view: view)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        AppOrientationUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        elapsedTimeLabel.layer.borderWidth = 2.0
        elapsedTimeLabel.layer.borderColor = UIColor.black.cgColor
        elapsedTimeLabel.backgroundColor = ColorReference.sandColor
        elapsedTimeLabel.font = .systemFont(ofSize: 16)
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
        collectionViewConstraint = newConstraint
        noDeMotsCroisesLabel.text = "Mots Croisés: \(grilleSelected)"
        noDeMotsCroisesLabel.font = fonts.largeItaliqueBoldFont
        noDeMotsCroisesLabel.backgroundColor = ColorReference.coralColorLigh
        noDeMotsCroisesLabel.textColor = .white
        view.bringSubviewToFront(noDeMotsCroisesLabel)
        view.layoutIfNeeded()
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(seconds, forKey: grilleSelected)
        timer.invalidate()
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        var yPosition: CGFloat = 0
        var heightBackground: CGFloat = 0
        var gap: CGFloat = 0
        let line = CAShapeLayer()
        if keyBoardHeight + definitionLabel.frame.size.height > view.frame.size.width {
            self.collectionView.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: view.frame.size.width)
            yPosition = collectionView.frame.size.height
            heightBackground = self.keyBoardCGRecPlaceHolder.minY - yPosition
            gap = (heightBackground - defintionStackView.frame.size.height)/2 + 50
            line.path = UIBezierPath(roundedRect: CGRect(x: 2, y: self.keyBoardCGRecPlaceHolder.minY + 50, width: self.view.frame.width, height: 5), cornerRadius: 0).cgPath
            line.fillColor = ColorReference.sandColor.cgColor
            self.view.layer.addSublayer(line)
            let lineMaxY = self.keyBoardCGRecPlaceHolder.minY
            let sectionHeightMiddle = lineMaxY + (self.view.frame.maxY - lineMaxY)/2  -  self.validerButton.frame.height/2
            let iconeMinY = sectionHeightMiddle - self.collectionView.frame.maxY
            self.iconeStackViewConstraint.constant = iconeMinY * 0.3 + 10
        }else{
            yPosition = self.collectionView.frame.maxY
            heightBackground = self.keyBoardCGRec.minY - yPosition
            gap = abs(heightBackground - defintionStackView.frame.size.height)/2
            line.path = UIBezierPath(roundedRect: CGRect(x: 2, y: self.keyBoardCGRec.minY, width: self.view.frame.width, height: 5), cornerRadius: 0).cgPath
            line.fillColor = ColorReference.sandColor.cgColor
            self.view.layer.addSublayer(line)
            let lineMaxY = self.keyBoardCGRec.minY
            let sectionHeightMiddle = lineMaxY + (self.view.frame.maxY - lineMaxY)/2  -  self.validerButton.frame.height/2
            let iconeMinY = sectionHeightMiddle - self.collectionView.frame.maxY
            self.iconeStackViewConstraint.constant = iconeMinY * 0.3 + 30
        }
        defintionStackView.frame = CGRect(x: 0, y: yPosition + gap, width: defintionStackView.frame.size.width, height: defintionStackView.frame.size.height)
        moveRightButton.isEnabled = true
        self.view.layoutIfNeeded()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            let orientation = self.view.window?.windowScene?.interfaceOrientation
            if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
                if let viewController = self.navigationController?.viewControllers.first(where: { $0 is IndividulaGridSelectionTableViewController }) {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.navigationController?.popToViewController(viewController, animated: true)
                    }
                }
            }
        }
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
     //   SelectingCellColor.colorDeselected(wasHorizontal: wasHorizontal, collectionView: collectionView, indexPathSelected: wasIndexPathSelected, dimension: dimension)
        definition(indexPathSelected: indexPathSelected, isHorizontal: isHorizontal)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        wasHorizontal = boolStringTupple.0
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellChosen(indexPath: indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.laLettre.isUserInteractionEnabled = false
            cell.resignFirstResponder()
        }

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
        var dim = CGFloat()
        let cellsAcross  =  CGFloat(dimension + 1)
        let spaceBetweenCells: CGFloat = 0
        if keyBoardHeight + definitionLabel.frame.size.height < view.frame.size.width {
            dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        }else{
            dim = (view.frame.size.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        }
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
        helpUsed()
        MenuAction.activate(buttonArray: validerItems)

    }
    @IBAction func revelerPressed(_ sender: UIButton) {
        helpUsed()
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
      //  SelectingCellColor.colorDeselected(wasHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
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
        UserDefaults.standard.set(0, forKey: grilleSelected)
        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Êtes vous sur de vouloir tout effacer?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.destructive, handler:{(alert: UIAlertAction!) in self.actionEffaceGrille()}))
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    func showAlerteGrilleReussie () {
        UserDefaults.standard.set(seconds, forKey: grilleSelected)
        // Post notification so previous view can update (reload table)
        NotificationCenter.default.post(name: NSNotification.Name("GrilleTermineeNotification"), object: nil)
        let tempsPourReussir = UserDefaults.standard.integer(forKey: grilleSelected)
        let alert = UIAlertController(title: "Félicitations!", message: texteAlerteTerminé(), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        timer.invalidate()
        soundPlayer?.playSound(soundName: "music_harp_gliss_up", type: "wav")
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func actionEffaceGrille() {
        EffacerGrille.effacer(collectionView: collectionView, dimension: dimension, grilleSelected: grilleSelected)
        CoreDataHandler.saveUncompleteStatus(grilleSelected: grilleSelected)
        UserDefaults.standard.set(0, forKey: grilleSelected)
        let indiceMotsCroisesSelected = grilleSelected + "indice"
        UserDefaults.standard.set(false, forKey: indiceMotsCroisesSelected)
        seconds = 0
        let cell = cellChosen(indexPath: [0, 0])
        indexPathSelected = [0,0 ]
        collectionView.selectItem(at: indexPathSelected, animated: false, scrollPosition: .centeredHorizontally)
        let boolStringTupple = SelectingCellColor.colorSelected(isHorizontal: isHorizontal, collectionView: collectionView, indexPathSelected: indexPathSelected, dimension: dimension)
        wasHorizontal = boolStringTupple.0
        selectedWord = boolStringTupple.1
        selectedLettre = boolStringTupple.2
        pathArray = boolStringTupple.3
        cell.isSelected = true
        UserDefaults.standard.set(0, forKey: grilleSelected)
        seconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
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
    @objc func updateTimer() {
        if CoreDataHandler.isMotsCroisesFinished(noDeLettre: "0,0", grilleSelected: grilleSelected){
            UserDefaults.standard.set(seconds, forKey: grilleSelected)
            let tempsPourReussir = UserDefaults.standard.integer(forKey: grilleSelected)
            let minutes = (tempsPourReussir / 60) % 60
            let secondsToShow = tempsPourReussir % 60
            let resultat = String(format: "%02d:%02d", minutes, secondsToShow)
            elapsedTimeLabel.text = resultat
        }else{
            seconds += 1
            let minutes = (seconds / 60) % 60
            let secondsToShow = seconds % 60
            elapsedTimeLabel.text = String(format: "%02d:%02d", minutes, secondsToShow)
        }
    }
    func helpUsed() {
        let indiceMotsCroisesSelected = grilleSelected + "indice"
        UserDefaults.standard.set(true, forKey: indiceMotsCroisesSelected)
    }
    func texteAlerteTerminé() -> String {
        let indiceMotsCroisesSelected = grilleSelected + "indice"
        let minutes = seconds / 60
        let seconds = seconds % 60
        if UserDefaults.standard.bool(forKey: indiceMotsCroisesSelected){
            return "Vous avez complété la grille!\nÀ l'aide d'indices."
        }else{
            return "Vous avez complété la grille!\n Temps: \(String(format: "%02d:%02d", minutes, seconds))"
        }
    }
}


