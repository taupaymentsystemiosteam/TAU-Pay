//
//  TabbarController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 13.05.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let title = viewController.title
        if title == nil {
            print("No title specified")
            return
        }
        self.parent?.navigationItem.title = title?.localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = self.selectedViewController?.title?.localized()
        
     
    }
    

}
