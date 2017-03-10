//
//  choixDeGrilesViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-03-01.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit
import StoreKit



class choixDeGrilesViewController: UIViewController, SKProductsRequestDelegate,SKPaymentTransactionObserver {
    var arrayGrillesChoisis: [String] = []
    
    @IBOutlet weak var centerxGrille: NSLayoutConstraint!
    @IBOutlet weak var grillesGratuites: UIImageView!
    @IBOutlet weak var grilles1a10: UIImageView!
    @IBOutlet weak var grilles11a20: UIImageView!
    @IBOutlet weak var grilles21a30: UIImageView!
    @IBOutlet weak var grilles31a40: UIImageView!
    @IBOutlet weak var grilles41a50: UIImageView!
    
    @IBOutlet weak var retablir: UIButton!
    @IBOutlet weak var achat1a10: UIButton!
    @IBOutlet weak var achat11a20: UIButton!
    @IBOutlet weak var achat21a30: UIButton!
    @IBOutlet weak var achat31a40: UIButton!
    @IBOutlet weak var achat41a50: UIButton!
    @IBOutlet weak var label1a10: UILabel!
    @IBOutlet weak var lable11a20: UILabel!
    @IBOutlet weak var lablel21a30: UILabel!
    @IBOutlet weak var lablel31a40: UILabel!
    @IBOutlet weak var lable41a50: UILabel!

    
    let GRILLES_PRODUCT_ID1a10 = "NM.MotsCroises1a10"
    let GRILLES_PRODUCT_ID11a20 = "NM.MotsCroises11a20"
    let GRILLES_PRODUCT_ID21a30 = "NM.MotsCroises21a30"
    let GRILLES_PRODUCT_ID31a40 = "NM.MotsCroises31a30"
    let GRILLES_PRODUCT_ID41a50 = "NM.MotsCroises41a50"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var grille1a10 = UserDefaults.standard.bool(forKey: "grille1a10")
    var grille11a20 = UserDefaults.standard.bool(forKey: "grille11a20")
    var grille21a30 = UserDefaults.standard.bool(forKey: "grille21a30")
    var grille31a40 = UserDefaults.standard.bool(forKey: "grille31a40")
    var grille41a50 = UserDefaults.standard.bool(forKey: "grille41a50")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let modelName = UIDevice.current.modelName
        self.title = "Choix de Grilles"

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "grungyPaper")!)
        achat1a10.titleLabel?.textAlignment = NSTextAlignment.center
        achat1a10.layer.cornerRadius = 10
        achat1a10.layer.borderColor = UIColor.black.cgColor
        achat1a10.layer.borderWidth = 2
        achat11a20.titleLabel?.textAlignment = NSTextAlignment.center
        achat11a20.layer.cornerRadius = 10
        achat11a20.layer.borderColor = UIColor.black.cgColor
        achat11a20.layer.borderWidth = 2
        achat21a30.titleLabel?.textAlignment = NSTextAlignment.center
        achat21a30.layer.cornerRadius = 10
        achat21a30.layer.borderColor = UIColor.black.cgColor
        achat21a30.layer.borderWidth = 2
        achat31a40.titleLabel?.textAlignment = NSTextAlignment.center
        achat31a40.layer.cornerRadius = 10
        achat31a40.layer.borderColor = UIColor.black.cgColor
        achat31a40.layer.borderWidth = 2
        achat41a50.titleLabel?.textAlignment = NSTextAlignment.center
        achat41a50.layer.cornerRadius = 10
        achat41a50.layer.borderColor = UIColor.black.cgColor
        achat41a50.layer.borderWidth = 2
        retablir.layer.cornerRadius = 10
        retablir.layer.borderColor = UIColor.black.cgColor
        retablir.layer.borderWidth = 2
        
        if modelName == "iPad 2" || modelName == "iPad 3" || modelName == "iPad 4" || modelName == "iPad Air" || modelName == "iPad Air 2" || modelName == "iPad Pro" {
            centerxGrille.constant = 240
        }

        if grille1a10 {
            achat1a10.isHidden = true
            grilles1a10.isHidden = false
            label1a10.text = "Grilles 1 à 10 achetées!"
        }
        if grille11a20{
            achat11a20.isHidden = true
            grilles11a20.isHidden = false
            lable11a20.text = "Grilles 11 à 20 achetées!"
            
        }
        if grille21a30{
            achat21a30.isHidden = true
            grilles21a30.isHidden = false
            lablel21a30.text = "Grilles 21 à 30 achetées!"
        }
        if grille31a40{
            achat31a40.isHidden = true
            grilles31a40.isHidden = false
            lablel31a40.text = "Grilles 31 à 40 achetées!"
        }
        if grille41a50{
            achat41a50.isHidden = true
            grilles41a50.isHidden = false
            lable41a50.text = "Grilles 41 à 50 achetées!"
        }
        fetchAvailableProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grilleGratuite(_ sender: Any) {
        arrayGrillesChoisis = ["a", "b", "c"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grilleGratuite)
    }
    @IBAction func grille1a10(_ sender: Any) {
        arrayGrillesChoisis = ["1", "2", "3", "4", "5", "6" ,"7", "8", "9", "10"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille1a10)
    }
    @IBAction func grille11a20(_ sender: Any) {
        arrayGrillesChoisis = ["11", "12", "13", "14", "15", "16" ,"17", "18", "19", "20"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille11a20)
    }
    @IBAction func grille21a30(_ sender: Any) {
        arrayGrillesChoisis = ["21", "22", "23", "24", "25", "26" ,"27", "28", "29", "30"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille21a30)
    }
    @IBAction func grille31a40(_ sender: Any) {
        arrayGrillesChoisis = ["31", "32", "33", "34", "35", "36" ,"37", "38", "39", "40"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille31a40)
    }
    
    @IBAction func grille41a50(_ sender: Any) {
        arrayGrillesChoisis = ["41", "42", "43", "44", "45", "46" ,"47", "48", "49", "50"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille41a50)
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMotsCroises"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            let controller = segue.destination as! DetailMotsCroises
            controller.arrayGrillesChoisis = arrayGrillesChoisis
        }
     }
    
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:  GRILLES_PRODUCT_ID1a10, GRILLES_PRODUCT_ID11a20, GRILLES_PRODUCT_ID21a30, GRILLES_PRODUCT_ID31a40, GRILLES_PRODUCT_ID41a50)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            
            // Product (Non-Consumable) ------------------------------
            var prod1a10: SKProduct = response.products[0] as SKProduct
            var prod11a20: SKProduct = response.products[0] as SKProduct
            var prod21a30: SKProduct = response.products[0] as SKProduct
            var prod31a40: SKProduct = response.products[0] as SKProduct
            var prod41a50: SKProduct = response.products[0] as SKProduct
            
            var n = 0
            while n < 5 {
                if (response.products[n] as SKProduct).localizedDescription == "Grilles 1 à 10" {
                    prod1a10 = response.products[n] as SKProduct
                    iapProducts[0] = response.products[n]
                }
                if (response.products[n] as SKProduct).localizedDescription == "Grilles 11 à 20" {
                    prod11a20 = response.products[n] as SKProduct
                    iapProducts[1] = response.products[n]
                }
                if (response.products[n] as SKProduct).localizedDescription == "Grilles 21 à 30" {
                    prod21a30 = response.products[n] as SKProduct
                    iapProducts[2] = response.products[n]
                }
                if (response.products[n] as SKProduct).localizedDescription == "Grilles 31 à 40" {
                    prod31a40 = response.products[n] as SKProduct
                    iapProducts[3] = response.products[n]
                }
                if (response.products[n] as SKProduct).localizedDescription == "Grilles 41 à 50" {
                    prod41a50 = response.products[n] as SKProduct
                    iapProducts[4] = response.products[n]
                }
                n = n + 1
            }

            
            // Get its price from iTunes Connect
            numberFormatter.locale = prod1a10.priceLocale
            let price1a10 = numberFormatter.string(from: prod1a10.price)
            let price11a20 = numberFormatter.string(from: prod11a20.price)
            let price21a30 = numberFormatter.string(from: prod21a30.price)
            let price31a40 = numberFormatter.string(from: prod31a40.price)
            let price41a50 = numberFormatter.string(from: prod41a50.price)
            
            // Show its description
            achat1a10.titleLabel?.text = "Acheter \(price1a10!)!"
            achat11a20.titleLabel?.text = "Acheter \(price11a20!)!"
            achat21a30.titleLabel?.text = "Acheter \(price21a30!)!"
            achat31a40.titleLabel?.text = "Acheter \(price31a40!)!"
            achat41a50.titleLabel?.text = "Acheter \(price41a50!)!"
            // ------------------------------------
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
            let alert = UIAlertController(title: "Mots Croisés Classiques", message: "L'option achat est désactivé sur votre appareil", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if productID == GRILLES_PRODUCT_ID1a10 {
                        
                        // Save your purchase locally (needed only for Non-Consumable IAP)
                        grille1a10 = true
                        UserDefaults.standard.set(grille1a10, forKey: "grille1a10")
                        achat1a10.isHidden = true
                        grilles1a10.isHidden = false
                        label1a10.text = "Grilles 1 à 10 achetées!"

                    }else if productID == GRILLES_PRODUCT_ID11a20 {
                        grille11a20 = true
                        UserDefaults.standard.set(grille11a20, forKey: "grille11a20")
                        achat11a20.isHidden = true
                        grilles11a20.isHidden = false
                        lable11a20.text = "Grilles 11 à 20 achetées!"
                        
                        
                    }else if productID == GRILLES_PRODUCT_ID21a30 {
                        grille21a30 = true
                        UserDefaults.standard.set(grille21a30, forKey: "grille21a30")
                        achat21a30.isHidden = true
                        grilles21a30.isHidden = false
                        lablel21a30.text = "Grilles 21 à 30 achetées!"
                        
                        
                    }else if productID == GRILLES_PRODUCT_ID31a40 {
                        grille31a40 = true
                        UserDefaults.standard.set(grille31a40, forKey: "grille31a40")
                        achat31a40.isHidden = true
                        grilles31a40.isHidden = false
                        lablel31a40.text = "Grilles 31 à 40 achetées!"
                        
                        
                    }else if productID == GRILLES_PRODUCT_ID41a50 {
                        grille41a50 = true
                        UserDefaults.standard.set(grille41a50, forKey: "grille41a50")
                        achat41a50.isHidden = true
                        grilles41a50.isHidden = false
                        lable41a50.text = "Grilles 41 à 50 achetées!"

                    }
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    
                break
                    
                default: break
                }}}
    }

    @IBAction func buy1a10(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[0])
    }
    @IBAction func buy11a20(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[1])
    }
    @IBAction func buy21a30(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[2])
    }
    
 
    @IBAction func buy1a40(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[3])
    }
   
  
    @IBAction func buy41a50(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[4])
    }
    

    @IBAction func rétablirAchats(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        let result = queue.transactions
        for results in result {
            if GRILLES_PRODUCT_ID1a10 == results.payment.productIdentifier {
                grille1a10 = true
                UserDefaults.standard.set(grille1a10, forKey: "grille1a10")
                achat1a10.isHidden = true
                grilles1a10.isHidden = false
                label1a10.text = "Grilles 1 à 10 achetées!"
            }else if GRILLES_PRODUCT_ID11a20 == results.payment.productIdentifier{
                grille11a20 = true
                UserDefaults.standard.set(grille11a20, forKey: "grille11a20")
                achat11a20.isHidden = true
                grilles11a20.isHidden = false
                lable11a20.text = "Grilles 11 à 20 achetées!"
            }else if GRILLES_PRODUCT_ID21a30 == results.payment.productIdentifier{
                grille21a30 = true
                UserDefaults.standard.set(grille21a30, forKey: "grille21a30")
                achat21a30.isHidden = true
                grilles21a30.isHidden = false
                lablel21a30.text = "Grilles 21 à 30 achetées!"
            }else if GRILLES_PRODUCT_ID31a40 == results.payment.productIdentifier{
                grille31a40 = true
                UserDefaults.standard.set(grille31a40, forKey: "grille31a40")
                achat31a40.isHidden = true
                grilles31a40.isHidden = false
                lablel31a40.text = "Grilles 31 à 40 achetées!"

            }else if GRILLES_PRODUCT_ID41a50 == results.payment.productIdentifier{
                grille41a50 = true
                UserDefaults.standard.set(grille41a50, forKey: "grille41a50")
                achat41a50.isHidden = true
                grilles41a50.isHidden = false
                lable41a50.text = "Grilles 41 à 50 achetées!"
            }
        }
        
        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Vos achats ont été rétablis!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
 
    }
 
    
 
  

  
}
