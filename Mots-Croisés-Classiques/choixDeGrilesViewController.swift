//
//  choixDeGrilesViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2017-03-01.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit
var arrayGrillesChoisis: [String] = []
class choixDeGrilesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "grungyPaper")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func grilleGratuite(_ sender: Any) {
        print("grille gratuite")
        arrayGrillesChoisis = ["a", "b", "c"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grilleGratuite)
    }
    @IBAction func grille1a10(_ sender: Any) {
        print("1 a 10")
        arrayGrillesChoisis = ["1", "2", "3", "4", "5", "6" ,"7", "8", "9", "10"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille1a10)
    }
    @IBAction func grille11a20(_ sender: Any) {
        print("11 a 20")
        arrayGrillesChoisis = ["11", "12", "13", "14", "15", "16" ,"17", "18", "19", "20"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille11a20)
    }
    @IBAction func grille21a30(_ sender: Any) {
        print("21 a 30")
        arrayGrillesChoisis = ["21", "22", "23", "24", "25", "26" ,"27", "28", "29", "30"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille21a30)
    }
    @IBAction func grille31a40(_ sender: Any) {
        print("31 a 40")
        arrayGrillesChoisis = ["31", "32", "33", "34", "35", "36" ,"37", "38", "39", "40"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille31a40)
    }
    
    @IBAction func grille41a50(_ sender: Any) {
        print("41 a 50")
        arrayGrillesChoisis = ["41", "42", "43", "44", "45", "46" ,"47", "48", "49", "50"]
        performSegue(withIdentifier: "showDetailMotsCroises", sender: grille41a50)
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMotsCroises"{
            let controller = segue.destination as! DetailMotsCroises
            controller.arrayGrillesChoisis = arrayGrillesChoisis
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

 
    
 
  

  
}
