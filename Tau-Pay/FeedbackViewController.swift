//
//  FeedbackViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 29.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit


class FeedbackViewController: UIViewController , UITextViewDelegate , UITextFieldDelegate {

    var stars = [UIButton]()
    
    @IBOutlet weak var AcıklamaText: UILabel!
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
            if i <= fillYellowUntil {
                stars[i - 1].setImage(UIImage(named: "filled_star"), for: UIControl.State.normal)
            }
            else {
                stars[i - 1].setImage(UIImage(named: "empty_star"), for: UIControl.State.normal)
            }
        }
        star = fillYellowUntil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
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
        FeedbackText.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
       updateLanguage()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func updateLanguage()
    {
        let info = NSLocalizedString("Yemekhane veya shuttle için puan verebilir ek olarak da yorum yapabilirsiniz.", comment: "").localized()
        let shuttle = NSLocalizedString("Shuttle", comment: " ").localized()
        let yemekhane = NSLocalizedString("Yemekhane", comment: " ").localized()
        let yorumlar = NSLocalizedString("Yorumlar", comment: " ").localized()
        
        MensaShutteSelect.setTitle(shuttle, forSegmentAt: 0)
        MensaShutteSelect.setTitle(yemekhane, forSegmentAt: 1)
        AcıklamaText.text = info
        FeedbackText.text = yorumlar
        
        GonderButton.setTitle("Gonder".localized(), for: UIControl.State.normal)
        
        self.parent?.navigationItem.title = self.title!.localized()
       
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
    
    
    
    @IBAction func GonderButton(_ sender: Any) {
        
        let Feedback: String = FeedbackText.text
        print(Feedback)
        
        let queue = DispatchQueue(label: "request")
        queue.async {
            let infos = [
                "star" : self.star,
                "type" :self.MensaShutteSelect.titleForSegment(at: self.MensaShutteSelect.selectedSegmentIndex) as Any,
                "text" : Feedback] as [String : Any]
            
            let response = Constants.SendRequestGetString(requestType: "/customers/feedback", json: infos)
            
            DispatchQueue.main.sync {
                if response.connectionError {
                    // Handle connection error
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                    return
                }
                if response.error != nil {
                    // Handle improper connection
                    if(response.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat".localized(), message: "Hesabınıza başka bir cihazdan giriş yapıldı".localized(), view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Hatalı Giriş", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                    return
                }
                
                
                ConstantViewFunctions.createAnimatedPopUp(title: "Başarılı".localized(), message: "Yorumunuz iletilmiştir".localized(), view: self, buttons: "Tamam".localized())
            }
        }
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



