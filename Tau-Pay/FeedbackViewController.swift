//
//  FeedbackViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 29.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet var Star1: UIButton!
    @IBOutlet var Star2: UIButton!
    @IBOutlet var Star3: UIButton!
    @IBOutlet var Star4: UIButton!
    @IBOutlet var Star5: UIButton!
    
    
    @IBAction func Star1Action(_ sender: Any) {
    }
    
    @IBAction func StarAction2(_ sender: Any) {
        Star1.setImage(UIImage(named: "circled_pay"), for: <#T##UIControl.State#>)
    }
    @IBAction func StarAction3(_ sender: Any) {
    }
    @IBAction func StarAction4(_ sender: Any) {
    }
    @IBAction func StarAction5(_ sender: Any) {
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



