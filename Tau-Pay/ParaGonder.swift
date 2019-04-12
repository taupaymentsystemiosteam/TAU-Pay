//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate {
    
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
    @IBOutlet var OkulNoLabel: UILabel!
    @IBOutlet var MiktarLabel: UILabel!
    @IBOutlet var DikkatText: UITextView!
    @IBOutlet weak var moneyAmount: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        picker.delegate = self
        picker.dataSource = self
        
        moneyAmount.delegate = self
        studentNumber.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(false)
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
        }
        
        createAnimatedPopUp(title: "Sonuç", message: "Para başarıyla gönderildi. \(String(describing: response.info!))")
    }
}
