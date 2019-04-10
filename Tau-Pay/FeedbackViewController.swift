//
//  FeedbackViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 29.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit


class FeedbackViewController: UIViewController , UITextViewDelegate {

    @IBOutlet var AcıklamaText: UITextView!
    @IBOutlet var Star1: UIButton!
    @IBOutlet var Star2: UIButton!
    @IBOutlet var Star3: UIButton!
    @IBOutlet var Star4: UIButton!
    @IBOutlet var Star5: UIButton!
    @IBOutlet var MensaShutteSelect: UISegmentedControl!
    @IBOutlet var GonderButton: UIButton!
    @IBOutlet var FeedbackText: UITextView!
    
    

    @IBAction func StarAction1(_ sender: Any) {
        
        //Filling 1 Star
        Star1.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        
        //Emptying 4 Stars
        Star2.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star3.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star4.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star5.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
    }
    
    @IBAction func StarAction2(_ sender: Any) {
        //Filling 2 Stars
        Star1.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star2.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        
        //Emptying 3 Stars
        Star3.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star4.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star5.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)

    }
    @IBAction func StarAction3(_ sender: Any) {
        
        //Filling 3 Stars
        Star1.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star2.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star3.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        
        //Emptying 2 Stars
        Star4.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        Star5.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
        
        
    }
    @IBAction func StarAction4(_ sender: Any) {
        
        //Filling 4 Stars
        Star1.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star2.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star3.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star4.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        
        //Emptying 1 Star
        Star5.setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)

        
    }
    @IBAction func StarAction5(_ sender: Any) {
        
        //Filling 5 Stars
        
        Star1.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star2.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star3.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star4.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
        Star5.setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)

    }
    
    
    @IBAction func MensaShuttleSelect(_ sender: Any) {
        
        
        
        
    }
    
    
    @IBAction func GonderButton(_ sender: Any) {
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



