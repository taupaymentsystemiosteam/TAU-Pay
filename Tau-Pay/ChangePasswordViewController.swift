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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangePassword(_ sender: Any)
    {
        if oldPass.text == "" || newPass.text == "" || newPassRepeated.text == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "), view: self, buttons: "Tamam")
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
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message:NSLocalizedString("Bağlantı Hatası", comment: " "), view: self, buttons: "Tamam")
                return
            }
            if response.error != nil {
                // Handle improper connection
                if(response.error == "403") {
                    ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                    return
                }
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Hatalı Giriş", comment: " "), view: self, buttons: "Tamam")
                return
            }
            
            if let responseInfo = response.info {
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "Şifre başarı ile değiştirildi. \(String(describing: responseInfo))", view: self, buttons: "Tamam")
            }
            
        } else {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "Şifreler uyuşmuyor.", view: self, buttons: "Tamam")
            
        }
    }
    
}
