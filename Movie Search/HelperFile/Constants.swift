//
//  UpcomingMovieService.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation
import UIKit

typealias CompletionBlock = (_ result: Any?) -> Void
typealias FailureBlock = (_ errorString: String?) -> Void

struct Constants {
    
    struct ServiceConfiguration {
        
        static let baseURL = "https://api.themoviedb.org/3/"
        
        //This url extracted from the configuration api to get image base url and size as per TMDB documentaion
        static let imageBaseURL = "https://image.tmdb.org/t/p/w300/"
    }
    
    //MARK:- Generic Strings
    struct GenericStrings {
        
        //title
        static let alertTitle = "Movies"
        
        //buttons
        static let ok = "OK"
        
        static let yes = "Yes"
        
        static let no = "No"
        
        static let internetNotFound = "Please check your internet connection and try again"
        
        static let somethingWentWrong = "An error occurred while processing your request. Please try again in a little while"
        static let unAuthoriedRequest = "Unauthoried Request please login Again."
        
        static let requestTimedOut = "Your request has timed out."
        

    }
    
    //MARK:- Loading View Strings
    struct LoadingViewStrings {
      static let loading = "Loading..."
    }

    
    //MARK:- URLs
    struct URLs {
        //Api key is constant so i add this here genereted from TMDB account 
        static let upcomingMovies = "movie/upcoming?api_key=455155074d815186dedf243ea6032103&page=%d"
        static let moviedetail = "movie/%d?api_key=455155074d815186dedf243ea6032103"
        static let videoDetail = "movie/%d/videos?api_key=455155074d815186dedf243ea6032103"
        static let searchMovie = "search/movie?api_key=455155074d815186dedf243ea6032103&query=%@"
    }
}
