//
//  Bezahlen.swift
//  Tau-Pay
//
//  Created by Sevcan Avcı on 10.04.19.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class Bezahlen: UIViewController {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Matrikelnummer: UILabel!
    @IBOutlet weak var shuttleGuthaben: UILabel!
    @IBOutlet weak var mensaGuthaben: UILabel!
    @IBOutlet weak var mguthaben: UILabel!
    @IBOutlet weak var sguthaben: UILabel!
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    @IBAction func paybutton(_ sender: Any) {
        
        let dict: [String: String] = [:]
            
        let response = Constants.SendRequestGetString(requestType: "/customers/request-qr-code", json: dict)
    
    
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyeniz")
            return
        }
        if response.error != nil {
            // Handle improper connection

            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        
        QrCodeController.setString(qr: response.info!)
        
        

        

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo(_:)), name: .updateInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedUpdateInfo(_:)), name: .failedUpdateInfo, object: nil)
        
        Constants.getInfo()
    
    }
    
    @objc func failedUpdateInfo(_ notification: Notification) {
        if let response = notification.userInfo as? [String: Any?] {
            if (response["connectionError"] as? String == "true") {
                // Handle connection error
                createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyeniz")
                return
            }
            if response["error"] != nil {
                // Handle improper connection
                
                createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
                return
            }
        } else {
            print("Something went wront")
        }
    }
    
    @objc func updateInfo(_ notification: Notification) {
        
        if let response = (notification.userInfo as? [String: Any]) {
            
            Name.text = "İSİM: \(String(describing: response["name"]!))"
            Matrikelnummer.text = "NUMARA: \(String(describing: response["id"]!))"
            sguthaben.text = "\(String(describing: response["balanceShuttle"]!)) TL"
            mguthaben.text = "\(String(describing: response["balanceMensa"]!)) TL"
        }
    }
    
}
