//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController, UITextFieldDelegate {
    
    
    var selectedValue = "shuttle"
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var OkulNoLabel: UILabel!
    @IBOutlet var MiktarLabel: UILabel!
    @IBOutlet weak var moneyAmount: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    @IBOutlet weak var gonderButton: UIButton!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func onTransferTypeSelected(_ sender: Any)
    {
        selectedValue = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        print(selectedValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.studentNumber.delegate = self;
        self.moneyAmount.delegate = self;
        
        updateLanguage()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        
    }
    
    @objc func updateLanguage()
    {
      
        infoLabel.text = "ParaTransferiInfo".localized()
        OkulNoLabel.text = "Okul Numarasi".localized() + ":"
        MiktarLabel.text = "Miktar".localized()
        
        segmentedControl.setTitle("Shuttle".localized(), forSegmentAt: 0)
        segmentedControl.setTitle("Yemekhane".localized(), forSegmentAt: 1)
        
        gonderButton.setTitle("Gonder".localized(), for: UIControl.State.normal)
        
    }
    
    //Redundant change keyboard type
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == moneyAmount || (studentNumber != nil) {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @IBAction func SendMoney(_ sender: Any)
    {
        
        if studentNumber.text == ""  || moneyAmount.text == "" {
            ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Kutuların içi boş olamaz".localized(), view: self, buttons: "Tamam".localized())
            return
        }
        
        let queue = DispatchQueue(label: "request")
        queue.async {
            let money : Int? = Int(self.moneyAmount.text!)

            let json = [
                "id":self.studentNumber.text!
            ]
            
            let getname = Constants.SendRequestGetString(requestType: "/customers/get-name", json: json)
            
            DispatchQueue.main.async {
                if getname.connectionError {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Bağlantı Hatası".localized(), view: self, buttons: "Tamam")
                }
                else if getname.error != nil {
                    if(getname.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!".localized(), message: "Hesabınıza başka bir cihazdan giriş yapıldı".localized(), view: self)
                        return
                    }
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Hata: \(getname.error!) tekrar deneyiniz", view: self, buttons: "Tamam".localized())
                }
                else if getname.info == "user not found" {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: NSLocalizedString("Hatalı Öğrenci Numarası", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                }
                else {
                    let name = getname.info
                    let alert = UIAlertController(title: name!, message: "\(String(describing: self.moneyAmount.text)) TL" + NSLocalizedString("Para gonderilecek", comment: "").localized(), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Eminim".localized(), style: UIAlertAction.Style.default, handler: {(action) in
                        self.sendMoneyRequest()
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Iptal".localized(), style: UIAlertAction.Style.default, handler: {(action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        
    }
    
    func sendMoneyRequest() {
        let queue = DispatchQueue(label: "request")
        queue.async {
            let json = [
                "receiverId":self.studentNumber.text!,
                "balanceId":self.selectedValue.lowercased(),
                "amount": Double(self.moneyAmount.text!)!
                ] as [String : Any]
            
            
                let response = Constants.SendRequestGetString(requestType: "/customers/transfer", json: json)
                DispatchQueue.main.sync {
                if response.connectionError {
                    // Handle connection error
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: "Bağlantı Hatası".localized(), view: self, buttons: "Tamam".localized())
                }
                else if response.error != nil {
                    // Handle improper connection
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: NSLocalizedString("Hatalı giriş", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                }
                else if response.info == "user not found" {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: NSLocalizedString("Hatalı Öğrenci Numarası", comment: " "), view: self, buttons: "Tamam".localized())
                }
                else if response.info == "balance not found" {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Hata".localized(), message: NSLocalizedString("bakiye bulunamadı", comment: " "), view: self, buttons: "Tamam".localized())
                }
                else if response.info == "insufficient balance" {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Sonuç".localized(), message: NSLocalizedString("Yetersiz bakiye", comment: " "), view: self, buttons: "Tamam".localized())
                }
                else if response.info == "transfered successfully" {
                    ConstantViewFunctions.createAnimatedPopUp(title: "Sonuç".localized(), message: NSLocalizedString("Para başarıyla gönderildi.", comment: " ").localized(), view: self, buttons: "Tamam".localized())
                }
                else {
                    print(response.info!)
                    print("Ooops Something went wrong")
                }
                
            }
            
            Constants.getInfo()
        }
        
    }
}
