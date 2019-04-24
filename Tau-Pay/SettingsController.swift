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
    
    @IBAction func onLanguageChange(_ sender: Any) {
        
        // Changes the selected language based off the index
        // 0 for Turkish, 1 for German
        Constants.setLanguage(newLanguage: languageSelector.selectedSegmentIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
