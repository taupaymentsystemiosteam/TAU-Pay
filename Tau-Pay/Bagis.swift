//
//  FirstViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    
    @IBOutlet var DikkatText: UITextView!
    @IBOutlet weak var amountBox: UITextField!
    @IBOutlet weak var selection: UISegmentedControl!
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        
        let queue = DispatchQueue(label: "request")
        
        queue.async {
            let amount = self.amountBox.text!
            
            if (amount == "") {
                self.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " ").localized())
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
                    self.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " ").localized())
                    return
                }
                if response.error != nil {
                    // Handle improper connection
                    self.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: "Hatalı giriş".localized())
                    return
                }
                
                self.createAnimatedPopUp(title: NSLocalizedString("Başarılı", comment: " ").localized(), message: NSLocalizedString("Bağışınız kabul edilmiştir", comment: " ").localized())
            }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    
    }


}

