//
//  ProfileTabController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 11.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ProfileTabController: UIViewController {
    
    @IBOutlet weak var helloBox: UILabel!
    @IBOutlet weak var shuttleBox: UILabel!
    @IBOutlet weak var cafeteriaBox: UILabel!
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    @objc func updateInfo(_ notification: Notification) {
    
        if let response = (notification.userInfo as? [String: Any]) {
            helloBox.text = "Merhaba \(String(describing: response["name"]!))"
            shuttleBox.text = "\(String(describing: response["balanceShuttle"]!)) TL"
            cafeteriaBox.text = "\(String(describing: response["balanceMensa"]!)) TL"
        }
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if Constants.TOKEN == "" {
            print("No Token Entry")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: .updateInfo, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(failedUpdateInfo(_:)), name: .failedUpdateInfo, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
}
