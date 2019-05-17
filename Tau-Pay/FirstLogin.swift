//
//  FirstLogin.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 10.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FirstLogin: UIViewController {
    
    func createYesNoPopUp(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
            self.sendChangeRequest()
        }))
        
        alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    func sendChangeRequest() {
    
        
        let json: [String: String] = [
            "newPass": newPassBox.text!
        ]
        let response = Constants.SendRequestGetString(requestType: "/customers/first-time-password", json: json)
        
        if response.connectionError {
            // Handle connection error
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Bağlantı Hatası", comment: " "), view: self, buttons: "Tamam")
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
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "\(NSLocalizedString("Şifreniz başarıyla gönderildi.", comment: " ")) \(String(describing: responseInfo))", view: self, buttons: "Tamam")
        }
        
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        if newPassBox.text == "" || newPassRepeatedBox.text == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "), view: self, buttons: "Tamam")
            return
        }
        if newPassBox.text != newPassRepeatedBox.text {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: NSLocalizedString("Şifreler uyuşmuyor", comment: " "), view: self, buttons: "Tamam")
        }
        
        createYesNoPopUp(title: NSLocalizedString("Emin Misin?", comment: " "), message: NSLocalizedString("Şifrenizin bu olmasını istediğinizden emin misiniz?", comment: " "))
        
        
        
    }
    
    @IBOutlet weak var newPassBox: UITextField!
    @IBOutlet weak var newPassRepeatedBox: UITextField!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var newpass: UILabel!
    @IBOutlet weak var newPassTekrat: UILabel!
    @IBOutlet weak var chagePassButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLanguage()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
      
    }
    
    @objc func updateLanguage()
    {
        let infoText = NSLocalizedString("Bu sizin ilk girisiniz , sifrenizi degistirmeniz gerekmektedir.", comment: " ")
        info.text = infoText
        
        newpass.text = "Yeni Sifre".localized()
        newPassTekrat.text = "Yeni Sifre (Tekrar)".localized()
        chagePassButton.setTitle("Degistir".localized(), for: UIControl.State.normal)
    
    }

}
