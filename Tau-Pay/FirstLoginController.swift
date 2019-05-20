//
//  FirstLoginController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 20.05.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FirstLoginController: UIViewController {

    @IBOutlet weak var firstBoxText: UILabel!
    
    @IBOutlet weak var oldPassText: UILabel!
    
    @IBOutlet weak var newPassText: UILabel!
    @IBOutlet weak var newPassAgainText: UILabel!
    @IBOutlet weak var changeButton: UIButton!
   
    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newPassRepeated: UITextField!
    
    @objc func updateLanguage()
    {
        firstBoxText.text = "FirstBox".localized()
        oldPassText.text = "Eski Sifre".localized()
        newPassText.text = "Yeni Sifre".localized()
        newPassAgainText.text = "Yeni Sifre (Tekrar)".localized()
        
        changeButton.setTitle("Degistir".localized(), for: UIControl.State.normal)
        
        self.navigationItem.title! = self.title!.localized()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLanguage()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
    
    }

    @IBAction func ChangePassword(_ sender: Any)
    {
        if oldPass.text == "" || newPass.text == "" || newPassRepeated.text == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " ").localized(), view: self, buttons: "Tamam".localized())
            return
        }
        
        if newPass.text == newPassRepeated.text {
            let json = [
                "oldPass": oldPassText.text,
                "newPass": newPassText.text
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
            
            if let responseInfo = response.info
            {
                if responseInfo == "wrong password"
                {
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " ").localized(), message: "Yanlis Sifre".localized(), view: self, buttons: "Tamam".localized())
                    return
                }
                
                ConstantViewFunctions.createAnimatedLogoutPopUp(title: NSLocalizedString("Sonuç", comment: " ").localized(), message: NSLocalizedString("Şifre başarı ile değiştirildi.", comment: " ").localized(), view: self)
                
                
            }
            
        }
        else {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " ").localized(), message: NSLocalizedString("Şifreler uyuşmuyor.", comment: "").localized(), view: self, buttons: "Tamam".localized())
            
        }
    }
}


