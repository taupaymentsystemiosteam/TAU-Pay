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
    
    static let IP = "http://88.251.76.225:50090"
    static let TOKEN = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxNjA1MDMxMzkiLCJleHAiOjE1NTQ5Njg4NTB9.Maaj88j5QQkYFq0p94Pqnw1LYsmdGIGR6CQ4j1WEoixED4E_ze9MRlc_W4b-4Ru9pnYC8hdOviRb3B3PFF1D9w"
    
    /*
        Request = "/customer/get-name" etc.
        json = your Dictionary Data to serialized as Json
        isStringReturned = What will your request returned  , if true function will work like String will return from server else JSON DATA
     
     Note : Suan sadece String dondurece sekilde calisiyor duzeltilecek , eger sadece token gonderilecekse json nil olsun , nil oldugu durum icin fonksiyonu ayri olarak ayarlayacagim.
     
     NUSRET OZATES
 */
    static func SendRequest(request : String ,json : Dictionary<String, Any>, isStringReturned : Bool) ->(info : String? , error: String? , connectionError : Bool)
    {
        
        let link = IP + request
        
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string:link)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "Authorization")
        
        var jsonData: Data
        var done = false
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            print("Error: \(error.localizedDescription)")
            return (nil,error.localizedDescription,false)
        }
        
        var httpFailure = ""
        // If the server unsucessfully connects to the server then this boolean will be set to true
        var connectionFailure = false
        var info: String?
        
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
                
                info = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
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
