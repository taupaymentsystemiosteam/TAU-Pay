//
//  ChangePasswordViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 7.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPassRepeated: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var oldPass: UITextField!
    
    @IBOutlet weak var oldPassLabel: UILabel!
    @IBOutlet weak var NewPassLabel: UILabel!
    @IBOutlet weak var newAgain: UILabel!
    @IBOutlet weak var change: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLanguage()
         NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateLanguage()
    {
        let old = NSLocalizedString("Eski Sifre", comment: "").localized()
        let new = NSLocalizedString("Yeni Sifre", comment: "").localized()
        let newagain = NSLocalizedString("Yeni Sifre (Tekrar)", comment: "").localized()
        let changeBut = NSLocalizedString("Degistir", comment: " ").localized()
        
        oldPassLabel.text = old
        NewPassLabel.text = new
        newAgain.text = newagain
        change.setTitle(changeBut, for: UIControl.State.normal)
    }
    
    @IBAction func ChangePassword(_ sender: Any)
    {
        if oldPass.text == "" || newPass.text == "" || newPassRepeated.text == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " ").localized(), view: self, buttons: "Tamam".localized())
            return
        }
        
        if newPass.text == newPassRepeated.text {
            let json = [
                "oldPass": oldPass.text,
                "newPass": newPass.text
            ]
            let response = Constants.SendRequestGetString(requestType: "/customers/change-password", json: json as Dictionary<String, Any>)
            
            
            if response.connectionError {
                // Handle connection error
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message:NSLocalizedString("Bağlantı Hatası", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                return
            }
            if response.error != nil {
                // Handle improper connection
                if(response.error == "403") {
                    ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat".localized(), message: "Hesabınıza başka bir cihazdan giriş yapıldı".localized(), view: self)
                    return
                }
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Hatalı Giriş", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                return
            }
            
            if let responseInfo = response.info {
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " ").localized(), message: NSLocalizedString("Şifre başarı ile değiştirildi.", comment: " ") + "\(String(describing: responseInfo))", view: self, buttons: "Tamam".localized())
            }
            
        } else {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " ").localized(), message: NSLocalizedString("Şifreler uyuşmuyor.", comment: ""), view: self, buttons: "Tamam".localized())
            
        }
    }
    
}
