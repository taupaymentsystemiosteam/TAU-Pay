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
        
        let money : Int? = Int(moneyAmount.text!)
        
        /*
        if money! < 0 {
            createAnimatedPopUp(title: "Çok zekisin ", message: "Para çalmaya çalışma artık Alp bitte!")
            return
        }
        */
        let json = [
            "id":studentNumber.text!
        ]
        
        let getname = Constants.SendRequestGetString(requestType: "/customers/get-name", json: json)
        
        if getname.connectionError {
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyiniz")
        }
        else if getname.error != nil {
            createAnimatedPopUp(title: "Hata", message: "Hata: \(getname.error!) tekrar deneyiniz")
        }
        else if getname.info == "user not found" {
            createAnimatedPopUp(title: "Hata", message: "Hatalı Öğrenci Numarası")
        }
        else {
            let name = getname.info
            let alert = UIAlertController(title: "Emin misin", message: "\(name ?? "Bulunamadı") adli ogrenciye \(moneyAmount.text!) TL para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
                self.sendMoneyRequest()
            }))
            
            alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func sendMoneyRequest()
    {
        
        let json = [
            "receiverId":studentNumber.text!,
            "balanceId":selectedValue.lowercased(),
            "amount": Double(moneyAmount.text!)!
            ] as [String : Any]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/transfer", json: json)
        
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
        
        if response.info == "balance not found" {
            createAnimatedPopUp(title: "Hata", message: "Hatalı Öğrenci Numarası")
            return
        }
        
        createAnimatedPopUp(title: "Sonuç", message: "Para başarıyla gönderildi.")
        Constants.getInfo()
    }
}
