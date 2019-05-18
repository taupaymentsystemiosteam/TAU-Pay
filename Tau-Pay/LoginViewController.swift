//
//  LoginViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 27.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var matrikelnummer_: UITextField!
    @IBOutlet weak var passwort_: UITextField!
    @IBOutlet weak var anmelden_: UIButton!
    @IBOutlet weak var PasswortVergessen: UIButton!
    

    /*
    func createAnimatedPopUp(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle,style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
        return
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lang = UserDefaults.standard.string(forKey: "Language")
        {
            Bundle.setLanguage(lang: lang)
        }else
        {
           if Locale.current.languageCode == "tr" || Locale.current.languageCode == "de"
           {
            Bundle.setLanguage(lang: Locale.current.languageCode!)
            }else
           {
            Bundle.setLanguage(lang: "tr")
            }
        }
        
       updateLanguage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        
      
        let matrikelnummerImage = UIImage(named: "user_male")
        addLeftImageTo(txtField: matrikelnummer_, andImage: matrikelnummerImage!)
        
        let passwortImage = UIImage(named: "password")
        addLeftImageTo(txtField: passwort_, andImage: passwortImage!)
        
        matrikelnummer_.layer.cornerRadius = 15.0
        
        self.matrikelnummer_.delegate = self;
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if UserDefaults.standard.bool(forKey: "loggedin") == true {
            
            Constants.setToken(token: UserDefaults.standard.string(forKey: "TOKEN")!)
            
            let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func updateLanguage() {
        let text = "Giriş".localized()
        anmelden_.setTitle(text, for: UIControl.State.normal)
        
        matrikelnummer_.placeholder = "Okul Numarasi".localized()
        
        passwort_.placeholder = NSLocalizedString("Parola", comment: " ").localized()
        
        PasswortVergessen.setTitle("Şifremi Unuttum".localized(), for: UIControl.State.normal)
        
    }
    
    func addLeftImageTo(txtField: UITextField, andImage img: UIImage){
        
        let leftImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 20))
        
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == matrikelnummer_ {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @IBAction func login_button(_ sender: Any) {
        
        let queue = DispatchQueue(label: "request")
        queue.async {
            let user = self.matrikelnummer_.text!
            let pass = self.passwort_.text!
            
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
            
            else if(response.error != nil) {
                DispatchQueue.main.sync {
                    if(response.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Hata".localized(), message: NSLocalizedString("Kullanıcı adı veya şifre yanlış", comment: " ").localized(), view: self)
                        return
                    }
                    else {
                        ConstantViewFunctions.createAnimatedPopUp(title: "İnternet Bağlantısı yok".localized(), message: NSLocalizedString("Bağlantınızı kontrol edip tekrar deneyiniz", comment: " ").localized(), view: self, buttons: NSLocalizedString("Tekrar Dene", comment: " "))
                    }
                }
                
            }
            else {
                DispatchQueue.main.sync {
                    Constants.setToken(token: response.info!)
                    UserDefaults.standard.set(response.info!, forKey: "TOKEN")
                    UserDefaults.standard.set(true, forKey: "loggedin")
                    
                    let storyboard = UIStoryboard(name: "ProfilePage", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ProfileNavController") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        
        
    }
}
