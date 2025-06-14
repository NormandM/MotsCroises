//
//  TransitionForKeyBoardViewController.swift
//  Mots-Croisés-Classiques
//
//  Created by Normand Martin on 2020-10-05.
//  Copyright © 2020 Normand Martin. All rights reserved.
//

import UIKit
import SwiftUI

class TransitionForKeyBoardViewController: UIViewController {
    var grilleSelected = String()
    var keyBoardCGRec = CGRect()
    var keyBoardIsHidden = Bool()
    var keyBoardHeight = CGFloat()
    var activityIndicatorView: ActivityIndicatorView!
    @IBOutlet weak var placeHolderTextField: UITextField!
    var effect: UIVisualEffect!
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    var blurEffectView = UIVisualEffectView()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(grilleTerminee), name: NSNotification.Name("GrilleTermineeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = ColorReference.coralColor
        blurredView()
        self.activityIndicatorView = ActivityIndicatorView(title: "Sélection de de la Grille...", center: self.view.center, view: view)
        self.view.addSubview(self.activityIndicatorView.getViewActivityIndicator())
        activityIndicatorView.startAnimating()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        placeHolderTextField.becomeFirstResponder()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.performSegue(withIdentifier: "showMotsCroises", sender: self)
        }
       
    }
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
    func blurredView() {
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effect = blurEffectView.effect
        effect = blurEffectView.effect
        view.addSubview(blurEffectView)
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            if segue.identifier == "showMotsCroises"{
                blurEffectView.removeFromSuperview()
                activityIndicatorView.stopAnimating()
                let controller = segue.destination as! MotCroiseViewController
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                controller.grilleSelected = grilleSelected
                controller.keyBoardHeight = keyBoardCGRec.size.height
                controller.keyBoardCGRecPlaceHolder = keyBoardCGRec
            }
        
    }
    @objc func grilleTerminee() {
        // Nothing to do here for now, but the selector must exist to avoid runtime error
    }

}
