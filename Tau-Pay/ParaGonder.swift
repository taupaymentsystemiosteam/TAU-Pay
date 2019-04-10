//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let values = ["Shuttle","Mensa"]
    var selectedValue = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedValue = values[row]
        
    }
    
    @IBOutlet weak var moneyBetrag: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    @IBAction func SendMoney(_ sender: Any)
    {
        let json = ["id":studentNumber.text!]
        
        let getname = Constants.SendRequestGetString(requestType: "/customers/get-name", json: json)
        
        if getname.connectionError
        {
            let connError = UIAlertController(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyeniz", preferredStyle: UIAlertController.Style.alert)
            connError.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                connError.dismiss(animated: true, completion: nil)
            }))
            self.present(connError,animated: true,completion: nil)
            
        }
        else if getname.error != nil
        {
            let connError = UIAlertController(title: "Hata", message: "Error : \(getname.error!) tekrar deneyiniz", preferredStyle: UIAlertController.Style.alert)
            connError.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
                connError.dismiss(animated: true, completion: nil)
            }))
            self.present(connError,animated: true,completion: nil)
        }
        else
        {
            let name = getname.info
            let alert = UIAlertController(title: "Emin misin", message: "\(name ?? "Bulunamadı") adli ogrenciye \(moneyBetrag.text!) TL para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
            
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
        
        let json = ["receiverId":studentNumber.text!,
                    "balanceId":selectedValue.lowercased(),
                    "amount": Int(moneyBetrag.text!)!] as [String : Any]
        let response = Constants.SendRequestGetString(requestType: "/customers/transfer", json: json)
        
        let responseAlert = UIAlertController(title: "Result", message: "\(String(describing: response.info!))", preferredStyle: UIAlertController.Style.alert)
        
        responseAlert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            responseAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(responseAlert,animated: true,completion: nil)
        
        
    }
    
    
    
    
    
    
}
