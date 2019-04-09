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
    
    static let IP = "http://172.17.24.98:8080"
    static var TOKEN = ""
    
    static func setToken(token: String){
        TOKEN = token
    
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
        // All code ın this function was written by ALP AKyÜZ
        /*
         Sets the ip type
         Ex:
         someone logging in will login to IP + /login
         /login is what the request type is
         
        */
        
        let link = IP + requestType
        
        
        // Defines the url, session and request which are in turn where you connect to and then creates a sessions which is where all of the information is exchanged and finally the request which has the json inside of it
        
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string:link)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15	)
        
        // There are multiple letpMethods, this one uses the post method which is used to send and recieve information to and from the server
        
        request.httpMethod = "POST"
        
        // Here you specify what goes in the header

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // If the requestType isn't a login then a token is required for every action
        
        if(requestType != "/login"){
            request.setValue(TOKEN, forHTTPHeaderField: "Authorization")
        }
        
        // If an http error occures then it will be saved into this string. This string is then later checked
        var httpFailure = ""
        
        // If the server can not connect to the server this boolean will be set to true. This is also later checked
        var connectionFailure = false
        
        // This is the string that the server will give back
        var info: String?
        
        // he json file is first initalized as a dictionary using the given parameter
        var jsonData: Data
        
        // Marks if the interaction with the server is done
        var done = false
        
        // This is where the json dictionary is converted to a an actual json file
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
            
            // This is if you connect to the server but get an error of any sort.
            // The error is printed to the console and returned later in the httpFailure value
            if error != nil {
                print("This is an error \(error!)")
                done = true
                httpFailure = error!.localizedDescription
                return
            }
            
            // The server sends a response which contains the http error code and all of the headers in the response
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code = \(httpResponse.statusCode)")
                if((400...2999).contains(httpResponse.statusCode)) {
                    httpFailure = String(httpResponse.statusCode)
                    done = true
                    return
                }
                
                //Here the string given back from the server is read
                info = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
                done = true
                
            } else {
                connectionFailure = true
            }
        }
        
        // The task above is not started until the resume method is called on it
        task.resume()
        
         // I believe that the task is started on a different thread. For this reason I wait until I get a response
        /*
         Waits until either
         a) Waited 500000 units of time OR
         b) done is d=set to true indicating that a response has been received
        */
        var waitedTime = 0
        while done == false {
            print(waitedTime)
            if waitedTime > 50 {
                task.cancel()
                // Return Connection Timeout if it has waited 500000 units of time
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
        
        // This is the all clear return if the code got to here then there are no problems
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
        // All code written in this function was written by
        // ALP AKYÜZ
        // For explanations see the function above
        
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
