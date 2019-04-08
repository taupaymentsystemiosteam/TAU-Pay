//
//  ChangePasswordViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 7.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPassRepeated: UITextField!
    @IBOutlet weak var newPass: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func ChangePassword(_ sender: Any)
    {
        if newPass.text == newPassRepeated.text {
            let json = ["newPass":newPass.text]
            let response = Constants.SendRequestGetString(request: "/customers/change-password", json: json as Dictionary<String, Any>)
           
            if let responseInfo = response.info
           {
            let alert = UIAlertController(title: "Result", message: "\(String(describing: responseInfo))", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert,animated: true,completion: nil)
            }
        
        }else
        {
            let alert = UIAlertController(title: "Result", message: "Şifreler uyuşmuyor AQ.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Tamam AQ", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert,animated: true,completion: nil)
        }
        
        
    }
    
}
