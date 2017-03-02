//
//  ChoixDuMotsCroisesViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-02-09.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit
import Foundation


class ChoixDuMotsCroisesViewController: UITableViewController {
    var activityIndicatorView: ActivityIndicatorView!
    var motArrayInit: [[String]] = []
    var noDeGrille: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        if let plistPath = Bundle.main.path(forResource: "ListeMot", ofType: "plist"),
            let monArray = NSArray(contentsOfFile: plistPath){
            motArrayInit = monArray as! [[String]]
        }
        var motPrecedent = ""
        var n = 0
        for mot in motArrayInit {
            
            if motPrecedent != motArrayInit[n][0] {
                noDeGrille.append(mot[0])
                
            }
            motPrecedent = motArrayInit[n][0]
        n = n + 1
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noDeGrille.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.text = self.noDeGrille[indexPath.row]

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
    
    // here code perfomed with delay
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMotsCroises" {
            if let indexPath = self.tableView.indexPathForSelectedRow, let grilleSelected = tableView.cellForRow(at: indexPath)?.textLabel?.text {
               
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem

                let controller = segue.destination as! ViewController
                controller.grilleSelected = grilleSelected
                controller.activityIndicatorView = activityIndicatorView
                
                
            }

        }
    }
    

}
