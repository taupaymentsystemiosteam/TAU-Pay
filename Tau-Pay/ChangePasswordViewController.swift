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
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " "), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    
    @IBAction func ChangePassword(_ sender: Any)
    {
        if oldPass.text == "" || newPass.text == "" || newPassRepeated.text == "" {
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "))
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
                createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message:NSLocalizedString("Bağlantı Hatası", comment: " "))
                return
            }
            if response.error != nil {
                // Handle improper connection
                if response.error == "403" {
                    let alert =  UIAlertController(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı.", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Hatalı Giriş", comment: " "))
                    return
                }
            }
            
            if let responseInfo = response.info {
                createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "Şifre başarı ile değiştirildi. \(String(describing: responseInfo))")
            }
            
        } else {
            createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "Şifreler uyuşmuyor.")
            
        }
    }
    
}
