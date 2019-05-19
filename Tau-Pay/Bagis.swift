//
//  FirstViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var amountBox: UITextField!
    @IBOutlet weak var selection: UISegmentedControl!
    @IBOutlet weak var miktarLabel: UILabel!
    @IBOutlet weak var gonder: UIButton!
    
    @IBAction func sendButton(_ sender: Any) {
        
        let queue = DispatchQueue(label: "request")
        
        queue.async {
            let amount = self.amountBox.text!
            
            if (amount == "") {
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " ").localized(), view: self, buttons: "Tamam")
                return
            }
            let type = self.selection.selectedSegmentIndex
            var typeString: String
            
            if type == 0 {
                typeString = "shuttle"
            }
            else {
                typeString = "mensa"
            }
            
            let json: [String: String] = [
                "priceId": typeString,
                "amount": self.amountBox.text!
            ]
            
            let response = Constants.SendRequestGetString(requestType: "/customers/donate-item", json: json)
            DispatchQueue.main.sync {
                if response.connectionError {
                    // Handle connection error
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " ").localized(), view: self, buttons: "Tamam")
                    return
                }
                if response.error != nil {
                    // Handle improper connection
                    if(response.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: NSLocalizedString("Dikkat!", comment: " ").localized(), message: NSLocalizedString("Hesabınıza başka bir cihazdan giriş yapıldı", comment: ""), view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: "Hatalı giriş".localized(), view: self, buttons: "Tamam".localized())
                    return
                }
                
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Başarılı", comment: " ").localized(), message: NSLocalizedString("Bağışınız kabul edilmiştir", comment: " ").localized(), view: self, buttons: "Tamam".localized())
            }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
        self.amountBox.delegate = self;
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
     
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        updateLanguage()
    }
    
    @objc func updateLanguage()
    {
        infoText.text = NSLocalizedString("Askıya yemek / shuttle seyahati bırakabilirsiniz.", comment: " ").localized()
        
        let shuttle = NSLocalizedString("Shuttle", comment: " ").localized()
        let yemekhane = NSLocalizedString("Yemekhane", comment: " ").localized()
        let miktar = NSLocalizedString("Miktar", comment: " ").localized()
        
        gonder.setTitle("Gonder".localized(), for: UIControl.State.normal)
        miktarLabel.text = miktar
        selection.setTitle(shuttle, forSegmentAt: 0)
        selection.setTitle(yemekhane, forSegmentAt: 1)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountBox {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

}

