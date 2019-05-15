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
        self.parent?.navigationItem.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parent?.navigationItem.title = self.selectedViewController?.title?.localized()
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
