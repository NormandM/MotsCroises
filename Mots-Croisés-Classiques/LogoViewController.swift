//
//  LogoViewController.swift
//  PaintingsAndArtists
//
//  Created by Normand Martin on 2018-09-17.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
//import AudioToolbox
import AVFoundation
import StoreKit
class LogoViewController: UIViewController, SKProductsRequestDelegate {
    var productsRequest = SKProductsRequest()
    var localizedPrice = String()
    var productIdentifiers = Set<String>()
    var iapProducts = [SKProduct]()
    var iapProductsArray = [[SKProduct]]()
    @IBOutlet weak var appsLabel: UILabel!
    @IBOutlet weak var appsLabel2: UILabel!
    @IBOutlet weak var logoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppOrientationUtility.lockOrientation(UIInterfaceOrientationMask.all, andRotateTo: UIInterfaceOrientation.unknown)
        self.navigationController?.isNavigationBarHidden = true
        fetchAvailableProducts()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        let appsLabelFrame  = appsLabel.frame
        let appsLabel2Frame = appsLabel2.frame
        let maxXappsLabel = appsLabelFrame.maxX
        let maxXappsLabel2 = appsLabel2Frame.maxX
        UIView.animate(withDuration: 3, animations: {
            self.appsLabel2.transform = CGAffineTransform(translationX: maxXappsLabel - maxXappsLabel2 , y: 0)}, completion: {finished in self.completionAnimation()})
    }
    func completionAnimation() {
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when + 1) {
            self.performSegue(withIdentifier: "showMotsChoix", sender: (Any).self)
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMotsChoix"{
            let controller = segue.destination as! ChoixDeGrillesTableViewController
            controller.productIdentifiers = productIdentifiers
            controller.localizedPrice = localizedPrice
            controller.iapProducts = iapProducts
            controller.iapProductsArray = iapProductsArray
        }
    }
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        let productIdentifiers: Set = [IAPProduct.D01.rawValue, IAPProduct.D11.rawValue, IAPProduct.D21.rawValue, IAPProduct.D31.rawValue, IAPProduct.D41.rawValue, IAPProduct.I01.rawValue, IAPProduct.I11.rawValue, IAPProduct.I21.rawValue, IAPProduct.I31.rawValue, IAPProduct.I41.rawValue, IAPProduct.E01.rawValue, IAPProduct.E11.rawValue, IAPProduct.E21.rawValue, IAPProduct.E31.rawValue, IAPProduct.E41.rawValue]
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers )
        productsRequest.delegate = self
        productsRequest.start()
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        iapProducts = response.products
        localizedPrice = iapProducts[0].localizedPrice
        var iapProductsD = [SKProduct]()
        var iapProductsI = [SKProduct]()
        var iapProductsE = [SKProduct]()
        for n in 0...2{
            for m in 0...5{
                let indexPath: IndexPath = [n, m]
                switch indexPath {
                case [0,0]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 à 10 D"{
                            iapProductsD.append(product)
                        }
                    }
                case [0,1]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 à 10 D"{
                            iapProductsD.append(product)
                        }
                    }
                case [0, 2]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 11 a 20 D"{
                            iapProductsD.append(product)
                        }
                    }
                case [0, 3]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 21 a 30 D"{
                            iapProductsD.append(product)
                        }
                        
                    }
                case [0, 4]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 31 a 40 D"{
                            iapProductsD.append(product)
                        }
                    }
                case [0, 5]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 41 a 50 D"{
                            iapProductsD.append(product)
                        }
                    }
                case [1, 0]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 à 10"{
                            iapProductsI.append(product)
                        }
                    }
                case [1, 1]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 à 10"{
                            iapProductsI.append(product)
                        }
                    }
                case [1, 2]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 11 à 20"{
                            iapProductsI.append(product)
                        }
                    }
                case [1, 3]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 21 à 30"{
                            iapProductsI.append(product)
                        }
                    }
                case [1, 4]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 31 à 40"{
                            iapProductsI.append(product)
                        }
                    }
                case [1, 5]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grille 41 à 50"{
                            iapProductsI.append(product)
                        }
                    }
                case [2, 0]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 a 10 E"{
                            iapProductsE.append(product)
                        }
                    }
                case [2, 1]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 1 a 10 E"{
                            iapProductsE.append(product)
                        }
                    }
                case [2, 2]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 11 a 20 E"{
                            iapProductsE.append(product)
                        }
                    }
                case [2, 3]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 21 a 30 E"{
                            iapProductsE.append(product)
                        }
                    }
                case [2, 4]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 31 a 40 E"{
                            iapProductsE.append(product)
                        }
                    }
                case [2, 5]:
                    for product in iapProducts{
                        if product.localizedTitle == "Grilles 41 a 50 E"{
                            iapProductsE.append(product)
                        }
                    }
                default: print()
                }
            }
       }
        iapProductsArray.append(iapProductsD)
        iapProductsArray.append(iapProductsI)
        iapProductsArray.append(iapProductsE)
    }

}
