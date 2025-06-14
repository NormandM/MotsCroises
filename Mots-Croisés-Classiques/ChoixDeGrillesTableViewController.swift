//
//  ChoixDeGrillesTableViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-02.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
import StoreKit

class ChoixDeGrillesTableViewController: UITableViewController,SKPaymentTransactionObserver {
    let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
    var restoreButton = UIButton()
    var labelHeaderView = UILabel()
    var grillesAchetées = String()
    var chosenIndexPath = IndexPath()
    var grillesChoisies = [String]()
    var imageViewArray = UIImageView()
    var arrayGrilleState = [[Bool]]()
    var arrayGrillesComment = [[String]]()
    var section = Int()
    var row = Int()
    let arraysSection = ["Facile", "Intermédiaire", "Intermédiaire +", "Avancé"]
    var isCompleted = false
    let fonts = FontsAndConstraintsOptions()
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    let placeHolderGrille = false
    var grille01a010 = UserDefaults.standard.bool(forKey: "grille01a010")
    var grille011a020 = UserDefaults.standard.bool(forKey: "grille011a020")
    var grille021a030 = UserDefaults.standard.bool(forKey: "grille021a030")
    var grille031a040 = UserDefaults.standard.bool(forKey: "grille031a040")
    var grille041a050 = UserDefaults.standard.bool(forKey: "grille041a050")
    var grille1a10 = UserDefaults.standard.bool(forKey: "grille1a10")
    var grille11a20 = UserDefaults.standard.bool(forKey: "grille11a20")
    var grille21a30 = UserDefaults.standard.bool(forKey: "grille21a30")
    var grille31a40 = UserDefaults.standard.bool(forKey: "grille31a40")
    var grille41a50 = UserDefaults.standard.bool(forKey: "grille41a50")
    var grille51a60 = UserDefaults.standard.bool(forKey: "grille51a60")
    var grille61a70 = UserDefaults.standard.bool(forKey: "grille61a70")
    var grille71a80 = UserDefaults.standard.bool(forKey: "grille71a80")
    var grille81a90 = UserDefaults.standard.bool(forKey: "grille81a90")
    var grille91a100 = UserDefaults.standard.bool(forKey: "grille91a100")
    var grille101a110 = UserDefaults.standard.bool(forKey: "grille101a110")
    var grille111a120 = UserDefaults.standard.bool(forKey: "grille111a120")
    var grille121a130 = UserDefaults.standard.bool(forKey: "grille121a130")
    var grille131a140 = UserDefaults.standard.bool(forKey: "grille131a140")
    var grille141a150 = UserDefaults.standard.bool(forKey: "grille141a150")
    var localizedPrice = String()
    var productIdentifiers = Set<String>()
    var iapProductsArray = [[SKProduct]]()
    var isPurchased = Bool() {
        didSet {
            if isPurchased{
                tableView.beginUpdates()
                let cell = tableView(tableView, cellForRowAt: chosenIndexPath) as! SpecialTableViewCell
                ImageManager.choosImage(imageView: cell.purchaseImageView, imageName: "achat10")
                cell.grilleLabel.text = grillesAchetées
                cell.imageLabel.text = ""
                self.tableView.reloadRows(at: [chosenIndexPath], with: .automatic)
                tableView.endUpdates()
                tableView.deselectRow(at: chosenIndexPath, animated: true)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        if currentCount >= 10 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(0, forKey: "launchCount")
            }
        }

       arrayGrillesComment = [["Cinq grilles gratuites", "Acheter Grilles 1 à 10", "Acheter Grilles 11 à 20", "Acheter Grilles 21 à 30", "Acheter Grilles 31 à 40", "Acheter Grilles 41 à 50"], ["Cinq grilles gratuites", "Acheter Grilles 1 à 10", "Acheter Grilles 11 à 20", "Acheter Grilles 21 à 30", "Acheter Grilles 31 à 40", "Acheter Grilles 41 à 50"], ["Cinq grilles gratuites", "Acheter Grilles 1 à 10", "Acheter Grilles 11 à 20", "Acheter Grilles 21 à 30", "Acheter Grilles 31 à 40", "Acheter Grilles 41 à 50"], ["Cinq grilles gratuites", "Acheter Grilles 1 à 10", "Acheter Grilles 11 à 20", "Acheter Grilles 21 à 30", "Acheter Grilles 31 à 40", "Acheter Grilles 41 à 50"]]

        arrayGrilleState = [[true, grille01a010, grille011a020, grille021a030, grille031a040, grille041a050], [true, grille1a10, grille11a20, grille21a30, grille31a40, grille41a50], [true, grille51a60, grille61a70, grille71a80, grille81a90, grille91a100], [true, grille101a110, grille111a120, grille121a130, grille131a140, grille141a150], [true, false , false , false , false , false]]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.title = "Choix des Mots Croisés"
        view.backgroundColor = ColorReference.sandColor
        restoreButtonPosition()
    }
    override func viewWillDisappear(_ animated: Bool) {
        restoreButton.removeFromSuperview()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        section = arraysSection.count
        return arraysSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        row = arrayGrillesComment[section].count
        return arrayGrillesComment[section].count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        labelHeaderView = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width/2, height: 50))
        labelHeaderView.font = fonts.largeItaliqueBoldFont
        labelHeaderView.textColor = ColorReference.sandColor
        labelHeaderView.textAlignment = .center
        labelHeaderView.backgroundColor = ColorReference.coralColorDark
        labelHeaderView.text = arraysSection[section]
        return labelHeaderView
    }
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height/18
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpecialTableViewCell
        let image = LabelAndImagePosition.place(indexPath: indexPath, arrayGrilleState: arrayGrilleState)
        cell.purchaseImageView.image = image
        cell.imageLabel.text = localizedPrice
        cell.imageLabel.textColor = .black
        cell.imageLabel.font = fonts.smallBoldFont
        cell.grilleLabel.text = arrayGrillesComment[indexPath.section][indexPath.row]
        cell.grilleLabel.font = fonts.normalFont
        cell.grilleLabel.textColor = .black
        if indexPath.row == 0 || arrayGrilleState[indexPath.section][indexPath.row]{ cell.imageLabel.text = ""}
        cell.backgroundColor = ColorReference.sandColor
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndexPath = indexPath
        switch indexPath {
        case [0, 0]:
            grillesChoisies = SelectionDesGrilles.grille1a5G
            performSegue(withIdentifier: "showGrillesChoisies", sender: self)
        case [0, 1]:
            grille01a010 = UserDefaults.standard.bool(forKey: "grille01a010")
            if grille01a010 {
                grillesChoisies = SelectionDesGrilles.grille01a010
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [0, 2]:
            grille011a020 = UserDefaults.standard.bool(forKey: "grille011a020")
            if grille011a020 {
                grillesChoisies = SelectionDesGrilles.grille011a020
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [0, 3]:
            grille021a030 = UserDefaults.standard.bool(forKey: "grille021a030")
            if grille021a030 {
                grillesChoisies = SelectionDesGrilles.grille021a030
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [0, 4]:
            grille031a040 = UserDefaults.standard.bool(forKey: "grille031a040")
            if grille031a040 {
                grillesChoisies = SelectionDesGrilles.grille031a040
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [0, 5]:
            grille041a050 = UserDefaults.standard.bool(forKey: "grille041a050")
            if grille041a050 {
                grillesChoisies = SelectionDesGrilles.grille041a050
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [1, 0]:
            grillesChoisies = SelectionDesGrilles.gille6a10G
            performSegue(withIdentifier: "showGrillesChoisies", sender: self)
        case [1, 1]:
            grille1a10 = UserDefaults.standard.bool(forKey: "grille1a10")
            /////////////
            grille1a10 = true
            ///////////
            if grille1a10 {
                grillesChoisies = SelectionDesGrilles.grille1a10
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
        case [1, 2]:
            grille11a20 = UserDefaults.standard.bool(forKey: "grille11a20")
            if grille11a20 {
                grillesChoisies = SelectionDesGrilles.grille11a20
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [1, 3]:
            grille21a30 = UserDefaults.standard.bool(forKey: "grille21a30")
            if grille21a30 {
                grillesChoisies = SelectionDesGrilles.grille21a30
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [1, 4]:
            grille31a40 = UserDefaults.standard.bool(forKey: "grille31a40")
            if grille31a40 {
                grillesChoisies = SelectionDesGrilles.grille31a40
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [1, 5]:
            grille41a50 = UserDefaults.standard.bool(forKey: "grille41a50")
            if grille41a50 {
                grillesChoisies = SelectionDesGrilles.grille41a50
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [2, 0]:
            grillesChoisies = SelectionDesGrilles.gille11a15G
            performSegue(withIdentifier: "showGrillesChoisies", sender: self)
        case [2, 1]:
            grille51a60 = UserDefaults.standard.bool(forKey: "grille51a60")
            if grille51a60 {
                grillesChoisies = SelectionDesGrilles.grille51a60
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [2, 2]:
            grille61a70 = UserDefaults.standard.bool(forKey: "grille61a70")
            if grille61a70 {
                grillesChoisies = SelectionDesGrilles.grille61a70
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [2, 3]:
            grille71a80 = UserDefaults.standard.bool(forKey: "grille71a80")
            if grille71a80 {
                grillesChoisies = SelectionDesGrilles.grille71a80
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [2, 4]:
            grille81a90 = UserDefaults.standard.bool(forKey: "grille81a90")
            if grille81a90 {
                grillesChoisies = SelectionDesGrilles.grille81a90
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
        case [2, 5]:
            grille91a100 = UserDefaults.standard.bool(forKey: "grille91a100")
            if grille91a100 {
                grillesChoisies = SelectionDesGrilles.grille91a100
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
        case [3,0]:
            grillesChoisies = SelectionDesGrilles.gille16Ga20G
            performSegue(withIdentifier: "showGrillesChoisies", sender: self)
        case [3,1]:
            grille101a110 = UserDefaults.standard.bool(forKey: "grille101a110")
            if grille101a110 {
                grillesChoisies = SelectionDesGrilles.grille101a110
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
            
        case [3,2]:
            grille111a120 = UserDefaults.standard.bool(forKey: "grille111a120")
            if grille111a120 {
                grillesChoisies = SelectionDesGrilles.grille111a120
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
            
        case [3,3]:
            grille121a130 = UserDefaults.standard.bool(forKey: "grille121a130")
            if grille121a130 {
                grillesChoisies = SelectionDesGrilles.grille121a130
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
               purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
        case [3,4]:
            grille131a140 = UserDefaults.standard.bool(forKey: "grille131a140")
            if grille131a140 {
                grillesChoisies = SelectionDesGrilles.grille131a140
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
            }
            
        case [3,5]:
            grille141a150 = UserDefaults.standard.bool(forKey: "grille141a150")
            if grille141a150 {
                grillesChoisies = SelectionDesGrilles.grille141a150
                performSegue(withIdentifier: "showGrillesChoisies", sender: self)
            }else{
                purchaseMyProduct(product: iapProductsArray[indexPath.section][indexPath.row])
           }
            
            
        default: print("default")
        }
        
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGrillesChoisies"{
            let controller = segue.destination as! IndividulaGridSelectionTableViewController
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            controller.grillesChoisies = grillesChoisies
            
        }
    }

    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
            // IAP Purchases dsabled on the Device
        } else {
            let alert = UIAlertController(title: "Mots Croisés Classiques", message: "L'option achat est désactivé sur votre appareil", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
         for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case.purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    switch productID{
                    case IAPProduct.D01.rawValue:
                        grille01a010 = true
                        UserDefaults.standard.set(grille01a010, forKey: "grille01a010")
                        grillesAchetées = "Grilles 1 à 10 achetées!"
                        isPurchased = true
                    case IAPProduct.D11.rawValue:
                        grille011a020 = true
                        UserDefaults.standard.set(grille011a020, forKey: "grille011a020")
                        grillesAchetées = "Grilles 11 à 20 achetées!"
                        isPurchased = true
                    case IAPProduct.D21.rawValue:
                        grille021a030 = true
                        UserDefaults.standard.set(grille021a030, forKey: "grille021a030")
                        grillesAchetées = "Grilles 21 à 30 achetées!"
                        isPurchased = true
                    case IAPProduct.D31.rawValue:
                        grille031a040 = true
                        UserDefaults.standard.set(grille031a040, forKey: "grille031a040")
                        grillesAchetées = "Grilles 31 à 40 achetées!"
                        isPurchased = true
                    case IAPProduct.D41.rawValue:
                        grille041a050 = true
                        UserDefaults.standard.set(grille041a050, forKey: "grille041a050")
                        grillesAchetées = "Grilles 41 à 50 achetées!"
                        isPurchased = true
                    case IAPProduct.I01.rawValue:
                        grille1a10 = true
                        UserDefaults.standard.set(grille1a10, forKey: "grille1a10")
                        grillesAchetées = "Grilles 1 à 10 achetées!"
                        isPurchased = true
                    case IAPProduct.I11.rawValue:
                        grille11a20 = true
                        UserDefaults.standard.set(grille11a20, forKey: "grille11a20")
                        grillesAchetées = "Grilles 11 à 20 achetées!"
                        isPurchased = true
                    case IAPProduct.I21.rawValue:
                        grille21a30 = true
                        UserDefaults.standard.set(grille21a30, forKey: "grille21a30")
                        grillesAchetées = "Grilles 21 à 30 achetées!"
                        isPurchased = true
                    case IAPProduct.I31.rawValue:
                        grille31a40 = true
                        UserDefaults.standard.set(grille31a40, forKey: "grille31a40")
                        grillesAchetées = "Grilles 31 à 40 achetées!"
                        isPurchased = true
                    case IAPProduct.I41.rawValue:
                        grille41a50 = true
                        UserDefaults.standard.set(grille41a50, forKey: "grille41a50")
                        grillesAchetées = "Grilles 41 à 50 achetées!"
                        isPurchased = true
                    case IAPProduct.E01.rawValue:
                        grille51a60 = true
                        UserDefaults.standard.set(grille51a60, forKey: "grille51a60")
                        grillesAchetées = "Grilles 1 à 10 achetées!"
                        isPurchased = true
                    case IAPProduct.E11.rawValue:
                        grille61a70 = true
                        UserDefaults.standard.set(grille61a70, forKey: "grille61a70")
                        grillesAchetées = "Grilles 11 à 20 achetées!"
                        isPurchased = true
                    case IAPProduct.E21.rawValue:
                        grille71a80 = true
                        UserDefaults.standard.set(grille71a80, forKey: "grille71a80")
                        grillesAchetées = "Grilles 21 à 30 achetées!"
                        isPurchased = true
                    case IAPProduct.E31.rawValue:
                        grille81a90 = true
                        UserDefaults.standard.set(grille81a90, forKey: "grille81a90")
                        grillesAchetées = "Grilles 31 à 40 achetées!"
                        isPurchased = true
                    case IAPProduct.E41.rawValue:
                        grille91a100 = true
                        UserDefaults.standard.set(grille91a100, forKey: "grille91a100")
                        grillesAchetées = "Grilles 41 à 50 achetées!"
                        isPurchased = true
                    case IAPProduct.AV01.rawValue:
                        grille101a110 = true
                        UserDefaults.standard.set(grille101a110, forKey: "grille101a110")
                        grillesAchetées = "Grilles 1 à 10 achetées!"
                        isPurchased = true
                    case IAPProduct.AV02.rawValue:
                        grille111a120 = true
                        UserDefaults.standard.set(grille111a120, forKey: "grille111a120")
                        grillesAchetées = "Grilles 11 à 20 achetées!"
                        isPurchased = true
                    case IAPProduct.AV03.rawValue:
                        grille121a130 = true
                        UserDefaults.standard.set(grille121a130, forKey: "grille121a130")
                        grillesAchetées = "Grilles 21 à 30 achetées!"
                        isPurchased = true
                    case IAPProduct.AV04.rawValue:
                        grille131a140 = true
                        UserDefaults.standard.set(grille131a140, forKey: "grille131a140")
                        grillesAchetées = "Grilles 31 à 40 achetées!"
                        isPurchased = true
                    case IAPProduct.AV05.rawValue:
                        grille141a150 = true
                        UserDefaults.standard.set(grille141a150, forKey: "grille141a150")
                        grillesAchetées = "Grilles 41 à 50 achetées!"
                        isPurchased = true
                    default: print("Did not find the product")
                        
                    }
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .purchasing: print("")
                case .restored: print("")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                case .deferred: print("")
                default: print("default")

                }
            }
        }
        arrayGrilleState = [[true, grille01a010, grille011a020, grille021a030, grille031a040, grille041a050], [true, grille1a10, grille11a20, grille21a30, grille31a40, grille41a50], [true, grille51a60, grille61a70, grille71a80, grille81a90, grille91a100],[true, grille101a110, grille111a120, grille121a130, grille131a140, grille141a150],[true, false, false, false, false, false]]
     }
    func restoreButtonPosition () {
        let yPosition = view.frame.height * 0.85
        let buttonWidth = view.frame.height * 0.1
        let xPosition = view.frame.width/2 - buttonWidth/2
        let buttonHeight = buttonWidth
        restoreButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight))
        restoreButton.layer.cornerRadius = restoreButton.frame.height/2
        restoreButton.backgroundColor = ColorReference.brownGray
        restoreButton.titleLabel?.textColor = UIColor.white
        let buttonText = """
        Rétablir
        les achats
        """
        restoreButton.titleLabel?.numberOfLines = 0
        restoreButton.titleLabel?.textAlignment = .center
        restoreButton.setTitle(buttonText, for: .normal)
        restoreButton.titleLabel?.font = fonts.smallBoldFont
        self.navigationController?.view.addSubview(restoreButton)
        restoreButton.addTarget(self, action: #selector(restoreButtonPushed), for: .touchUpInside)
    }
    @objc func restoreButtonPushed() {
        SKPaymentQueue.default().add(self)
        print("restore pushed")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let result = queue.transactions
        for results in result{
            let paimentId = results.payment.productIdentifier
            switch  paimentId{
            case IAPProduct.D01.rawValue:
                grille01a010 = true
                UserDefaults.standard.set(grille01a010, forKey: "grille01a010")
                grillesAchetées = "Grilles 1 à 10 achetées!"
                chosenIndexPath = [0, 1]
                isPurchased = true
            case IAPProduct.D11.rawValue:
                grille011a020 = true
                UserDefaults.standard.set(grille011a020, forKey: "grille011a020")
                grillesAchetées = "Grilles 11 à 20 achetées!"
                chosenIndexPath = [0, 2]
                isPurchased = true
            case IAPProduct.D21.rawValue:
                grille021a030 = true
                UserDefaults.standard.set(grille021a030, forKey: "grille021a030")
                grillesAchetées = "Grilles 21 à 30 achetées!"
                chosenIndexPath = [0, 3]
                isPurchased = true
            case IAPProduct.D31.rawValue:
                grille031a040 = true
                UserDefaults.standard.set(grille031a040, forKey: "grille031a040")
                grillesAchetées = "Grilles 31 à 40 achetées!"
                isPurchased = true
                chosenIndexPath = [0, 4]
            case IAPProduct.D41.rawValue:
                grille041a050 = true
                UserDefaults.standard.set(grille041a050, forKey: "grille041a050")
                grillesAchetées = "Grilles 41 à 50 achetées!"
                chosenIndexPath = [0, 5]
                isPurchased = true
            case IAPProduct.I01.rawValue:
                grille1a10 = true
                UserDefaults.standard.set(grille1a10, forKey: "grille1a10")
                grillesAchetées = "Grilles 1 à 10 achetées!"
                chosenIndexPath = [1, 1]
                isPurchased = true
            case IAPProduct.I11.rawValue:
                grille11a20 = true
                UserDefaults.standard.set(grille11a20, forKey: "grille11a20")
                grillesAchetées = "Grilles 11 à 20 achetées!"
                chosenIndexPath = [1, 2]
                isPurchased = true
            case IAPProduct.I21.rawValue:
                grille21a30 = true
                UserDefaults.standard.set(grille21a30, forKey: "grille21a30")
                grillesAchetées = "Grilles 21 à 30 achetées!"
                chosenIndexPath = [1, 3]
                isPurchased = true
            case IAPProduct.I31.rawValue:
                grille31a40 = true
                UserDefaults.standard.set(grille31a40, forKey: "grille31a40")
                grillesAchetées = "Grilles 31 à 40 achetées!"
                chosenIndexPath = [1, 4]
                isPurchased = true
            case IAPProduct.I41.rawValue:
                grille41a50 = true
                UserDefaults.standard.set(grille41a50, forKey: "grille41a50")
                grillesAchetées = "Grilles 41 à 50 achetées!"
                chosenIndexPath = [1, 5]
                isPurchased = true
            case IAPProduct.E01.rawValue:
                grille51a60 = true
                UserDefaults.standard.set(grille51a60, forKey: "grille51a60")
                grillesAchetées = "Grilles 1 à 10 achetées!"
                chosenIndexPath = [2, 1]
                isPurchased = true
            case IAPProduct.E11.rawValue:
                grille61a70 = true
                UserDefaults.standard.set(grille61a70, forKey: "grille61a70")
                grillesAchetées = "Grilles 11 à 20 achetées!"
                chosenIndexPath = [2, 2]
                isPurchased = true
            case IAPProduct.E21.rawValue:
                grille71a80 = true
                UserDefaults.standard.set(grille71a80, forKey: "grille71a80")
                grillesAchetées = "Grilles 21 à 30 achetées!"
                chosenIndexPath = [2, 3]
                isPurchased = true
            case IAPProduct.E31.rawValue:
                grille81a90 = true
                UserDefaults.standard.set(grille81a90, forKey: "grille81a90")
                grillesAchetées = "Grilles 31 à 40 achetées!"
                chosenIndexPath = [2, 4]
                isPurchased = true
            case IAPProduct.E41.rawValue:
                grille91a100 = true
                UserDefaults.standard.set(grille91a100, forKey: "grille91a100")
                grillesAchetées = "Grilles 41 à 50 achetées!"
                chosenIndexPath = [2, 5]
                isPurchased = true
            case IAPProduct.AV01.rawValue:
                grille101a110 = true
                UserDefaults.standard.set(grille101a110, forKey: "grille101a110")
                grillesAchetées = "Grilles 1 à 10 achetées!"
                chosenIndexPath = [3, 1]
                isPurchased = true
            case IAPProduct.AV02.rawValue:
                grille111a120 = true
                UserDefaults.standard.set(grille111a120, forKey: "grille111a120")
                grillesAchetées = "Grilles 11 à 20 achetées!"
                chosenIndexPath = [3, 2]
                isPurchased = true
            case IAPProduct.AV03.rawValue:
                grille121a130 = true
                UserDefaults.standard.set(grille121a130, forKey: "grille121a130")
                grillesAchetées = "Grilles 21 à 30 achetées!"
                chosenIndexPath = [3, 3]
                isPurchased = true
            case IAPProduct.AV04.rawValue:
                grille131a140 = true
                UserDefaults.standard.set(grille131a140, forKey: "grille131a140")
                grillesAchetées = "Grilles 31 à 40 achetées!"
                chosenIndexPath = [3, 4]
                isPurchased = true
                case IAPProduct.AV05.rawValue:
                grille141a150 = true
                UserDefaults.standard.set(grille141a150, forKey: "grille141a150")
                grillesAchetées = "Grilles 41 à 50 achetées!"
                chosenIndexPath = [3, 5]
                isPurchased = true
                
            default: print("Pas trouver le produit")
            }
        }
        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Vos achats ont été rétablis!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
