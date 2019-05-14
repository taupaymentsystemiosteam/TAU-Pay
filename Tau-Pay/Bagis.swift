//
//  FirstViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var DikkatText: UITextView!
    @IBOutlet weak var amountBox: UITextField!
    @IBOutlet weak var selection: UISegmentedControl!
    
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
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: "Hatalı giriş".localized(), view: self, buttons: "Tamam")
                    return
                }
                
                ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Başarılı", comment: " ").localized(), message: NSLocalizedString("Bağışınız kabul edilmiştir", comment: " ").localized(), view: self, buttons: "Tamam")
            }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.amountBox.delegate = self;
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    
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

