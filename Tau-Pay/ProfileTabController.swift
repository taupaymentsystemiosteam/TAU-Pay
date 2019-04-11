//
//  ProfileTabController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 11.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ProfileTabController: UIViewController {
    
    @IBOutlet weak var nameBox: UILabel!
    @IBOutlet weak var numberBox: UILabel!
    @IBOutlet weak var shuttleBox: UILabel!
    @IBOutlet weak var cafeteriaBox: UILabel!
    
    @objc func updateInfo() {
        let response = Constants.SendRequestGetDictionary(request: "/customers/get-info", json: [:])
        
        nameBox.text = "\(response.info!["name"]!)"
        numberBox.text = "\(response.info!["id"]!)"
        shuttleBox.text = "\(response.info!["balanceShuttle"]!)"
        cafeteriaBox.text = "\(response.info!["balanceMensa"]!)"
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if Constants.TOKEN == "" {
            print("No Token Entry")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: .updateInfo, object: nil)
        
        updateInfo()
    }
    
}
