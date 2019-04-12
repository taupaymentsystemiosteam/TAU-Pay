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
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet var pview: UIView!
    
    
    static func setString(qr: String) {
        qrString = qr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1
        //let myString = response.info
        
        UIView.animate(withDuration: 4.0) {
            self.progress.setProgress(1.0, animated: true)
        }
        
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
        
        
        
        // go back to previous page
        
        
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
