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
            print("updated")
        }
    }
    
    @IBAction func update(_ sender: Any) {
        
    }
    
    
    @objc func failedUpdateInfo(_ notification: Notification) {
        //print("updated")
        if let response = notification.userInfo as? [String: Any?] {
            if (response["connectionError"] as? String == "true") {
                // Handle connection error
                createAnimatedPopUp(title: "Hata", message: NSLocalizedString("Baglantı hatası", comment: " "))
                return
            }
            if response["error"] != nil {
                // Handle improper connection
                
                createAnimatedPopUp(title: "Hata", message: NSLocalizedString("Hatalı Giriş", comment: <#T##String#>))
                return
            }
        } else {
            print("Something went wrong")
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    @objc func updateLanguage()
    {
        
        
    }
    
    
}
