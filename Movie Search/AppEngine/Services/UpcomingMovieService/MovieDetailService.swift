//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation

class MovieDetailService: GenericService {
    
    func getDetail(id: Int , completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {
         
         //creating payload
         let requestBodyDict  = NSMutableDictionary()
         
        let jsonString = getJsonStringFromDictionary(requestBodyDict)
        let endPoint =  String(format:Constants.URLs.moviedetail,id)
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

extension MovieDetailService {
    
    fileprivate func parseUserInformationFromJsonString (jsonString: String) -> MovieDetailModel {
        
       var movieData = MovieDetailModel()
        
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .allowFragments) as? [String: Any] {
                
                if let val = dictionary["id"] as? Int {
                    movieData.id = val
                }
                if let val = dictionary["original_language"] as? String {
                    movieData.orignalLanguage = val
                }
                if let val = dictionary["original_title"] as? String {
                    movieData.orignalTitle = val
                }
                if let val = dictionary["overview"] as? String {
                    movieData.overView = val
                }
                if let val = dictionary["poster_path"] as? String {
                    movieData.posterPath = Constants.ServiceConfiguration.imageBaseURL+val
                }
                if let val = dictionary["release_date"] as? String {
                    movieData.releaseDate = val
                }
                if let val = dictionary["title"] as? String {
                    movieData.title = val
                }
                if let generData = dictionary["genres"] as? [[String: Any]] {
                    var list = Geners()
                    for item in generData{
                        list = Geners()
                        
                        if let value = item["id"] as? Int {
                            list.id = value
                        }
                        if let value = item["name"] as? String {
                            list.name = value
                        }
                    
                        movieData.geners.append(list)
                    }
                }
                
                
            } else {
                //an exception has occured
                return movieData
            }
        } catch  {
            
            //an exception has occured
            return movieData
        }
        
        return movieData
    }
}

