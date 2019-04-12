//
//  QrCodeController.swift
//  Tau-Pay
//
//  Created by Sevcan Avcı on 10.04.19.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class QrCodeController: UIViewController {

    static var qrString = ""
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet var pview: UIView!
    var progressValue = 1.0
    
    
    static func setString(qr: String) {
        qrString = qr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1
        //let myString = response.info
        
        let data = QrCodeController.qrString.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 13, y: 13)
            print("bob")
            if let output = filter.outputImage?.transformed(by: transform) {
                qrCodeImage.image = UIImage(ciImage: output)
            }
        }
        
        
        
        
        
        // Every second reduce timer by 1
        self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
        
        
        // go back to previous page
        
        
    }
    
    @objc func updateProgress() {
        progressValue = progressValue - 0.01
        self.progressBar.progress = Float(progressValue)
        if progressValue != 1.0 {
            self.perform(#selector(updateProgress), with: nil, afterDelay: 0.2)
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
