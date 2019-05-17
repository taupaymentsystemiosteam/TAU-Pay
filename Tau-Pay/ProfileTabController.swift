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
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var AyarlarButton: UIButton!
    
    @IBOutlet weak var shuttleLAbel: UILabel!
    @IBOutlet weak var yemekhaneLabel: UILabel!
    
    
    
    @objc func updateInfo(_ notification: Notification) {
        if let response = (notification.userInfo as? [String: Any]) {
            helloBox.text = NSLocalizedString("Merhaba", comment: "") + " \(String(describing: response["name"]!))"
            shuttleBox.text = "\(String(describing: response["balanceShuttle"]!)) TL"
            cafeteriaBox.text = "\(String(describing: response["balanceMensa"]!)) TL"
            print("updated")
        }
    }
    
    @IBAction func update(_ sender: Any) {
        
    }
    
    
    @objc func failedUpdateInfo(_ notification: Notification) {
        print("rip")
        if let response = notification.userInfo as? [String: Any?] {
            if (response["connectionError"] as? String == "true") {
                // Handle connection error
                ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " "), view: self, buttons: "Tamam".localized())
                return
            }
            if response["error"] != nil {
                // Handle improper connection
                print("here")
                print(response["error"] as! Substring)
                if(response["error"] as! Substring == "403") {
                
                    ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                    return
                }
                ConstantViewFunctions.createAnimatedPopUp(title: "Hata", message: NSLocalizedString("Hatalı Giriş", comment: " "), view: self, buttons: "Tamam")
                return
            }
        } else {
            print("Something went wrong")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLanguage()
    
        if Constants.TOKEN == "" {
            print("No Token Entry")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: .updateInfo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(failedUpdateInfo), name: .failedUpdateInfo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    @IBAction func feedbackOnClick(_ sender: Any) {
        NotificationCenter.default.post(name: .closeHamburger, object: self)
    }
    @IBAction func settingsOnClick(_ sender: Any) {
        NotificationCenter.default.post(name: .closeHamburger, object: self)
    }
    @objc func updateLanguage()
    {
        shuttleLAbel.text = NSLocalizedString("Shuttle Bakiye", comment: "").localized()
        yemekhaneLabel.text = NSLocalizedString("Yemekhane Bakiye", comment: "").localized()
        let feedback = NSLocalizedString("FeedBack", comment: " ").localized()
        let ayarlar = NSLocalizedString("Ayarlar", comment: " ").localized()
        
        feedbackButton.setTitle(feedback, for: UIControl.State.normal)
        AyarlarButton.setTitle(ayarlar, for: UIControl.State.normal)
        
    }
    
    
}
