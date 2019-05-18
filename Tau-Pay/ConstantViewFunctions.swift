//
//  ConstantViewFunctions.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 8.05.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ConstantViewFunctions: UIViewController {
    
    static func createAnimatedPopUp(title: String, message: String, view: UIViewController, buttons: String...) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for i in buttons {
            alert.addAction(UIAlertAction(title: NSLocalizedString(i, comment: " "), style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        
        view.present(alert, animated: true, completion: nil)
        return
    }
    
    static func createAnimatedLogoutPopUp(title: String, message: String, view: UIViewController) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            logout(view: view)
            //view.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
        
    }
    
    static func logout(view: UIViewController) {
        Constants.TOKEN = ""
        view.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
