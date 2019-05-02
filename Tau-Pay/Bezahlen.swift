//
//  Bezahlen.swift
//  Tau-Pay
//
//  Created by Sevcan Avcı on 10.04.19.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class Bezahlen: UIViewController {
    
    static var qrString = ""
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    var progressValue = 1.0
    
    static func setString(qr: String){
        qrString = qr
    }
    
    func createAnimatedPopUp(title: String, message: String) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    @IBAction func paybutton(_ sender: Any) {
        
        let dict: [String: String] = [:]
            
        let response = Constants.SendRequestGetString(requestType: "/customers/request-qr-code", json: dict)
    
    
        if response.connectionError {
            // Handle connection error
            createAnimatedPopUp(title: "Hata", message: "Bağlantı hatası, internete bağlantınızı kontrol ediniz ve birazdan tekrar deneyeniz")
            return
        }
        if response.error != nil {
            // Handle improper connection

            createAnimatedPopUp(title: "Hata", message: "Hatalı giriş")
            return
        }
        
        let data = Bezahlen.qrString.data(using:String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 13, y: 13)
            //print("bob")
            if let output = filter.outputImage?.transformed(by: transform) {
                qrCodeImage.image = UIImage(ciImage: output)
            }
        }
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        
        //QrCodeController.setString(qr: response.info!)
        
        
    }
    
    @objc func updateProgress() {
        progressValue = progressValue - 0.01
        self.progressBar.progress = Float(progressValue)
        if progressValue != 0.0 {
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //override func NewviewDidLoad(){
    //    super.viewDidLoad()
        
    //}
    

    
}
