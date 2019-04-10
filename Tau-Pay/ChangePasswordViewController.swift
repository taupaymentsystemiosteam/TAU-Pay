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
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    
    @IBAction func ChangePassword(_ sender: Any)
    {
        if newPass.text == newPassRepeated.text {
            let json = [
                "newPass":newPass.text,
                "oldPass": oldPass.text
            ]
            if oldPass.text == "" || newPass.text == "" || newPassRepeated.text == "" {
                createAnimatedPopUp(title: "Result", message: "Kutuların hepsini doldurunuz")
                return
            }
            
            let response = Constants.SendRequestGetString(requestType: "/customers/change-password", json: json as Dictionary<String, Any>)
            
            if response.connectionError {
                // Handle connection error
                createAnimatedPopUp(title: "Result", message: "Internete bağlanamadı, internet bağlantınızı kontrol ediniz ve birazdan tekrar deneyeniz")
                return
            }
            if response.error != nil {
                // Handle improper connection
                createAnimatedPopUp(title: "Result", message: "Hatalı giriş")
                return
            }
            
           
            if let responseInfo = response.info {
                createAnimatedPopUp(title: "Result", message: "\(String(describing: responseInfo))")
            }
        
            } else {
                let alert = UIAlertController(title: "Result", message: "Şifreler uyuşmuyor AQ.", preferredStyle: UIAlertController.Style.alert)
            
                alert.addAction(UIAlertAction(title: "Tamam AQ", style: UIAlertAction.Style.default, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
            self.present(alert,animated: true,completion: nil)
            }
        
        
    }
    
}
