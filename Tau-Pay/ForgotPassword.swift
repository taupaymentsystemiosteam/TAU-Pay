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
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " "), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }


    @IBAction func sendButton(_ sender: Any) {
        
        let number = numberBox.text
        
        if number == "" {
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "))
            return
        }
        let json: [String: String] = [
            "id": number!
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/forgot-password", json: json)
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Bağlantı Hatası", comment: " "))
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Hatalı Giriş", comment: " "))
            return
        }
        createAnimatedPopUp(title: NSLocalizedString("Başarı", comment: " "), message: NSLocalizedString("Mailinizi kontrol edebilirsiniz", comment: " "))
        
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
