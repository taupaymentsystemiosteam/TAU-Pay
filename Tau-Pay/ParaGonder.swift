//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController {
    
    
    var selectedValue = "shuttle"
    
   
    
   
    @IBOutlet var OkulNoLabel: UILabel!
    @IBOutlet var MiktarLabel: UILabel!
    @IBOutlet weak var moneyAmount: UITextField!
    @IBOutlet weak var studentNumber: UITextField!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func onTransferTypeSelected(_ sender: Any)
    {
        selectedValue = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        print(selectedValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    
    @IBAction func SendMoney(_ sender: Any)
    {
        
        if studentNumber.text == ""  || moneyAmount.text == "" {
            createAnimatedPopUp(title: "Hata", message: "Kutuların içi boş olamaz")
            return
        }
        
        let queue = DispatchQueue(label: "request")
        queue.async {
            let money : Int? = Int(self.moneyAmount.text!)
            
            /*
             if money! < 0 {
             createAnimatedPopUp(title: "Çok zekisin ", message: "Para çalmaya çalışma artık Alp bitte!")
             return
             }
             */
            let json = [
                "id":self.studentNumber.text!
            ]
            
            let getname = Constants.SendRequestGetString(requestType: "/customers/get-name", json: json)
            
            DispatchQueue.main.async {
                if getname.connectionError {
                    self.createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
                }
                else if getname.error != nil {
                    if(getname.error == "403") {
                        ConstantViewFunctions.createAnimatedLogoutPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı", view: self)
                        return
                    }
                    self.createAnimatedPopUp(title: "Hata", message: "Hata: \(getname.error!) tekrar deneyiniz")
                }
                else if getname.info == "user not found" {
                    self.createAnimatedPopUp(title: "Hata", message: "Hatalı Öğrenci Numarası")
                }
                else {
                    let name = getname.info
                    let alert = UIAlertController(title: "Emin misin", message: "\(name ?? "Bulunamadı") adli ogrenciye \(self.moneyAmount.text!) TL para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
                        self.sendMoneyRequest()
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
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
                    self.createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
                }
                else if response.error != nil {
                    // Handle improper connection
                    self.createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
                }
                else if response.info == "user not found" {
                    self.createAnimatedPopUp(title: "Hata", message: "Hatalı Öğrenci Numarası")
                }
                else if response.info == "balance not found" {
                    self.createAnimatedPopUp(title: "Hata", message: "bakiye bulunamadı")
                }
                else if response.info == "insufficient balance" {
                    self.createAnimatedPopUp(title: "Sonuç", message: "Yetersiz bakiye")
                }
                else if response.info == "transfered successfully" {
                    self.createAnimatedPopUp(title: "Sonuç", message: "Para başarıyla gönderildi.")
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
