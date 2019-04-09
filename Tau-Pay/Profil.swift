//
//  SecondViewController.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 16.03.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import UIKit



class SecondViewController: UIViewController {
    var token = ""
    var hamburgerIsOpen = false
    
    //let ip = "http://192.168.1.200:8080"
    //let ip = "http://85.103.87.12:50090"
    let ip = "http://172.17.27.229:8080"
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    @IBAction func hamburgerAction(_ sender: Any) {
        if hamburgerIsOpen {
            leadingConstraint.constant = -330
        } else {
            leadingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: self.view.layoutIfNeeded)
        hamburgerIsOpen = !hamburgerIsOpen
    }
    
    
    
    func getInfo(token: String) -> (info: Dictionary<String, Any>?, error: String?, connectionError: Bool) {

        let infoIp = ip + "/customers/get-info"
        let url = URL(string: infoIp)!


        
        let session = URLSession.shared

        var request = URLRequest(url : url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let json: [String: Any] = [:]
        
        var jsonData: Data
        var done = false
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            print("Error: \(error.localizedDescription)")
            return (error: error.localizedDescription, info: nil, false)
        }
        
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false
        var info: [String: Any] = [:]
        
            let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
                
                // I don't really know what this is for but I know it's important
                if error != nil {
                    print("This is an error \(error!)")
                    httpFailure = error!.localizedDescription
                    done = true
                    return
                }
                // The server sends a response which contains the http error code and all of the headers in the response
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if((400...2999).contains(httpResponse.statusCode)) {
                        httpFailure = String(httpResponse.statusCode)
                        done = true
                        return
                    }
                    // Here I convert the response data into a json
                    
                    do {
                        info = try (((JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>)!))
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
            // The task above is not started until the resume method is called on it
            task.resume()
        
        var waitedTime = 0
        while done == false {
            print(waitedTime)
            if waitedTime > 50 {
                task.cancel()
                return (error: "Connection Timeout", info: nil, false)
            }
            usleep(500000)
            waitedTime = waitedTime + 5
            
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
    
    
    
    
    func login(id: String, password: String) -> (token: String?, error: String?, connectionError: Bool) {
        // The function expects there to be an ip already defined else it will complain about it not being defined.
        
        // Defines the url, session and request which are in turn where you connect to and then creates a sessions which is where all of tge informatiojn is exchanged and finally the request which has the json inside of it
        let loginIp = ip + "/login"
        let url = URL(string: loginIp)!
        
        let session = URLSession.shared
        
        var request = URLRequest(url : url)
        
        // There are multiple letpMethods, this one uses the post method which is used to send and recieve information to and from the server
        request.httpMethod = "POST"
        
        
        // Adding a header which is where you specify that you will send a json file.  Later on when you want to send your token you need to add token: tokenKey to the header
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // The json file is first initalized as a dictionary which contains the id and the password
        let json = [
            "id": id,
            "password": password
        ]
        
        // jsondata is what you will end up sending top the server
        var jsonData: Data
        // this variable will be false unntil the request is sent to the server and a response is given and processed
        var done = false

        // This is where the json dictionary is converted to a an actual json file
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            //print("Error: \(error.localizedDescription)")

            return (error: error.localizedDescription, token: nil, false)
        }
        
        // temporary token spot
        var token = ""
        // If an http error occures then it will be saved into this string. This string is then later checked
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false

    let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
        
        // I don't really know what this is for but I know it's important

        if error != nil {
            print("This is an error \(error!)")
            httpFailure = error!.localizedDescription
            done = true
            return
        }
        // The server sends a response which contains the http error code and all of the headers in the response
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
            if((400...2999).contains(httpResponse.statusCode)) {
                httpFailure = String(httpResponse.statusCode)
                done = true
                return
            }
            // Here I read the header labeled autorhization
            token = (httpResponse.allHeaderFields["Authorization"] as? String)!
            done = true
        } else {

            connectionFailure = true
            done = true
        }
    }
        // The task above is not started until the resume method is called on it
        task.resume()
        // I believe that the task is started on a different thread. For this reason I wait until I get a response

        var waitedTime = 0
        while done == false {
            print(waitedTime)
            if waitedTime > 50 {
                task.cancel()
                return (error: "Connection Timeout", token: nil, false)
            }
            usleep(500000)
            waitedTime = waitedTime + 5
        }
            
        // Here I check for different failures that could happen
        if(connectionFailure) {
            return (error: nil, token: nil, connectionError: true)
        }
        if(httpFailure != "") {
            return (error: httpFailure, token: nil, false)
        }

        return (token: token, nil, false)
        
    }
    */
    
    @IBOutlet weak var tokenBox: UITextField!
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var numberBox: UITextField!
    
    
    
    @IBAction func loginDummyAction(_ sender: Any) {
        let loginResult = login(id: "160503134", password: "pass123")
        if loginResult.connectionError == true {
            print("bad connection")
            tokenBox.text = "bad connection"
            return
        }
        if loginResult.error != nil {
            tokenBox.text = loginResult.error!
            print("error: \(loginResult.error)")
            return
        }
        token = loginResult.token!
        tokenBox.text = loginResult.token
    }
    
    
    
    @IBAction func getInfoAction(_ sender: Any) {
        var person = getInfo(token: token)
        if person.connectionError {
            print("Connection Error!")
        } else if (person.error != nil) {
            print("error \(person.error)")
        } else {
            nameBox.text = person.info!["name"] as? String
            numberBox.text = person.info!["id"] as? String
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

