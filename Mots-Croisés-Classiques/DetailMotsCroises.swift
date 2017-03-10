//
//  DetailMotsCroises.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-03-02.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit
import CoreData
class DetailMotsCroises: UITableViewController {
    var items: [Item] = []
    let dataController = DataController.sharedInstance
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest = { () -> NSFetchRequest<NSFetchRequestResult> in
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        //let sortDescriptor = NSSortDescriptor(key: "lettre", ascending: false)
        let sortDescriptor2 = NSSortDescriptor(key: "noMotcroise" ,ascending: false)
        let sortDescriptor4 = NSSortDescriptor(key: "completed" ,ascending: false)
        //let sortDescriptor3 = NSSortDescriptor(key: "noDeLettre" ,ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor2, sortDescriptor4]
        return request
    }()

    var stateOfMotsCroises: String = "Faites un essai"
    var grilleSelected: String = ""
    var modelName = UIDevice()
    var activityIndicatorView: ActivityIndicatorView!
    var arrayGrillesChoisis: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let modelName = UIDevice.current.modelName
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.title = "Mots-Croises"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "grungyPaper")!)
        if modelName == "iPad 2" || modelName == "iPad 3" || modelName == "iPad 4" || modelName == "iPad Air" || modelName == "iPad Air 2" || modelName == "iPad Pro" {
        self.tableView.rowHeight = 85.0
            
        }else{
            self.tableView.rowHeight = 60.0
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        cell.detailTextLabel?.text = stateOfMotsCroises
        if items != [] {
            if items[0].completed{
                cell.detailTextLabel?.text = "Le Mots Croisés est complétés!"
            }
        }
        
 
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
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        var n = 0
        var index = 0
        for grille in arrayGrillesChoisis{
            if grille  == grilleSelected{
                index = n
            } 
            n = n + 1
        }
        
        print(n)
        let cell = tableView.cellForRow(at: [0,index])
        cell?.detailTextLabel?.text = "Le Mots Croisés est complétés!"
       self.tableView.reloadRows(at: [[0, index] ], with: UITableViewRowAnimation.none)
        
    }
}
