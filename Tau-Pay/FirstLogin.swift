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
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }

    func sendChangeRequest() {
    
        
        let json: [String: String] = [
            "newPass": newPassBox.text!
        ]
        let response = Constants.SendRequestGetString(requestType: "/customers/first-time-password", json: json)
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        if let responseInfo = response.info {
            createAnimatedPopUp(title: "Sonuç", message: "Şifreniz başarıyla gönderildi. \(String(describing: responseInfo))")
        }
        
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        if newPassBox.text == "" || newPassRepeatedBox.text == "" {
            createAnimatedPopUp(title: "Hata", message: "Kutuların içi boş olamaz")
            return
        }
        if newPassBox.text != newPassRepeatedBox.text {
            createAnimatedPopUp(title: "Sonuç", message: "Şifreler uyuşmuyor AQ.")
        }
        
        createYesNoPopUp(title: "Emin Misiniz?", message: "Şifrenizin bu olmasını istediğinizden emin misiniz?")
        
        
        
    }
    @IBOutlet weak var newPassBox: UITextField!
    @IBOutlet weak var newPassRepeatedBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
