//
//  MovieDetailDataModel.swift
//  Movie Search
//
//  Created by Adeel on 8/20/22.
//

import Foundation
struct MovieDetailModel{
    var id = 0
    var geners = [Geners]()
    var orignalLanguage = ""
    var orignalTitle = ""
    var overView = ""
    var posterPath = ""
    var releaseDate = ""
    var title = ""
}
struct Geners{
    var id = 0
    var name = ""
}
