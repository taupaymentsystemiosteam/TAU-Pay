//
//  SettingsController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 24.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit



class SettingsController: UIViewController {
    @IBOutlet weak var languageSelector: UISegmentedControl!
    
    @IBOutlet weak var changePass: UIButton!
    @IBOutlet weak var exit: UIButton!
    
    
    @IBAction func logoutButton(_ sender: Any) {
        let alert =  UIAlertController(title: "Çıkış", message: "Çıkış yapmak istediğinize emin misiniz", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Evet", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
            ConstantViewFunctions.logout(view: self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Hayır", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        UserDefaults.standard.set("", forKey: "TOKEN")
        UserDefaults.standard.set(false, forKey: "loggedin")
        
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func onLanguageChange(_ sender: Any) {
        
        // Changes the selected language based off the index
        // 0 for Turkish, 1 for German
        Constants.setLanguage(newLanguage: languageSelector.selectedSegmentIndex)
        print("Chaaaaneeeee")
    }
    @IBOutlet weak var language: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "Language") == "de"
        {
            languageSelector.selectedSegmentIndex = 1
        }else
        {
            languageSelector.selectedSegmentIndex = 0
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
       
        updateLanguage()
        
        
    }
    
    @objc func updateLanguage()
    {
        language.text = "Dil".localized()
        changePass.setTitle("Sifre Degistir".localized(), for: UIControl.State.normal)
        exit.setTitle("Cikis".localized(), for: UIControl.State.normal)
        self.navigationItem.title = self.title?.localized()
    }

}
