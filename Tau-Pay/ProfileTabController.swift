//
//  ProfileTabController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 11.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ProfileTabController: UIViewController {
    
    @IBOutlet weak var nameBox: UILabel!
    @IBOutlet weak var numberBox: UILabel!
    @IBOutlet weak var shuttleBox: UILabel!
    @IBOutlet weak var cafeteriaBox: UILabel!
    
    @objc func updateInfo() {
        let response = Constants.SendRequestGetDictionary(request: "/customers/get-info", json: [:])
        
        func createAnimatedPopUp(title: String, message: String) {
            let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, bakiyeleriniz güncellenmemiştir")
            
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        
        nameBox.text = "\(response.info!["name"]!)"
        numberBox.text = "\(response.info!["id"]!)"
        shuttleBox.text = "\(response.info!["balanceShuttle"]!)"
        cafeteriaBox.text = "\(response.info!["balanceMensa"]!)"
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if Constants.TOKEN == "" {
            print("No Token Entry")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: .updateInfo, object: nil)
        
        updateInfo()
        
        
    }
    
    
}
