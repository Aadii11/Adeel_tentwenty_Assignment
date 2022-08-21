//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation


class MoviesListService: GenericService {
    
    func getData(page: Int ,isFromSearch : Bool = false,query:String = "", completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {
         
         //creating payload
         let requestBodyDict  = NSMutableDictionary()
         
        let jsonString = getJsonStringFromDictionary(requestBodyDict)
        var endPoint = ""
        //This api is for both upcoming and movie search end point changed on basis of requirement
        if isFromSearch{
            endPoint =  String(format:Constants.URLs.searchMovie,query)
            endPoint = endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }else{
            endPoint =  String(format:Constants.URLs.upcomingMovies,page)
        }
         
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

extension MoviesListService {
    
    fileprivate func parseUserInformationFromJsonString (jsonString: String) -> MoviesModel {
        
       var movieData = MoviesModel()
        
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .allowFragments) as? [String: Any] {
                
                if let val = dictionary["page"] as? Int {
                    movieData.page = val
                }
                if let val = dictionary["total_pages"] as? Int {
                    movieData.totalpage = val
                }
                if let val = dictionary["total_results"] as? Int {
                    movieData.totalResult = val
                }
                if let dataArray = dictionary["results"] as? [[String: Any]] {
                    var list = UpcomimgMoviesModel()
                    for item in dataArray{
                        list = UpcomimgMoviesModel()
                        if let value = item["adult"] as? Bool {
                            list.adult = value
                        }
                        if let value = item["backdrop_path"] as? String {
                            list.backdropPath = Constants.ServiceConfiguration.imageBaseURL+value
                        }
                        if let value = item["id"] as? Int {
                            list.id = value
                        }
                        if let value = item["original_language"] as? String {
                            list.orignalLanguage = value
                        }
                        if let value = item["original_title"] as? String {
                            list.orignalTitle = value
                        }
                        if let value = item["overview"] as? String {
                            list.overView = value
                        }
                        if let value = item["popularity"] as? Double {
                            list.popularity = value
                        }
                        if let value = item["poster_path"] as? String {
                            list.posterPath = value
                        }
                        if let value = item["release_date"] as? String {
                            list.releaseDate = value
                        }
                        if let value = item["title"] as? String {
                            list.title = value
                        }
                        if let value = item["video"] as? Bool {
                            list.video = value
                        }
                        if let value = item["vote_average"] as? Double {
                            list.voteAvg = value
                        }
                        if let value = item["vote_count"] as? Int {
                            list.voteCount = value
                        }
                      
                        movieData.upComingMoviesData.append(list)
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
