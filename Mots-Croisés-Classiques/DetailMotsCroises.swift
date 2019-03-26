//
//  DetailMotsCroises.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-03-02.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class DetailMotsCroises: UITableViewController, GADBannerViewDelegate {
    let request = GADRequest()
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
    lazy var fetchRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "lettre", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "noMotcroise" ,ascending: false)
        let sortDescriptor4 = NSSortDescriptor(key: "completed" ,ascending: false)
        let sortDescriptor3 = NSSortDescriptor(key: "noDeLettre" ,ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor2, sortDescriptor4]
        return request
    }()
    var fenetre = UserDefaults.standard.bool(forKey: "fenetre")
    var stateOfMotsCroises = UserDefaults.standard.string(forKey: "stateOfMotsCroises")
    var grilleSelected: String = ""
    var modelName = UIDevice()
    var activityIndicatorView: ActivityIndicatorView!
    var arrayGrillesChoisis: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        adBannerView.load(GADRequest())
        
        let modelName = UIDevice.current.modelName
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Mots-Croises"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "grungyPaper")!)
        if modelName == "iPad 2" || modelName == "iPad 3" || modelName == "iPad 4" || modelName == "iPad Air" || modelName == "iPad Air 2" || modelName == "iPad Pro" {
        self.tableView.rowHeight = 85.0
            
        }else{
            self.tableView.rowHeight = 60.0
        }

    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
       tableView.tableHeaderView?.frame = bannerView.frame
       tableView.tableHeaderView = bannerView
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGrillesChoisis.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        fetchRequest.predicate = NSPredicate(format: "noMotcroise == %@", arrayGrillesChoisis[indexPath.row])
        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [Item]
        }catch let error as NSError{
            print("Error fetching items objects; \(error.localizedDescription), \(error.userInfo)")
        }
        var status: Bool = false
        for item in items {
            if item.lettre != "" && item.lettre != " " && item.lettre != "#" {
                status  = true
            }
        }
        if items != [] {
            if status == true && items[0].completed == false {
                stateOfMotsCroises = "Le Mots Croisés est commencé"
            }else if status == false{
                stateOfMotsCroises = "Faites un essai!"
            }else if items[0].completed{
                stateOfMotsCroises = "Le Mots Croisés est terminé!"
            }
        }else{
            stateOfMotsCroises = "Faites un essai!"
        }
        UserDefaults.standard.set(stateOfMotsCroises, forKey: "stateOfMotsCroises")
        cell.detailTextLabel?.text = stateOfMotsCroises
        cell.textLabel?.text = "Mots Croisés #" + arrayGrillesChoisis[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.activityIndicatorView = ActivityIndicatorView(title: "Construction de la Grille...", center: self.view.center)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        
        self.activityIndicatorView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.performSegue(withIdentifier: "showMotsCroises", sender: indexPath)
        }
    }

    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showMotsCroises" {
                if let indexPath = self.tableView.indexPathForSelectedRow, let _ = tableView.cellForRow(at: indexPath){
                    let n = indexPath.item
                    let grilleSelected = arrayGrillesChoisis[n]
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                    let controller = segue.destination as! ViewController
                    controller.grilleSelected = grilleSelected
                    controller.activityIndicatorView = activityIndicatorView
                }
            }
        }
    func showAlert4 () {

        let alert = UIAlertController(title: "Mots Croisés Classiques", message: "Votre avis est important pour améliorer l'application. Vous aimez, vous n'aimez pas? Ça m'intéresse!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "D'accord, je donne mon avis", style: UIAlertActionStyle.default, handler:{(alert: UIAlertAction!) in self.rateApp(appId: "id1210494247") { success in
            print("RateApp \(success)")
            }}))
        alert.addAction(UIAlertAction(title: "Pas Maintenant", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ne plus me montrer cette fenêtre", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.fenetre = true; UserDefaults.standard.set(self.fenetre, forKey: "fenetre") }))
        self.present(alert, animated: true, completion: nil)
    }
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        var n = 0
        var index = 0
        for grille in arrayGrillesChoisis{
           if grille  == grilleSelected{
                index = n
            } 
            n = n + 1
        }
        self.tableView.reloadRows(at: [[0, index] ], with: UITableViewRowAnimation.none)
        UserDefaults.standard.set(stateOfMotsCroises, forKey: "stateOfMotsCroises")
        if fenetre == false {
            showAlert4()
        }
        
    }
}
