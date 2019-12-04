//
//  IndividulaGridDelectionTableViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-10.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit

class IndividulaGridSelectionTableViewController: UITableViewController {
    var grillesChoisies = [String]()
    let fonts = FontsAndConstraintsOptions()
    var motsCroisesSelected = String()
    var dimension = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
                // prefer a light interface style with this:
                overrideUserInterfaceStyle = .light
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Mots Croises"
        view.backgroundColor = ColorReference.sandColor
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grillesChoisies.count
    }
     let minRowHeight: CGFloat = 50.0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = view.frame.height
        let temp = tHeight / CGFloat(grillesChoisies.count + 1)
        return temp > minRowHeight ? temp : minRowHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = " Grille: \(grillesChoisies[indexPath.row])"
        cell.textLabel?.font = fonts.normalBoldFont
        cell.detailTextLabel?.text = "En cours"
        cell.detailTextLabel?.font = fonts.smallItaliqueBoldFont
        cell.backgroundColor = ColorReference.sandColor
        let items = CoreDataHandler.fetchGrille(grilleSelected: grillesChoisies[indexPath.row])
        var status = false
        //MARK: CHANGE FOR DIMENSION
        let lastCharacter = grillesChoisies[indexPath.row].last
        let grilleNumber = grillesChoisies[indexPath.row]
        if lastCharacter == "E" || grilleNumber == "11G" || grilleNumber == "12G" || grilleNumber == "13G" || grilleNumber == "14G" || grilleNumber == "15G"{
            dimension = 11
        }else{
            dimension = 9
        }
        if items != [] {
            for n in 0...dimension {
                for m in 0...dimension {
                    let letter = CoreDataHandler.fetchLetters(noDeLettre: "\(n),\(m)", grilleSelected: grillesChoisies[indexPath.row])
                    if letter != "" && letter != " " &&  letter != "#" {
                        status = true
                    }
                }
            }
        }
        if items != [] {
            let isCompleted = CoreDataHandler.isMotsCroisesFinished(noDeLettre: "0,0", grilleSelected: grillesChoisies[indexPath.row])
            if status == true && isCompleted == false {
                cell.detailTextLabel?.text = "Le Mots Croisés est commencé"
            } else if status == false{
                cell.detailTextLabel?.text = "Faites un essai!"
            }else if status{
                cell.detailTextLabel?.text = "Le Mots Croisés est terminé!"
            }
        }else{
            cell.detailTextLabel?.text = "Faites un essai!"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        motsCroisesSelected = grillesChoisies[indexPath.row]
        performSegue(withIdentifier: "showMotsCroises", sender: self)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMotsCroises"{
            let controller = segue.destination as! MotCroiseViewController
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            controller.grilleSelected = motsCroisesSelected
        }

    }
     @IBAction func unwindToIndividualGrid(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }

    
}
