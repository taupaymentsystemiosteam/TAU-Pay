//
//  ConstantsAndRequestFunctions.swift
//  Tau-Pay
//
//  Created by Nusret Özateş on 6.04.2019.
//  Copyright © 2019 Nusret Özateş. All rights reserved.
//

import Foundation


class Constants
{

    
    static let IP = "https://workshop-omercem.com:8443
    static var TOKEN = ""
    static var language = 0 // 0 for Turkish 1 for German
    
    static func setLanguage(newLanguage: Int) {
        
        language = newLanguage
        if language == 0 {
            Bundle.setLanguage(lang: "tr")
        }else
        {
            Bundle.setLanguage(lang: "de")
        }
        
        NotificationCenter.default.post(name: .changeLanguage, object: self)
      
    }
    
    static func setToken(token: String){
        TOKEN = token
    }
    
    static func getInfo() {
        let queue = DispatchQueue(label: "request")
        
        queue.async {
            let responseLocal = Constants.SendRequestGetDictionary(request: "/customers/get-info", json: [:])
            if responseLocal.error != nil || responseLocal.connectionError {
                var response: [String: Any?] = [:]
                response["connectionError"] = String(responseLocal.connectionError)
                response["error"] = responseLocal.error?.suffix(3)
                DispatchQueue.main.sync {
                    NotificationCenter.default.post(name: .failedUpdateInfo, object: self, userInfo: response)
                }
            }
            else {
                DispatchQueue.main.sync {
                    NotificationCenter.default.post(name: .updateInfo, object: self, userInfo: responseLocal.info)
                }
                
            }
        }
    }
    
    /*
     Request = "/customer/get-name" etc.
     json = your Dictionary Data to serialized as Json
     This function wil return response and error(If any) as String , and connectionError as Boolean
     Note : Eger sadece token gonderilecekse json nil olsun
     
     NUSRET OZATES
     */
    static func SendRequestGetString(requestType : String ,json : Dictionary<String, Any>?) ->(info : String? , error: String? , connectionError : Bool)
    {
        
        
        
        let link = IP + requestType
        
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string:link)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15    )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if(requestType != "/login"){
            request.setValue(TOKEN, forHTTPHeaderField: "Authorization")
        }
        
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false
        var info: String?
        
        var jsonData: Data
        var done = false
        
        do
        {
            if json != nil
            {
                jsonData = try JSONSerialization.data(withJSONObject: json!, options: [])
            }
            else
            {
                let newjson: [String: Any] = [:]
                jsonData = try JSONSerialization.data(withJSONObject: newjson, options: [])
            }
        }
        catch
        {
            print("Error: \(error.localizedDescription)")
            return (nil,error.localizedDescription,false)
        }
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            // I don't really know what this is for but I know it's important
            if error != nil {
                print("This is an error \(error!)")
                done = true
                httpFailure = error!.localizedDescription
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code = \(httpResponse.statusCode)")
                if((400...2999).contains(httpResponse.statusCode)) {
                    httpFailure = String(httpResponse.statusCode)
                    done = true
                    return
                }
                if requestType == "/login" {
                    info = (httpResponse.allHeaderFields["Authorization"] as? String)!
                } else {
                    info = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
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
    
    /*
     Request = "/customer/get-name" etc.
     json = your Dictionary Data to serialized as Json
     This function wil return response as Dictionary , error(If any) as String , and connectionError as Boolean
     Note : Eger sadece token gonderilecekse json nil olsun
     NUSRET OZATES
     */
    static func SendRequestGetDictionary(request : String ,json : Dictionary<String, Any>?) ->(info : Dictionary<String, Any>? , error: String? , connectionError : Bool)
    {
        let link = IP + request
        
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string:link)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "Authorization")
        
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false
        var info: [String: Any] = [:]
        
        var jsonData: Data
        var done = false
        
        do
        {
            if json != nil
            {
                jsonData = try JSONSerialization.data(withJSONObject: json!, options: [])
            }
            else
            {
                let newjson: [String: Any] = [:]
                jsonData = try JSONSerialization.data(withJSONObject: newjson, options: [])
            }
        }
        catch
        {
            print("Error: \(error.localizedDescription)")
            return (nil,error.localizedDescription,false)
        }
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            // I don't really know what this is for but I know it's important
            if error != nil {
                print("This is an error \(error!)")
                done = true
                httpFailure = error!.localizedDescription
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code = \(httpResponse.statusCode)")
                if((400...2999).contains(httpResponse.statusCode)) {
                    httpFailure = String(httpResponse.statusCode)
                    done = true
                    return
                }
                
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
    
}
