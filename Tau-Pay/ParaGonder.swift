//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController {

    @IBOutlet weak var moneyBetrag: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func SendMoney(_ sender: Any)
    {
        /*
            Ilk olarak ogrenci numarasi servera gidip kim oldugu ogrenilecek
            Sonra bi emin misiniz yazisi cikacak
            Eminse para gonderilecek.
         */
        let name = "Nusret"
        let alert = UIAlertController(title: "Emin misin", message: "\(name) adli ogrenciye para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
            self.sendMoney()
        }))
        
        alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendMoney() {
        
    }
    
    
    
    
    

}
