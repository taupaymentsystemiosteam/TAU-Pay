//
//  Bezahlen.swift
//  Tau-Pay
//
//  Created by Sevcan Avcı on 10.04.19.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class Bezahlen: UIViewController {
    
    var timer = Timer()
    var isTimerStarted = false
    static var qrString = ""
    
    @IBOutlet weak var infotext: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var PayButton: UIButton!
    
    var progressValue = 1.0
    
    static func setString(qr: String){
        qrString = qr
    }
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Tamam", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    func Pay()
    {
        progressBar.isHidden = false
        infotext.isHidden = true
        qrCodeImage.isHidden = false
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        let dict: [String: String] = [:]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/request-qr-code", json: dict)
        
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " ").localized())
            return
        }
        
        if(response.error == "403"){
            createAnimatedPopUp(title: "Dikkat!", message: "Hesabınıza başka bir cihazdan giriş yapıldı.")
            performSegue(withIdentifier:"loginPage", sender: nil)
        }
        
        if response.error != nil {
            // Handle improper connection
            
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Hatalı Giriş", comment: "").localized())
            return
        }
        
        Bezahlen.setString(qr: response.info!)
        
        
        let data = Bezahlen.qrString.data(using:String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 20, y: 20)
            //print("bob")
            if let output = filter.outputImage?.transformed(by: transform) {
                qrCodeImage.image = UIImage(ciImage: output)
            }
        }
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        PayButton.setTitle(NSLocalizedString("İptal", comment: " ").localized(), for: UIControl.State.normal)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.Ispaid()
        }
    }
    
    func Cancel()
    {
        let alert = UIAlertController(title: NSLocalizedString("Emin Misin?", comment: " ").localized(), message: NSLocalizedString("Iptal etmek istediğinize emin misiniz?", comment: " ").localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Eminim", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
                   self.turnToDefault()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Vazgeç", comment: " ").localized(), style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func paybutton(_ sender: Any) {
        if PayButton.currentTitle == NSLocalizedString("Ödeme", comment: " ").localized() {
            Pay()
        }else
        {
            Cancel()
        }

    }
    
    @objc func Ispaid()
    {
        let dict: [String: String] = ["qrCode": Bezahlen.qrString]
        
        let response = Constants.SendRequestGetString(requestType: "/customers/is-paid", json: dict)
        
        
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: NSLocalizedString("Hata", comment: " ").localized(), message: NSLocalizedString("Bağlantı Hatası", comment: " ").localized())
            return
        }
        if response.error != nil {
            // Handle improper connection
            createAnimatedPopUp(title: "Hata".localized(), message: "Hatalı Giriş".localized())
            
            createAnimatedPopUp(title: NSLocalizedString("Hata".localized(), comment: " "), message: NSLocalizedString("Hatalı Giriş", comment: " ").localized())
            return
        }
        
        if response.info! == "not paid" {
            if !qrCodeImage.isHidden {
                Ispaid()
            }
        }
        else if response.info! == "qr code not found" {
            print("opss bad news qr kod not found")
        }
        else if response.info! == "insufficient balance" {
            print("more bad news we are poor! Show dialog!")
            DispatchQueue.main.async {
                       self.turnToDefault()
                self.createAnimatedPopUp(title: NSLocalizedString("Ödeme", comment: " "), message: NSLocalizedString("Insufficent balance", comment: " "))
            }
        }
        else if response.info! == "paid successfully" {
            print("Yeeey we are not broke! Paid succesfully!")
            DispatchQueue.main.async {
                self.turnToDefault()
                self.createAnimatedPopUp(title: NSLocalizedString("Ödeme", comment: " "), message: NSLocalizedString("Ödeme başarılı", comment: " "))
            }
        }
        else {
            print("A problem has occurred while reading qr-code: \(response.info!)")
        }
    }
    
    
    @objc func updateProgress() {
        progressValue = progressValue - 0.005
        self.progressBar.progress = Float(progressValue)
        if progressValue > 0.0 {
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        }
        else {
            turnToDefault()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        qrCodeImage.isHidden = true
        infotext.text = "infoText".localized()
        PayButton.setTitle("Ödeme".localized(), for: UIControl.State.normal)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .changeLanguage, object: nil)
        
    }
    
    @objc func updateLanguage()
    {
         infotext.text = "infoText".localized()
         PayButton.setTitle("Ödeme".localized(), for: UIControl.State.normal)
        
    }
    
    func turnToDefault()
    {
        self.infotext.isHidden = false
        self.progressBar.isHidden = true
        self.qrCodeImage.isHidden = true
        self.PayButton.setTitle(NSLocalizedString("Ödeme", comment: " "), for: UIControl.State.normal)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        progressValue = 1
    }
    
    
}
