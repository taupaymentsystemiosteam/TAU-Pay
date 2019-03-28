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
    let ip = "http://192.168.1.200:8080/login"
    
    func login(id: String, password: String) -> (token: String?, error:
        String?, connectionError: Bool) {
        // The function expects there to be an ip already defined else it will complain about it not being defined.
        
        // Defines the url, session and request which are in turn where you connect to and then creates a sessions which is where all of tge informatiojn is exchanged and finally the request which has the json inside of it
        let url = URL(string: ip)!
        
        let session = URLSession.shared
        
        var request = URLRequest(url : url)
        
        // There are multiple httpMethods, this one uses the post method which is used to send and recieve information to and from the server
        request.httpMethod = "POST"
        
        
        // Adding a header which is where you specify that you will send a json file.  Later on when you want to send your token you need to add token: tokenKey to the header
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("")
        
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
            print("Error: \(error.localizedDescription)")
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
                return
            }
            // The server sends a response which contains the http error code and all of the headers in the response
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                if((400...2999).contains(httpResponse.statusCode)) {
                    httpFailure = String(httpResponse.statusCode)
                    return
                }
                // Here I read the header labeled autorhization
                token = (httpResponse.allHeaderFields["Authorization"] as? String)!
                done = true
            } else {
                connectionFailure = true
                
            }
        }
        task.resume()
        while done == false {
            usleep(500000)
        }
        if(connectionFailure) {
            return (error: nil, token: nil, connectionError: true)
        }
        if(httpFailure != "") {
            return (error: httpFailure, token: nil, false)
        }

        return (token: token, nil, false)
        
    }
    
    @IBOutlet weak var tempConsole: UITextField!
    @IBAction func loginDummyAction(_ sender: Any) {
        var loginResult = login(id: "160503133", password: "pass")
        tempConsole.text = loginResult.token
    }
    func getinfo() {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

