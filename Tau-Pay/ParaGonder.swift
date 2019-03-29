//
//  ParaGonder.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit

class ParaGonder: UIViewController {

    @IBOutlet weak var moneyBetrag: UITextField!
    @IBOutlet weak var studentNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func getNumberInfo() -> (info: String?, error: String?, connectionError: Bool) {
      
        let ip = "http://172.20.10.2:8080"
        
        let link = ip + "/customers/get-name"
        
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string:link)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let json = ["id":studentNumber.text!]
        
        var jsonData: Data
        var done = false
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            print("Error: \(error.localizedDescription)")
            return (nil,error.localizedDescription,false)
        }
        
        let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNjA1MDMxMzMiLCJleHAiOjE1NTQxNDA4OTR9.DBlmhkljTTYLORGZ29eSgyW4cRlAJaltSfDIa8MYq4TjH-400LF9bZMdCZE7HZ5H07k8qfqdM_oLUHgOb7aeMQ"
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false
         var info: String?
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            // I don't really know what this is for but I know it's important
            if error != nil {
                print("This is an error \(error!)")
                done = true
                return
            }
        
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if((400...2999).contains(httpResponse.statusCode)) {
                    httpFailure = String(httpResponse.statusCode)
                    done = true
                    return
                }
                do {
                    info = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                    print(info)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    httpFailure = "Parse Error"
                    done = true
                    return
                }
                
                done = true
            } else {
                connectionFailure = true
                
            }
        }
        task.resume()
        while done == false {
            usleep(500000)
        }
        
        // Here I check for different failures that could happen
        if(connectionFailure) {
            return (error: nil, info: nil, connectionError: true)
        }
        if(httpFailure != "") {
            return (error: httpFailure, info: nil, false)
        }
        
        return (info: info, error: nil, connectionError: false)
        }
    
    
    @IBAction func SendMoney(_ sender: Any)
    {
        
        let name = getNumberInfo().info
        let alert = UIAlertController(title: "Emin misin", message: "\(name ?? "Bulunamadı") adli ogrenciye para gonderilecek emin misiniz ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default, handler: {(action) in
            self.sendMoney()
        }))
        
        alert.addAction(UIAlertAction(title: "Iptal", style: UIAlertAction.Style.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
        func sendMoney()
    {
        
    
    
    
    }
    
    
    
    
    

}
