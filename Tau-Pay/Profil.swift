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
            closeHamburger()
        } else {
            openHamburger()
        }
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
    
    /*
        The hamburger menu works by sliding a view tab controller from the side
        into the correct position
     
    */
    
    func openHamburger() {              
        Constants.getInfo()
        leadingConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        hamburgerIsOpen = true
        self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func closeHamburger() {
        leadingConstraint.constant = -330
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        hamburgerIsOpen = false
        self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            closeHamburger()
        } else {
            openHamburger()
        }
    }
    
    
  

}
