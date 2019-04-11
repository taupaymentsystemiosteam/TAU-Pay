//
//  SecondViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController {
    var token = ""
    var hamburgerIsOpen = false
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    @IBAction func hamburgerAction(_ sender: Any) {
        if hamburgerIsOpen {
            leadingConstraint.constant = -330
        } else {
            leadingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        hamburgerIsOpen = !hamburgerIsOpen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

