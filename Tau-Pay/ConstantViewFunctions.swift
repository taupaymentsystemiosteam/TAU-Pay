//
//  ConstantViewFunctions.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 8.05.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ConstantViewFunctions: UIViewController {
    
    static func createAnimatedPopUp(title: String, message: String, view: UIViewController) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " "), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
        return
    }
    
    static func createAnimatedLogoutPopUp(title: String, message: String, view: UIViewController) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            view.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
