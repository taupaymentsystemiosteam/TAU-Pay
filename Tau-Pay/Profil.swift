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
            let queue = DispatchQueue(label: "getInfo")
            queue.async {
                NotificationCenter.default.post(name: .updateInfo, object: self)
            }
            leadingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        hamburgerIsOpen = !hamburgerIsOpen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
    
        
    }
    
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if sender.direction == .left
        {
            hamburgerIsOpen = false
            leadingConstraint.constant = -330
            UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        }else
        {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .updateInfo, object: self)
            }
            leadingConstraint.constant = 0
              UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
            hamburgerIsOpen = true
            
        }
    }
    
    
  

}
