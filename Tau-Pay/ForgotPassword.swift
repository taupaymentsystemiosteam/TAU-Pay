//
//  ForgotPassword.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 10.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ForgotPassword: UIViewController {
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }


    @IBAction func sendButton(_ sender: Any) {
        
        let number = numberBox.text
        
        if number == "" {
            createAnimatedPopUp(title: "Hata", message: "Kutuların içi boş olamaz")
            return
        }
        let json: [String: String] = [
            "id": number!
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/forgot-password", json: json)
        
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
        createAnimatedPopUp(title: "Başarı", message: "Mailinizi kontrol edebilirsiniz")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginPage") as UIViewController
        present(vc, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var numberBox: UITextField!
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
