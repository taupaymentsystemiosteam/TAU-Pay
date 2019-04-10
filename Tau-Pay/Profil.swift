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
    
    //let ip = "http://192.168.1.200:8080"
    //let ip = "http://85.103.87.12:50090"
    //let ip = "http://172.17.27.229:8080"
    
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
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

