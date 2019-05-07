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
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " "), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func sendButton(_ sender: Any) {
        let amount = amountBox.text!
        
        if (amount == "") {
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Kutuların içi boş olamaz", comment: " "))
            return
        }
        let type = selection.titleForSegment(at: selection.selectedSegmentIndex)!
        let json: [String: String] = [
            "type": type,
            "amount": amountBox.text!
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/donate", json: json)
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: NSLocalizedString("Baglantı Hatası", comment: " "))
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " "), message: "Hatalı giriş")
            return
        }
        
        createAnimatedPopUp(title: NSLocalizedString("Başarılı", comment: " "), message: NSLocalizedString("Bağışınız kabul edilmiştir, Allah razı olsun!", comment: " "))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    
    }


}

