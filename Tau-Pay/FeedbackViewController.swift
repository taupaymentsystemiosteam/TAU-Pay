//
//  FeedbackViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 29.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit


class FeedbackViewController: UIViewController , UITextViewDelegate {

    var stars = [UIButton]()
    
    @IBOutlet var AcıklamaText: UITextView!
    @IBOutlet var Star1: UIButton!
    @IBOutlet var Star2: UIButton!
    @IBOutlet var Star3: UIButton!
    @IBOutlet var Star4: UIButton!
    @IBOutlet var Star5: UIButton!
    @IBOutlet var MensaShutteSelect: UISegmentedControl!
    @IBOutlet var GonderButton: UIButton!
    @IBOutlet var FeedbackText: UITextView!
    
    func changeStarColors(fillYellowUntil: Int) {
        for i in 1...stars.count {
            print(i)
            if i <= fillYellowUntil {
                stars[i - 1].setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
            }
            else {
                stars[i - 1].setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
            }
        }
        star = fillYellowUntil
    }

    // Feedback TextView
    override func viewDidLoad() {
        super.viewDidLoad()
        FeedbackText.delegate = self
        FeedbackText.layer.borderColor = UIColor.lightGray.cgColor
        FeedbackText.layer.borderWidth = 1.0
        
        stars.append(Star1)
        stars.append(Star2)
        stars.append(Star3)
        stars.append(Star4)
        stars.append(Star5)
        
    }
    
    @IBAction func textViewDidBeginEditing (_ FeedbackText: UITextView) {
        
        FeedbackText.text = " "
        FeedbackText.textColor = UIColor.black
    }
    // END
    
    // Star Rating
    
    var star : Int = 1

    
    @IBAction func StarAction1(_ sender: Any) {
        
        changeStarColors(fillYellowUntil: 1)
    }
    
    @IBAction func StarAction2(_ sender: Any) {
        //Filling 2 Stars
        changeStarColors(fillYellowUntil: 2)

    }
    @IBAction func StarAction3(_ sender: Any) {
        //Filling 3 Stars
        changeStarColors(fillYellowUntil: 3)
        
    }
    @IBAction func StarAction4(_ sender: Any) {
        //Filling 4 Stars
        changeStarColors(fillYellowUntil: 4)
        
    }
    @IBAction func StarAction5(_ sender: Any) {
        //Filling 5 Stars
        changeStarColors(fillYellowUntil: 5)

    }
    
    //END
    
    
    @IBAction func MensaShuttleSelect(_ sender: Any) {
        
           let Type = MensaShutteSelect.titleForSegment(at: MensaShutteSelect.selectedSegmentIndex)
        
        
    }
    
    
    @IBAction func GonderButton(_ sender: Any) {
        
        let Feedback: String = FeedbackText.text
        print(Feedback)
        
        let infos = [
            "star" : star,
            "type" :MensaShutteSelect.titleForSegment(at: MensaShutteSelect.selectedSegmentIndex) as Any,
            "text" : Feedback] as [String : Any]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/feedback", json: infos)
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        
        
        createAnimatedPopUp(title: "Başarılı", message: "Yorumunuz iletilmiştir")
        

    }
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
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



