//
//  VideoService.swift
//  Movie Search
//
//  Created by Adeel on 8/21/22.
//

import Foundation
class VideoDataService: GenericService {
    
    func getData(movieID: Int , completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {
         
         //creating payload
         let requestBodyDict  = NSMutableDictionary()
         
        let jsonString = getJsonStringFromDictionary(requestBodyDict)
        let endPoint =  String(format:Constants.URLs.videoDetail,movieID)
        let request = createURLRequest(urlString: endPoint, requestType: .get, postData: jsonString,auth:false)
         
         let session = URLSession.shared
         let task = session.dataTask(with: request) { (data, urlResponse, error) in
             if (error != nil) {
                 //we got error from service
                 if let nsError = error as NSError? {
                     if (nsError.code == NSURLErrorTimedOut) {
                         failure(Constants.GenericStrings.requestTimedOut)
                     } else if (nsError.code == NSURLErrorCannotConnectToHost || nsError.code == NSURLErrorNetworkConnectionLost || nsError.code == NSURLErrorNotConnectedToInternet) {
                         failure(Constants.GenericStrings.internetNotFound)
                     } else {
                         failure(Constants.GenericStrings.somethingWentWrong)
                     }
                 } else {
                     failure(Constants.GenericStrings.somethingWentWrong)
                 }
                 
             } else {
                 
                 //chcek if json is valid and does not contain error key
                 let jsonString = String(data: data!, encoding:String.Encoding.utf8)
                 if(jsonString!.count == 0) {
                     //json is not valid
                     //show error message
                     failure(Constants.GenericStrings.somethingWentWrong)
                 } else {
                    var code = 0
                     if let httpResponse = urlResponse as? HTTPURLResponse {
                            print("statusCode: \(httpResponse.statusCode)")
                        code = httpResponse.statusCode
                        }
                    let errorMessages = self.checkIfErrorsExist(jsonString: jsonString ?? "",statusCode:code)
                     if errorMessages.count > 0 {
                         
                         //sending the first error only
                         failure(errorMessages[0])
                     } else {
                        let userData = self.parseUserInformationFromJsonString(jsonString: jsonString ?? "")
                         completion(userData)
                     }
                 }
             }
         }
         task.resume()
     }
}

extension VideoDataService {
    
    fileprivate func parseUserInformationFromJsonString (jsonString: String) -> [VideoDataModel] {
        
       var videoData = [VideoDataModel]()
        
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .allowFragments) as? [String: Any] {
                
                if let dataArray = dictionary["results"] as? [[String: Any]] {
                    var list = VideoDataModel()
                    for item in dataArray{
                        list = VideoDataModel()
                        if let value = item["iso_639_1"] as? String {
                            list.iso1 = value
                        }
                        if let value = item["iso_3166_1"] as? String {
                            list.iso2 = value
                        }
                        if let value = item["name"] as? String {
                            list.name = value
                        }
                        if let value = item["key"] as? String {
                            list.key = value
                        }
                        if let value = item["site"] as? String {
                            list.site = value
                        }
                        if let value = item["size"] as? Int {
                            list.size = value
                        }
                        if let value = item["type"] as? String {
                            list.type = value
                        }
                        if let value = item["official"] as? Bool {
                            list.official = value
                        }
                        if let value = item["published_at"] as? String {
                            list.publishedat = value
                        }
                        if let value = item["id"] as? String {
                            list.id = value
                        }
                      
                        videoData.append(list)
                    }
                }
            } else {
                //an exception has occured
                return videoData
            }
        } catch  {
            
            //an exception has occured
            return videoData
        }
        
        return videoData
    }
}
