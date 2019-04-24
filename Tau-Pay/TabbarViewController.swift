//
//  TabbarViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 22.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for controllers in self.viewControllers!
        {
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.setTitle("Deneme", for: UIControl.State.normal)
            controllers.view.addSubview(button)
        }
    }
    

   

}
