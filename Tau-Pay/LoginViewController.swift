//
//  LoginViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 27.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var matrikelnummer_: UITextField!
    @IBOutlet weak var passwort_: UITextField!
    @IBOutlet weak var anmelden_: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let matrikelnummerImage = UIImage(named: "user_male")
        addLeftImageTo(txtField: matrikelnummer_, andImage: matrikelnummerImage!)
        
        let passwortImage = UIImage(named: "password")
        addLeftImageTo(txtField: passwort_, andImage: passwortImage!)
        
        matrikelnummer_.layer.cornerRadius = 15.0
        
       // let matrikelnummerImage = UIImage(named: "matrikelnummer_")
       // addLeftImageTo(txtField: matrikelnummer_, andImage: matrikelnummerImage!)
        
        //let passwortImage = UIImage(named: "passwort_")
        //addLeftImageTo(txtField: passwort_, andImage: passwortImage!)
        
        //matrikelnummer_.layer.cornerRadius = 15.0

    }
    
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage){
        
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    @IBAction func login_button(_ sender: Any) {
        let user = matrikelnummer_.text!
        let pass = passwort_.text!
        
        if (user == "" || pass == "") {
            return
        }
        
        let dict: [String: String] = [
            "id": user,
            "password": pass
            
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/login", json: dict)
        
        if(response.connectionError){
            //fehlende Internetverbindung
        }
            
        else if(response.error != nil){
            
            let alert = UIAlertController(title: "Fehlende Internetverbindung", message: "connection error", preferredStyle: .alert)
            
            let tryAgain = UIAlertAction(title: "Try again", style: .default) { (action) -> Void in
            }
            
            alert.addAction(tryAgain)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if(response.error == "403"){
            let alert = UIAlertController(title: "Verbindung fehlgeschlagen", message: "Matrikelnummer oder Passwort wurde falsch eingegeben", preferredStyle: .alert)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        else {
            Constants.setToken(token: response.info!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "navController") as UIViewController
            present(vc, animated: true, completion: nil)
        }
        
        
    }

    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
