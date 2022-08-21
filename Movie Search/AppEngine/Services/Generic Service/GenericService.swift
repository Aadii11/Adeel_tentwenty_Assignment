//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation

//RequestType
enum RequestType {
    case get
    case post
    case delete
    case put
}

class GenericService: Operation {
    
    //MARK:- URL Request
    func createURLRequest(urlString: String, requestType: RequestType, postData: String,auth:Bool) -> URLRequest {
        
        
        //Request
        let url = URL(string: Constants.ServiceConfiguration.baseURL + urlString)
        
        var request =  URLRequest(url: url!)
        
        //Post Data
        if (requestType == .post) {
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData.data(using: .utf8)
        } else if requestType == .put {
            
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData.data(using: .utf8)
        } else if requestType == .delete {
            
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData.data(using: .utf8)
        } else {
            
            request.httpMethod = "GET"
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        }
        
        //generic header
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        
        //adding the header
        if auth{
            if  let token  = UserDefaults.standard.string(forKey: "authToken"){
                    if token != "" {
                        request.addValue(String(format: "bearer %@", token), forHTTPHeaderField: "Authorization")
                }
            }

        }
      
            
        
        return request
    }
    
    
    //MARK:- Creating request payload
    //payload from dictionary
    func getJsonStringFromDictionary(_ dic:NSDictionary) -> String {
        var jsonString = String()
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonString = String(data: jsonData, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
            
        } catch {
            
        }
        return jsonString
    }
    
    //payload from Array
    func getJsonStringFromArray(_ array:NSArray)->String{
        var jsonString = String()
        
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonString = String(data: jsonData, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
        } catch {
            
        }
        return jsonString
    }
    
    func checkIfErrorsExist(jsonString: String,statusCode:Int) -> [String] {
        
        var errorMessages = [String]()
        
        do {
            if let responseDictionary = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .allowFragments) as? [String: Any] {
                
                 let status = statusCode
                    
                    if status == 500 {
                        if let errorMessage = responseDictionary["status_message"] as? String {
                            errorMessages.append(errorMessage)
                        } else {
                            errorMessages.append(Constants.GenericStrings.somethingWentWrong)
                        }
                    }
                    else  if status == 401 {
                        
                        if let errorMessage = responseDictionary["status_message"] as? String {
                            errorMessages.append(errorMessage)
                            //Here we can show alert and force user to login again.
                        } else {
                            errorMessages.append(Constants.GenericStrings.somethingWentWrong)
                        }
                    }
                    else if status != 200 {
                        if let errorMessage = responseDictionary["status_message"] as? String {
                            errorMessages.append(errorMessage)
                        } else {
                            errorMessages.append(Constants.GenericStrings.somethingWentWrong)
                        }
                    }
            }
        } catch  {
            
            //an exception has occured
            errorMessages.append(Constants.GenericStrings.somethingWentWrong)
        }

        return errorMessages
    }
}
