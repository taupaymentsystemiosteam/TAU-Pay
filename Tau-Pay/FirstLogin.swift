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
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Bağlantı Hatası", comment: " "))
            return
        }
        if response.error != nil {
            // Handle improper connection
            if(response.error == "403") {
                ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                return
            }
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Hatalı Giriş", comment: " "))
            return
        }
        if let responseInfo = response.info {
            createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: "\(NSLocalizedString("Şifreniz başarıyla gönderildi.", comment: " ")) \(String(describing: responseInfo))")
        }
        
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
        if newPassBox.text == "" || newPassRepeatedBox.text == "" {
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "))
            return
        }
        if newPassBox.text != newPassRepeatedBox.text {
            createAnimatedPopUp(title: NSLocalizedString("Sonuç", comment: " "), message: NSLocalizedString("Şifreler uyuşmuyor", comment: " "))
        }
        
        createYesNoPopUp(title: NSLocalizedString("Emin Misin?", comment: " "), message: NSLocalizedString("Şifrenizin bu olmasını istediğinizden emin misiniz?", comment: " "))
        
        
        
    }
    @IBOutlet weak var newPassBox: UITextField!
    @IBOutlet weak var newPassRepeatedBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

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
