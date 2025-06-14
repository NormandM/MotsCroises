//
//  IndividulaGridDelectionTableViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2019-10-10.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import UIKit
import SwiftUI

class IndividulaGridSelectionTableViewController: UITableViewController {
    var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    var grillesChoisies = [String]()
    let fonts = FontsAndConstraintsOptions()
    var motsCroisesSelected = String()
    var dimension = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        determineMyDeviceOrientation()
    }
    var iPadIsInLandScape = false
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Mots Croises"
        view.backgroundColor = ColorReference.sandColor
        navigationController?.navigationBar.isHidden = false
        determineMyDeviceOrientation()
      //  tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.detailTextLabel?.font = fonts.smallItaliqueBoldFont
        cell.backgroundColor = ColorReference.sandColor
        let items = CoreDataHandler.fetchGrille(grilleSelected: grillesChoisies[indexPath.row])
        var status = false
        //MARK: CHANGE FOR DIMENSION
        let lastCharacter = grillesChoisies[indexPath.row].last
        let grilleNumber = grillesChoisies[indexPath.row]
        if lastCharacter == "E" || lastCharacter == "V" ||
            grilleNumber == "11G" || grilleNumber == "12G" || grilleNumber == "13G" || grilleNumber == "14G" || grilleNumber == "15G" || grilleNumber == "16G" ||
            grilleNumber == "17G" || grilleNumber == "18G" || grilleNumber == "19G" || grilleNumber == "20G"{
            
            dimension = 11
        } else {
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
                var detailText = String()
                var searchText = String()
                let indiceMotsCroisesSelected = grillesChoisies[indexPath.row] + "indice"
                if UserDefaults.standard.bool(forKey: indiceMotsCroisesSelected){
                    searchText = "Avec"
                    detailText = "Le Mots Croisés est terminé! \nAvec l'aide d'indices"
                }else{
                    searchText = "Temps:"
        //            detailText = "Le Mots Croisés est terminé! \nTemps: \(formatTime(indexPath: indexPath.row))"
                    let formatted = self.formatTime(indexPath: indexPath.row)
                    print("⏱ Temps actualisé pour \(grillesChoisies[indexPath.row]) : \(formatted)")
                    detailText = "Le Mots Croisés est terminé! \nTemps: \(formatted)"
                }
                
                cell.detailTextLabel?.numberOfLines = 0
                   cell.detailTextLabel?.lineBreakMode = .byWordWrapping
                   cell.detailTextLabel?.text = detailText
                
                 if let range = detailText.range(of: searchText) {
                     let start = range.upperBound
                     let end = detailText.index(start, offsetBy: 30, limitedBy: detailText.endIndex) ?? detailText.endIndex
                     let extendedRange = start..<end
                     let nsRange = NSRange(extendedRange, in: detailText)
                     let attributedText = NSMutableAttributedString(string: detailText)
                     attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: nsRange)
                     let rangeForTemps = NSRange(range, in: detailText)
                     attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: rangeForTemps)
                     cell.detailTextLabel?.attributedText = attributedText
                 }
    }
}else{
cell.detailTextLabel?.text = "Faites un essai!"
}
return cell
}
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    motsCroisesSelected = grillesChoisies[indexPath.row]
    determineMyDeviceOrientation()
    let swiftUIController = UIHostingController(rootView: ContentView( motsCroisesSelected: motsCroisesSelected, dimension: dimension))
    if iPadIsInLandScape {
        navigationController?.pushViewController(swiftUIController, animated: true)
    }else{
        performSegue(withIdentifier: "showPlaceHolder", sender: self)
    }
    
    
}
// MARK: - Navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "showPlaceHolder"{
        let controller = segue.destination as! TransitionForKeyBoardViewController
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        controller.grilleSelected = motsCroisesSelected
    }
    
}

@IBAction func unwindToIndividualGrid(segue: UIStoryboardSegue) {
    tableView.reloadData()
}
func determineMyDeviceOrientation(){
    if UIDevice.current.orientation.isLandscape {
        iPadIsInLandScape = true
    } else {
        print("Device is in portrait mode")
    }
    let device = UIDevice.current
    let orientation = device.orientation

    switch orientation {
    case .portrait:
        iPadIsInLandScape = false
    case .portraitUpsideDown:
        iPadIsInLandScape = false
    case .landscapeLeft:
        iPadIsInLandScape = true
    case .landscapeRight:
        iPadIsInLandScape = true
    case .faceUp:
        if deviceWidth > deviceHeight{
            iPadIsInLandScape = true
        }else{
            iPadIsInLandScape = false
        }
    case .faceDown:
        if deviceWidth > deviceHeight{
            iPadIsInLandScape = true
        }else{
            iPadIsInLandScape = false
        }
    default:
        print("default")
    }
}
    func formatTime(indexPath: Int) -> String{
        let seconds = UserDefaults.standard.integer(forKey: grillesChoisies[indexPath])
        let minutes = (seconds / 60) % 60
        let secondsToShow = seconds % 60
        let formatedTime = String(format: "%02d:%02d", minutes, secondsToShow)
        let isCompleted = CoreDataHandler.isMotsCroisesFinished(noDeLettre: "0,0", grilleSelected: grillesChoisies[indexPath])
        if isCompleted && seconds != 0 {
            print(formatedTime)
            return formatedTime
        }else{
            return "_"
        }
        
        
    }
}

