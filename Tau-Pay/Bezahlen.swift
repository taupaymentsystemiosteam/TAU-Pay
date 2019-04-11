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
        
        let response = Constants.SendRequestGetDictionary(request: "/customers/get-info", json: [:])
        
        Name.text = "İSİM: " + "\(response.info!["name"]!)"
        Matrikelnummer.text = "NUMARA: " + "\(response.info!["id"]!)"
        sguthaben.text = "\(response.info!["balanceShuttle"]!) TL"
        mguthaben.text = "\(response.info!["balanceMensa"]!) TL"
        
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
