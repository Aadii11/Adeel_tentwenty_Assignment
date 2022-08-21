//
//  UpcomingMovieDataModel.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation
struct MoviesModel{
    var page = 0
    var totalpage = 0
    var totalResult = 0
    var upComingMoviesData = [UpcomimgMoviesModel]()
}
struct UpcomimgMoviesModel{
    
    var adult = false
    var backdropPath = ""
    var generId = [Int]()
    var id = 0
    var orignalLanguage = ""
    var orignalTitle = ""
    var overView = ""
    var popularity = 0.0
    var posterPath = ""
    var releaseDate = ""
    var title = ""
    var video = false
    var voteAvg = 0.0
    var voteCount = 0
}
