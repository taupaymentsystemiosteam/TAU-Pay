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
    @IBOutlet weak var ShuttleBox: UILabel!
    @IBOutlet weak var CafeteriaBox: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let response = Constants.SendRequestGetDictionary(request: "/customers/get-info", json: [:])
        
        nameBox.text = "\(response.info!["name"]!)"
        numberBox.text = "\(response.info!["id"]!)"
        ShuttleBox.text = "\(response.info!["balanceShuttle"]!)"
        CafeteriaBox.text = "\(response.info!["balanceMensa"]!)"
        
        //ShuttleBox.text = response
        
        
    }
}
