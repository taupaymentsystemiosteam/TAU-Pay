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
        let json = ["id":studentNumber.text!]
        
        let getname = Constants.SendRequestStringReturned(request: "/customers/get-name", json: json)
        
        if getname.connectionError
        {
            let connError = UIAlertController(title: "Hata", message: "Connection error, please try again", preferredStyle: UIAlertController.Style.alert)
            connError.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                connError.dismiss(animated: true, completion: nil)
            }))
            self.present(connError,animated: true,completion: nil)
            
        }
        else if getname.error != nil
        {
            let connError = UIAlertController(title: "Hata", message: "Error : \(getname.error!) try again", preferredStyle: UIAlertController.Style.alert)
            connError.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                connError.dismiss(animated: true, completion: nil)
            }))
            self.present(connError,animated: true,completion: nil)
        }
        else
        {
            let name = getname.info
            let alert = UIAlertController(title: "Emin misin", message: "\(name ?? "Bulunamadı") adli ogrenciye \(moneyBetrag.text!) TL para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
                self.sendMoneyRequest()
            }))
            
            alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
        func sendMoneyRequest()
    {
        
    
    
    
    }
    
    
    
    
    

}
