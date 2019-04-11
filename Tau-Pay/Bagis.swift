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
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    @IBAction func sendButton(_ sender: Any) {
        var amount = amountBox.text!
        
        if (amount == "") {
            createAnimatedPopUp(title: "Hata", message: "Kutuların içi boş olamaz")
            return
        }
        let type = selection.titleForSegment(at: selection.selectedSegmentIndex)!
        var json: [String: String] = [
            "type": type,
            "amount": amountBox.text!
        ]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/donate", json: json)
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        
        createAnimatedPopUp(title: "Başarılı", message: "Bağışınız kabul edilmiştir, Allah razı olsun!")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }


}

