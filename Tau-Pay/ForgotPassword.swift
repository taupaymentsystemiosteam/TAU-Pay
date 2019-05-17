//
//  ForgotPassword.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 10.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {



    @IBAction func sendButton(_ sender: Any) {
        
        let number = numberBox.text
        
        if number == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "), view: self, buttons: "Tamam")
            return
        }
        let json: [String: String] = [
            "id": number!
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/forgot-password", json: json)
        
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
        ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Başarı", comment: " "), message: NSLocalizedString("Mailinizi kontrol edebilirsiniz", comment: " "), view: self, buttons: "Tamam")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginPage") as UIViewController
        present(vc, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var numberBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var okulNo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateLanguage()
    NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func updateLanguage()
    {
        okulNo.text = "Okul Numarasi".localized() + ":"
        sendButton.setTitle("Gonder".localized(), for: UIControl.State.normal)
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
